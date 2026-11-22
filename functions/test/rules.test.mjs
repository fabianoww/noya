import { readFile } from "node:fs/promises";
import { after, before, test } from "node:test";
import {
  assertFails,
  initializeTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  doc,
  getDoc,
  setDoc,
} from "firebase/firestore";

let environment;

before(async () => {
  environment = await initializeTestEnvironment({
    projectId: "demo-noya",
    firestore: {
      host: "127.0.0.1",
      port: 8080,
      rules: await readFile(new URL("../../firestore.rules", import.meta.url), "utf8"),
    },
  });
});

after(async () => {
  await environment.cleanup();
});

test("authenticated clients cannot access family or invitation documents directly", async () => {
  const firestore = environment.authenticatedContext("test-member").firestore();
  const protectedPaths = [
    "groups/test-group",
    "groups/test-group/members/test-member",
    "invites/test-invite",
    "joinRequests/test-request",
    "users/test-member",
  ];

  for (const path of protectedPaths) {
    const reference = doc(firestore, path);
    await assertFails(getDoc(reference));
    await assertFails(setDoc(reference, { unauthorized: true }));
  }
});
