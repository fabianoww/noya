import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseEmulatorService {
  FirebaseEmulatorService._();

  static const enabled = bool.fromEnvironment('USE_FIREBASE_EMULATOR');
  static const emulatorHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: '10.0.2.2',
  );
  static const emulatorApiKey = 'AIzaSyDEMO-NOYA-EMULATOR-ONLY-000000000';
  static const projectId = 'demo-noya';
  static const region = 'southamerica-east1';
  static const _emulatorPort = 9099;
  static bool _initialized = false;

  static bool get isEnabled => enabled && _initialized;

  static Future<void> initialize() async {
    if (!enabled) {
      return;
    }
    if (!kDebugMode) {
      throw StateError(
        'Emulator configuration is disabled outside debug builds.',
      );
    }
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError(
        'The Firebase Emulator setup currently supports the Android Emulator only.',
      );
    }

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: emulatorApiKey,
        appId: '1:1234567890:android:demo',
        messagingSenderId: '1234567890',
        projectId: projectId,
      ),
    );
    const host = emulatorHost;
    await FirebaseAuth.instance.useAuthEmulator(
      host,
      _emulatorPort,
      automaticHostMapping: false,
    );
    FirebaseFirestore.instance.useFirestoreEmulator(
      host,
      8080,
      automaticHostMapping: false,
    );
    FirebaseFunctions.instanceFor(
      region: region,
    ).useFunctionsEmulator(host, 5001, automaticHostMapping: false);
    _initialized = true;
  }
}
