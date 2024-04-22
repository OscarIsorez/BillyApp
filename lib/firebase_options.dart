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
    apiKey: 'AIzaSyCsqvTHieDW0h8fbIG8whrR4RF2A6GlI44',
    appId: '1:817631551955:web:26d055d3f4849e09034f26',
    messagingSenderId: '817631551955',
    projectId: 'billy-374710',
    authDomain: 'billy-374710.firebaseapp.com',
    storageBucket: 'billy-374710.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6W2FFqS3Rfclc87hiYIhup05gohXvU5I',
    appId: '1:817631551955:android:770aa3069c849bf7034f26',
    messagingSenderId: '817631551955',
    projectId: 'billy-374710',
    storageBucket: 'billy-374710.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9yy30OGwBoFaILI0g4Uh-J79qL3A3-m4',
    appId: '1:817631551955:ios:36f14f7b560f8ce3034f26',
    messagingSenderId: '817631551955',
    projectId: 'billy-374710',
    storageBucket: 'billy-374710.appspot.com',
    iosClientId: '817631551955-h20l4u2h9tatldg6nfuai5d6h691bh9m.apps.googleusercontent.com',
    iosBundleId: 'com.example.billy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9yy30OGwBoFaILI0g4Uh-J79qL3A3-m4',
    appId: '1:817631551955:ios:36f14f7b560f8ce3034f26',
    messagingSenderId: '817631551955',
    projectId: 'billy-374710',
    storageBucket: 'billy-374710.appspot.com',
    iosClientId: '817631551955-h20l4u2h9tatldg6nfuai5d6h691bh9m.apps.googleusercontent.com',
    iosBundleId: 'com.example.billy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCsqvTHieDW0h8fbIG8whrR4RF2A6GlI44',
    appId: '1:817631551955:web:c8e927a852b6ab12034f26',
    messagingSenderId: '817631551955',
    projectId: 'billy-374710',
    authDomain: 'billy-374710.firebaseapp.com',
    storageBucket: 'billy-374710.appspot.com',
  );

}