// File generated from Firebase CLI config for the provider flavor.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class ProviderFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase options are not configured for web.');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase options are not configured for this platform.',
        );
      default:
        throw UnsupportedError(
          'Firebase options are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4rodTM8qBFWiI8lSNCub2HbLRs7xM37w',
    appId: '1:1038065577213:android:ac4cb450a7afc83d37a294',
    messagingSenderId: '1038065577213',
    projectId: 'dyifitkym-43ebd',
    storageBucket: 'dyifitkym-43ebd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChhht4ozDFE9VpiVqVUZTsvYrD7KMuIWg',
    appId: '1:1038065577213:ios:7264bd9ad0bc89e437a294',
    messagingSenderId: '1038065577213',
    projectId: 'dyifitkym-43ebd',
    storageBucket: 'dyifitkym-43ebd.firebasestorage.app',
    iosBundleId: 'com.daem.diyafatukum.provider',
  );
}
