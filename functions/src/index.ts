import { createHash, randomBytes } from "node:crypto";
import { initializeApp } from "firebase-admin/app";
import {
  FieldValue,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2";

initializeApp();
setGlobalOptions({ region: "southamerica-east1" });

const db = getFirestore();
const inviteLifetimeMs = 60 * 60 * 1000;

type CallableData = Record<string, unknown>;

function requireAuthUid(uid: string | undefined): string {
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
  return uid;
}

function requireString(
  data: CallableData,
  key: string,
  minimumLength: number,
  maximumLength: number,
): string {
  const value = data[key];
  if (typeof value !== "string") {
    throw new HttpsError("invalid-argument", `${key} must be a string.`);
  }
  const normalized = value.trim();
  if (normalized.length < minimumLength || normalized.length > maximumLength) {
    throw new HttpsError("invalid-argument", `${key} has an invalid length.`);
  }
  return normalized;
}

function requirePublicKey(data: CallableData, key: string): string {
  const value = requireString(data, key, 40, 100);
  if (!/^[A-Za-z0-9_-]{43}=?$/.test(value)) {
    throw new HttpsError("invalid-argument", `${key} must be a base64url-encoded 32-byte key.`);
  }
  let bytes: Buffer;
  try {
    bytes = Buffer.from(value, "base64url");
  } catch {
    throw new HttpsError("invalid-argument", `${key} is invalid.`);
  }
  if (bytes.length !== 32) {
    throw new HttpsError("invalid-argument", `${key} must encode 32 bytes.`);
  }
  return value;
}

function requireMemberUuid(data: CallableData): string {
  const value = requireString(data, "memberUuid", 36, 36);
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value)) {
    throw new HttpsError("invalid-argument", "memberUuid must be a UUID v4.");
  }
  return value;
}

function inviteDigest(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

async function requireAdministrator(uid: string, groupId: string) {
  const member = await db.doc(`groups/${groupId}/members/${uid}`).get();
  if (!member.exists || member.get("status") !== "approved" || member.get("role") !== "administrator") {
    throw new HttpsError("permission-denied", "Only the group administrator can perform this action.");
  }
  return member;
}

export const createFamilyGroup = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const name = requireString(request.data, "name", 1, 80);
  const memberUuid = requireMemberUuid(request.data);
  const currency = requireString(request.data, "currency", 3, 3).toUpperCase();
  const signingPublicKey = requirePublicKey(request.data, "signingPublicKey");
  const encryptionPublicKey = requirePublicKey(request.data, "encryptionPublicKey");
  if (!/^[A-Z]{3}$/.test(currency)) {
    throw new HttpsError("invalid-argument", "currency must be a three-letter code.");
  }

  const groupRef = db.collection("groups").doc();
  const memberRef = groupRef.collection("members").doc(uid);
  const userRef = db.doc(`users/${uid}`);
  const now = FieldValue.serverTimestamp();
  await db.runTransaction(async (transaction) => {
    const user = await transaction.get(userRef);
    if (user.exists && user.get("groupId")) {
      throw new HttpsError("failed-precondition", "This account already belongs to a family group.");
    }
    transaction.create(groupRef, {
      administratorUid: uid,
      currency,
      createdAt: now,
    });
    transaction.create(memberRef, {
      uid,
      memberUuid,
      name,
      role: "administrator",
      status: "approved",
      signingPublicKey,
      encryptionPublicKey,
      joinedAt: now,
    });
    transaction.set(userRef, { groupId: groupRef.id }, { merge: true });
  });
  return { groupId: groupRef.id, uid, role: "administrator", currency };
});

export const createFamilyInvite = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const groupId = requireString(request.data, "groupId", 1, 128);
  await requireAdministrator(uid, groupId);

  const token = randomBytes(32).toString("base64url");
  const now = Date.now();
  await db.doc(`invites/${inviteDigest(token)}`).create({
    groupId,
    createdBy: uid,
    createdAt: Timestamp.fromMillis(now),
    expiresAt: Timestamp.fromMillis(now + inviteLifetimeMs),
    consumedBy: null,
    consumedAt: null,
  });
  return {
    token,
    expiresAt: new Date(now + inviteLifetimeMs).toISOString(),
  };
});

