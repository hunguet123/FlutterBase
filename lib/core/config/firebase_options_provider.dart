import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'env.dart';
import 'env_prod.dart';

/// Provides [FirebaseOptions] from env based on build flavor.
/// Uses [Env] for development, [EnvProd] for production.
abstract final class FirebaseOptionsProvider {
  FirebaseOptionsProvider._();

  static const _flavor = String.fromEnvironment(
    'FLUTTER_APP_FLAVOR',
    defaultValue: 'development',
  );

  static bool get _isProduction => _flavor == 'production';

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'FirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get android {
    if (_isProduction) {
      return FirebaseOptions(
        apiKey: EnvProd.firebaseAndroidApiKey,
        appId: EnvProd.firebaseAndroidAppId,
        messagingSenderId: EnvProd.firebaseMessagingSenderId,
        projectId: EnvProd.firebaseProjectId,
        storageBucket: EnvProd.firebaseStorageBucket,
      );
    }
    return FirebaseOptions(
      apiKey: Env.firebaseAndroidApiKey,
      appId: Env.firebaseAndroidAppId,
      messagingSenderId: Env.firebaseMessagingSenderId,
      projectId: Env.firebaseProjectId,
      storageBucket: Env.firebaseStorageBucket,
    );
  }

  static FirebaseOptions get ios {
    if (_isProduction) {
      return FirebaseOptions(
        apiKey: EnvProd.firebaseIosApiKey,
        appId: EnvProd.firebaseIosAppId,
        messagingSenderId: EnvProd.firebaseMessagingSenderId,
        projectId: EnvProd.firebaseProjectId,
        storageBucket: EnvProd.firebaseStorageBucket,
        iosBundleId: EnvProd.firebaseIosBundleId,
      );
    }
    return FirebaseOptions(
      apiKey: Env.firebaseIosApiKey,
      appId: Env.firebaseIosAppId,
      messagingSenderId: Env.firebaseMessagingSenderId,
      projectId: Env.firebaseProjectId,
      storageBucket: Env.firebaseStorageBucket,
      iosBundleId: Env.firebaseIosBundleId,
    );
  }
}
