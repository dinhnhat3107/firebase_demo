// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCz6YrtpGyvZ2SYlrIbak4OQldCckUBJUU',
    appId: '1:13087684179:web:f9d5aae5ccc263f63f38a6',
    messagingSenderId: '13087684179',
    projectId: 'firestoredemo-a30a8',
    authDomain: 'firestoredemo-a30a8.firebaseapp.com',
    storageBucket: 'firestoredemo-a30a8.firebasestorage.app',
    measurementId: 'G-ZQRES2S9Q5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA57-acpbLCgcFpw_KKNSBs8puOFA8gYxU',
    appId: '1:13087684179:android:6ff57cc713cb434e3f38a6',
    messagingSenderId: '13087684179',
    projectId: 'firestoredemo-a30a8',
    storageBucket: 'firestoredemo-a30a8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3n7vFEMGk44TMZ_jQLIhXK5W2RMMxfmU',
    appId: '1:13087684179:ios:44911097fd6be4cb3f38a6',
    messagingSenderId: '13087684179',
    projectId: 'firestoredemo-a30a8',
    storageBucket: 'firestoredemo-a30a8.firebasestorage.app',
    iosBundleId: 'com.example.firestoreDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA3n7vFEMGk44TMZ_jQLIhXK5W2RMMxfmU',
    appId: '1:13087684179:ios:44911097fd6be4cb3f38a6',
    messagingSenderId: '13087684179',
    projectId: 'firestoredemo-a30a8',
    storageBucket: 'firestoredemo-a30a8.firebasestorage.app',
    iosBundleId: 'com.example.firestoreDemo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCz6YrtpGyvZ2SYlrIbak4OQldCckUBJUU',
    appId: '1:13087684179:web:bb68c24828f798943f38a6',
    messagingSenderId: '13087684179',
    projectId: 'firestoredemo-a30a8',
    authDomain: 'firestoredemo-a30a8.firebaseapp.com',
    storageBucket: 'firestoredemo-a30a8.firebasestorage.app',
    measurementId: 'G-S6C2KGVZ06',
  );

}