export const requestFamilyJoin = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const token = requireString(request.data, "token", 20, 100);
  const name = requireString(request.data, "name", 1, 80);
  const memberUuid = requireMemberUuid(request.data);
  const signingPublicKey = requirePublicKey(request.data, "signingPublicKey");
  const encryptionPublicKey = requirePublicKey(request.data, "encryptionPublicKey");
  const inviteRef = db.doc(`invites/${inviteDigest(token)}`);
  const userRef = db.doc(`users/${uid}`);
  const requestRef = db.collection("joinRequests").doc();
  const now = Timestamp.now();

  await db.runTransaction(async (transaction) => {
    const [invite, user] = await Promise.all([
      transaction.get(inviteRef),
      transaction.get(userRef),
    ]);
    if (!invite.exists || invite.get("expiresAt").toMillis() <= now.toMillis()) {
      throw new HttpsError("failed-precondition", "The invitation is invalid or expired.");
    }
    if (invite.get("consumedBy")) {
      throw new HttpsError("failed-precondition", "The invitation has already been used.");
    }
    if (user.exists && user.get("groupId")) {
      throw new HttpsError("failed-precondition", "This account already belongs to a family group.");
    }
    const groupId = invite.get("groupId") as string;
    transaction.update(inviteRef, {
      consumedBy: uid,
      consumedAt: now,
    });
    transaction.create(requestRef, {
      groupId,
      uid,
      memberUuid,
      name,
      signingPublicKey,
      encryptionPublicKey,
      status: "pending",
      createdAt: now,
    });
    transaction.set(userRef, {
      groupId,
      joinRequestId: requestRef.id,
    }, { merge: true });
  });
  return { requestId: requestRef.id, status: "pending" };
});

export const getMyFamilyState = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const user = await db.doc(`users/${uid}`).get();
  if (!user.exists || !user.get("groupId")) {
    return { status: "none" };
  }

  const groupId = user.get("groupId") as string;
  const member = await db.doc(`groups/${groupId}/members/${uid}`).get();
  if (member.exists && member.get("status") === "approved") {
    const group = await db.doc(`groups/${groupId}`).get();
    return {
      status: "approved",
      groupId,
      currency: group.get("currency"),
      role: member.get("role"),
      memberUuid: member.get("memberUuid"),
      name: member.get("name"),
    };
  }
  return {
    status: "pending",
    groupId,
    requestId: user.get("joinRequestId"),
  };
});

export const listFamilyJoinRequests = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const groupId = requireString(request.data, "groupId", 1, 128);
  await requireAdministrator(uid, groupId);
  const requests = await db.collection("joinRequests")
    .where("groupId", "==", groupId)
    .where("status", "==", "pending")
    .orderBy("createdAt", "asc")
    .get();
  return {
    requests: requests.docs.map((doc) => ({
      requestId: doc.id,
      uid: doc.get("uid"),
      name: doc.get("name"),
      createdAt: doc.get("createdAt")?.toDate().toISOString(),
    })),
  };
});

export const resolveFamilyJoinRequest = onCall(async (request) => {
  const uid = requireAuthUid(request.auth?.uid);
  const requestId = requireString(request.data, "requestId", 1, 128);
  const approve = request.data.approve;
  if (typeof approve !== "boolean") {
    throw new HttpsError("invalid-argument", "approve must be a boolean.");
  }
  const requestRef = db.doc(`joinRequests/${requestId}`);
  await db.runTransaction(async (transaction) => {
    const joinRequest = await transaction.get(requestRef);
    if (!joinRequest.exists || joinRequest.get("status") !== "pending") {
      throw new HttpsError("not-found", "The join request is no longer pending.");
    }
    const groupId = joinRequest.get("groupId") as string;
    const groupRef = db.doc(`groups/${groupId}`);
    const memberRef = groupRef.collection("members").doc(uid);
    const groupMember = await transaction.get(memberRef);
    if (!groupMember.exists ||
        groupMember.get("status") !== "approved" ||
        groupMember.get("role") !== "administrator") {
      throw new HttpsError("permission-denied", "Only the group administrator can resolve join requests.");
    }
    const targetUid = joinRequest.get("uid") as string;
    const duplicateMemberUuids = await transaction.get(
      groupRef.collection("members")
        .where("memberUuid", "==", joinRequest.get("memberUuid")),
    );
    if (!duplicateMemberUuids.empty) {
      throw new HttpsError("already-exists", "This member UUID is already in use.");
    }
    const targetMemberRef = groupRef.collection("members").doc(targetUid);
    const targetUserRef = db.doc(`users/${targetUid}`);
    if (approve) {
      transaction.create(targetMemberRef, {
        uid: targetUid,
        memberUuid: joinRequest.get("memberUuid"),
        name: joinRequest.get("name"),
        role: "member",
        status: "approved",
        signingPublicKey: joinRequest.get("signingPublicKey"),
        encryptionPublicKey: joinRequest.get("encryptionPublicKey"),
        joinedAt: FieldValue.serverTimestamp(),
      });
      transaction.set(targetUserRef, {
        groupId,
        joinRequestId: FieldValue.delete(),
      }, { merge: true });
    } else {
      transaction.update(targetUserRef, {
        groupId: FieldValue.delete(),
        joinRequestId: FieldValue.delete(),
      });
    }
    transaction.update(requestRef, {
      status: approve ? "approved" : "rejected",
      resolvedBy: uid,
      resolvedAt: FieldValue.serverTimestamp(),
    });
  });
  return { status: approve ? "approved" : "rejected" };
});
