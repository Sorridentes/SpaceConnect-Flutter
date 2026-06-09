import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions nao foi configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBH9XL7d8wWyWyOj5qbPTPj2taz3PoLbKk',
    authDomain: 'gs02-72759.firebaseapp.com',
    projectId: 'gs02-72759',
    storageBucket: 'gs02-72759.firebasestorage.app',
    messagingSenderId: '808451836180',
    appId: '1:808451836180:web:a58e5c304c6bd7b9d45a01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'ANDROID_API_KEY',
    appId: 'ANDROID_APP_ID',
    messagingSenderId: 'MESSAGING_SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: '',
    authDomain: '',
    projectId: '',
    storageBucket: '',
    messagingSenderId: '',
    appId: '',
    measurementId: '',
  );
}
