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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPPshYWrW0RdEoRQT0JweNZtiTHJJotNs',
    appId: '1:540331566050:android:60bb119d2b30f7af554fbb',
    messagingSenderId: '540331566050',
    projectId: 'yiwumart-53257',
    databaseURL: 'https://yiwumart-53257-default-rtdb.firebaseio.com',
    storageBucket: 'yiwumart-53257.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrC5JY8s6BmvwFbO-lflMyWCYEOEDcKHI',
    appId: '1:540331566050:ios:d81f5dd342cb923e554fbb',
    messagingSenderId: '540331566050',
    projectId: 'yiwumart-53257',
    databaseURL: 'https://yiwumart-53257-default-rtdb.firebaseio.com',
    storageBucket: 'yiwumart-53257.appspot.com',
    iosClientId: '540331566050-pu48t1pljh2kni3l5307hbd5kl0lanb7.apps.googleusercontent.com',
    iosBundleId: 'yiwu.yiwumart',
  );
}
