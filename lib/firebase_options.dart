// File generated based on google-services.json configuration
// This file contains the Firebase configuration for different platforms.
//
// IMPORTANT: Replace these placeholder values with your actual Firebase config
// from the Firebase Console (https://console.firebase.google.com/)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8K9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z',
    appId: '1:860223498020:web:2707389e63251f26e435b1',
    messagingSenderId: '860223498020',
    projectId: 'smartfoodorder-34a3b',
    authDomain: 'smartfoodorder-34a3b.firebaseapp.com',
    storageBucket: 'smartfoodorder-34a3b.appspot.com',
  );

  // Android configuration (from google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8K9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z',
    appId: '1:860223498020:android:2707389e63251f26e435b1',
    messagingSenderId: '860223498020',
    projectId: 'smartfoodorder-34a3b',
    storageBucket: 'smartfoodorder-34a3b.appspot.com',
  );

  // iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8K9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z8Z9Z',
    appId: '1:860223498020:ios:2707389e63251f26e435b1',
    messagingSenderId: '860223498020',
    projectId: 'smartfoodorder-34a3b',
    storageBucket: 'smartfoodorder-34a3b.appspot.com',
    iosBundleId: 'com.fitflow.fitnessAssistant',
  );

  // macOS configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopment',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'smart-food-ordering-placeholder',
    storageBucket: 'smart-food-ordering-placeholder.appspot.com',
    iosBundleId: 'com.example.smartFoodOrderingNutritionAssistant',
  );

  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForDevelopment',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'smart-food-ordering-placeholder',
    storageBucket: 'smart-food-ordering-placeholder.appspot.com',
  );
}
