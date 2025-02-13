// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAw2heFIeHuEj8ZzCux0rlcX_tI05kiLoQ',
    appId: '1:695965162771:web:04c649746f62462dda4ee6',
    messagingSenderId: '695965162771',
    projectId: 'recycle-challenge',
    authDomain: 'recycle-challenge.firebaseapp.com',
    storageBucket: 'recycle-challenge.appspot.com',
    measurementId: 'G-YCZD463D5C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB99VogaboChF-Ma-p8nRDUCnHMv_qHdng',
    appId: '1:695965162771:android:dcfa0b0ab649628bda4ee6',
    messagingSenderId: '695965162771',
    projectId: 'recycle-challenge',
    storageBucket: 'recycle-challenge.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDF1lLmchdL0rxRFahrVv65_LP0YDD5XHc',
    appId: '1:695965162771:ios:b5dfe8f376ee7bf4da4ee6',
    messagingSenderId: '695965162771',
    projectId: 'recycle-challenge',
    storageBucket: 'recycle-challenge.appspot.com',
    iosBundleId: 'com.example.card',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDF1lLmchdL0rxRFahrVv65_LP0YDD5XHc',
    appId: '1:695965162771:ios:a8206a732e2bcbd6da4ee6',
    messagingSenderId: '695965162771',
    projectId: 'recycle-challenge',
    storageBucket: 'recycle-challenge.appspot.com',
    iosBundleId: 'com.example.card.RunnerTests',
  );
}
