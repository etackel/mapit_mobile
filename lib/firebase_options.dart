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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDwGd_npZ57_pG4erXuS2qtPg90dJzyBPY',
    appId: '1:24985500781:web:0c334e3daeb04326c79364',
    messagingSenderId: '24985500781',
    projectId: 'mapit-a4712',
    authDomain: 'mapit-a4712.firebaseapp.com',
    storageBucket: 'mapit-a4712.appspot.com',
    measurementId: 'G-67WF8DHJ74',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsgxuhF5g6jb9bY1gtsp2c9dXxvkttEJ4',
    appId: '1:24985500781:android:fa2431fdb5c9bc28c79364',
    messagingSenderId: '24985500781',
    projectId: 'mapit-a4712',
    storageBucket: 'mapit-a4712.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp_kd3pGJohccHdUzT5EqzVQnN2uqUhyY',
    appId: '1:24985500781:ios:047357bdf4074b65c79364',
    messagingSenderId: '24985500781',
    projectId: 'mapit-a4712',
    storageBucket: 'mapit-a4712.appspot.com',
    iosBundleId: 'com.etackel.mapit',
  );
}