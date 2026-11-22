import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:noya2/services/family_service.dart';

class FamilyIdentity {
  const FamilyIdentity({
    required this.memberUuid,
    required this.firebaseUid,
    required this.signingPublicKey,
    required this.encryptionPublicKey,
  });

  final String memberUuid;
  final String firebaseUid;
  final String signingPublicKey;
  final String encryptionPublicKey;
}

class FamilyIdentityService {
  FamilyIdentityService._();

  static const _storage = FlutterSecureStorage();
  static const _identityKey = 'family_identity_v1';

  static Future<bool> hasStoredIdentity() async =>
      await _storage.read(key: _identityKey) != null;

  static Future<FamilyIdentity> loadOrCreate({
    required String firebaseUid,
  }) async {
    final storedIdentity = await _storage.read(key: _identityKey);
    if (storedIdentity != null) {
      final decoded = jsonDecode(storedIdentity);
      if (decoded is! Map<String, dynamic> ||
          decoded['memberUuid'] is! String ||
          decoded['firebaseUid'] is! String ||
          decoded['signingPrivateKey'] is! String ||
          decoded['signingPublicKey'] is! String ||
          decoded['encryptionPrivateKey'] is! String ||
          decoded['encryptionPublicKey'] is! String) {
        throw StateError('The locally stored family identity is invalid.');
      }
      if (decoded['firebaseUid'] != firebaseUid) {
        throw StateError(
          'The stored family identity belongs to a different Firebase account.',
        );
      }
      return FamilyIdentity(
        memberUuid: decoded['memberUuid'] as String,
        firebaseUid: firebaseUid,
        signingPublicKey: decoded['signingPublicKey'] as String,
        encryptionPublicKey: decoded['encryptionPublicKey'] as String,
      );
    }

    final signingKeyPair = await Ed25519().newKeyPair();
    final encryptionKeyPair = await X25519().newKeyPair();
    final signingPrivateBytes = await signingKeyPair.extractPrivateKeyBytes();
    final signingPublicBytes = await signingKeyPair.extractPublicKey();
    final encryptionPrivateBytes = await encryptionKeyPair
        .extractPrivateKeyBytes();
    final encryptionPublicBytes = await encryptionKeyPair.extractPublicKey();
    final identity = FamilyIdentity(
      memberUuid: FamilyService.newUuid(),
      firebaseUid: firebaseUid,
      signingPublicKey: base64Url.encode(signingPublicBytes.bytes),
      encryptionPublicKey: base64Url.encode(encryptionPublicBytes.bytes),
    );

    await _storage.write(
      key: _identityKey,
      value: jsonEncode({
        'memberUuid': identity.memberUuid,
        'firebaseUid': identity.firebaseUid,
        'signingPrivateKey': base64Url.encode(signingPrivateBytes),
        'signingPublicKey': identity.signingPublicKey,
        'encryptionPrivateKey': base64Url.encode(encryptionPrivateBytes),
        'encryptionPublicKey': identity.encryptionPublicKey,
      }),
    );
    return identity;
  }
}
