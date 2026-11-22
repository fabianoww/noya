import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noya2/services/family_identity_service.dart';
import 'package:noya2/services/firebase_emulator_service.dart';

class FamilyCloudService {
  FamilyCloudService._();

  static FirebaseFunctions get _functions =>
      FirebaseFunctions.instanceFor(region: FirebaseEmulatorService.region);

  static Future<void> ensureSignedIn() async {
    if (!FirebaseEmulatorService.isEnabled) {
      throw StateError('Firebase Emulator is not enabled.');
    }
    final hasStoredIdentity = await FamilyIdentityService.hasStoredIdentity();
    if (FirebaseAuth.instance.currentUser != null && !hasStoredIdentity) {
      await FirebaseAuth.instance.signOut();
    }
    var user = FirebaseAuth.instance.currentUser;
    user ??= (await FirebaseAuth.instance.signInAnonymously()).user;
    if (user == null) {
      throw StateError(
        'Anonymous Firebase authentication did not return a user.',
      );
    }
    await FamilyIdentityService.loadOrCreate(firebaseUid: user.uid);
  }

  static Future<FamilyIdentity> get _identity async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Anonymous Firebase authentication is not active.');
    }
    return FamilyIdentityService.loadOrCreate(firebaseUid: uid);
  }

  static Future<Map<String, dynamic>> createGroup({
    required String name,
    required String currency,
  }) async {
    final identity = await _identity;
    return _call('createFamilyGroup', {
      'name': name,
      'currency': currency,
      'memberUuid': identity.memberUuid,
      'signingPublicKey': identity.signingPublicKey,
      'encryptionPublicKey': identity.encryptionPublicKey,
    });
  }

  static Future<Map<String, dynamic>> createInvite(String groupId) =>
      _call('createFamilyInvite', {'groupId': groupId});

  static Future<Map<String, dynamic>> requestJoin({
    required String token,
    required String name,
  }) async {
    final identity = await _identity;
    return _call('requestFamilyJoin', {
      'token': token,
      'name': name,
      'memberUuid': identity.memberUuid,
      'signingPublicKey': identity.signingPublicKey,
      'encryptionPublicKey': identity.encryptionPublicKey,
    });
  }

  static Future<Map<String, dynamic>> getState() =>
      _call('getMyFamilyState', const {});

  static Future<List<Map<String, dynamic>>> listJoinRequests(
    String groupId,
  ) async {
    final result = await _call('listFamilyJoinRequests', {'groupId': groupId});
    final requests = result['requests'];
    if (requests is! List) {
      throw StateError('The server returned an invalid join-request list.');
    }
    return requests.map((request) {
      if (request is! Map) {
        throw StateError('The server returned an invalid join request.');
      }
      return Map<String, dynamic>.from(request);
    }).toList();
  }

  static Future<void> resolveJoinRequest({
    required String requestId,
    required bool approve,
  }) async {
    await _call('resolveFamilyJoinRequest', {
      'requestId': requestId,
      'approve': approve,
    });
  }

  static Future<Map<String, dynamic>> _call(
    String name,
    Map<String, dynamic> data,
  ) async {
    final result = await _functions.httpsCallable(name).call(data);
    if (result.data is! Map) {
      throw StateError('The server returned an invalid response for $name.');
    }
    return Map<String, dynamic>.from(result.data as Map);
  }
}
