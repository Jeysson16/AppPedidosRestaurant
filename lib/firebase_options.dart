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
    apiKey: 'AIzaSyD8Ej-ctkHvPKydWMtfq0tHZEBRLLI279Q',
    appId: '1:899048899898:web:9a5ad57cdef386b4a13c03',
    messagingSenderId: '899048899898',
    projectId: 'restaurant-app-7c537',
    authDomain: 'restaurant-app-7c537.firebaseapp.com',
    storageBucket: 'restaurant-app-7c537.appspot.com',
    measurementId: 'G-LSHDTD9JCH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBM0zaKcQBNzGYLE7n4nQfTgg_HWNrB_Rg',
    appId: '1:899048899898:android:e2cb385ae84d8137a13c03',
    messagingSenderId: '899048899898',
    projectId: 'restaurant-app-7c537',
    storageBucket: 'restaurant-app-7c537.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAI-AEybfmlbNHHUf7EzyE2nRk-zZ7u5_o',
    appId: '1:899048899898:ios:d8838b5e786d9c2da13c03',
    messagingSenderId: '899048899898',
    projectId: 'restaurant-app-7c537',
    storageBucket: 'restaurant-app-7c537.appspot.com',
    iosBundleId: 'com.example.restaurantApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAI-AEybfmlbNHHUf7EzyE2nRk-zZ7u5_o',
    appId: '1:899048899898:ios:d8838b5e786d9c2da13c03',
    messagingSenderId: '899048899898',
    projectId: 'restaurant-app-7c537',
    storageBucket: 'restaurant-app-7c537.appspot.com',
    iosBundleId: 'com.example.restaurantApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD8Ej-ctkHvPKydWMtfq0tHZEBRLLI279Q',
    appId: '1:899048899898:web:98468cc8a89cbc9ba13c03',
    messagingSenderId: '899048899898',
    projectId: 'restaurant-app-7c537',
    authDomain: 'restaurant-app-7c537.firebaseapp.com',
    storageBucket: 'restaurant-app-7c537.appspot.com',
    measurementId: 'G-2NWP9XNVB8',
  );

}