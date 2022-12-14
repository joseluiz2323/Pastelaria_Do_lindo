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
    apiKey: 'AIzaSyAq5Nx-3QAnCx5_RYlZWeiWcBJtIoFCHS0',
    appId: '1:281322731389:web:e12dcb4fd7fc8bdb93be14',
    messagingSenderId: '281322731389',
    projectId: 'pastelaria-do-lindo',
    authDomain: 'pastelaria-do-lindo.firebaseapp.com',
    databaseURL: 'https://pastelaria-do-lindo-default-rtdb.firebaseio.com',
    storageBucket: 'pastelaria-do-lindo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2o0dItiOwIGcfpxjh1uPKQWwrpnQbmzg',
    appId: '1:281322731389:android:89f744db07ba159b93be14',
    messagingSenderId: '281322731389',
    projectId: 'pastelaria-do-lindo',
    databaseURL: 'https://pastelaria-do-lindo-default-rtdb.firebaseio.com',
    storageBucket: 'pastelaria-do-lindo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1-jcplV1d_1gePn2PdjX_fS8t84mXPhI',
    appId: '1:281322731389:ios:2ea53d2c56a21c8893be14',
    messagingSenderId: '281322731389',
    projectId: 'pastelaria-do-lindo',
    databaseURL: 'https://pastelaria-do-lindo-default-rtdb.firebaseio.com',
    storageBucket: 'pastelaria-do-lindo.appspot.com',
    iosClientId:
        '281322731389-3aeaiue0820lt3gjso7kv4eqn0sgrj98.apps.googleusercontent.com',
    iosBundleId: 'com.example.pastelaria',
  );
}
