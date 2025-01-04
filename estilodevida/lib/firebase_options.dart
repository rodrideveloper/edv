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
    apiKey: 'AIzaSyBRSu4vE6wspFC64fhfP6Ti8WnXcFIyZBs',
    appId: '1:496833297972:android:14eb3ba61b5ad5329a9461',
    messagingSenderId: '496833297972',
    projectId: 'estilodevida-8e453',
    storageBucket: 'estilodevida-8e453.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-gz2RoziRYKf20L4hL6idnJh7wry3wBs',
    appId: '1:496833297972:ios:7b21cf1d2fdeb3849a9461',
    messagingSenderId: '496833297972',
    projectId: 'estilodevida-8e453',
    storageBucket: 'estilodevida-8e453.appspot.com',
    androidClientId: '496833297972-ek2jlour4ao9rfkgggvupd2opskun8fg.apps.googleusercontent.com',
    iosClientId: '496833297972-p1vd6593oeqi4s7an2a7v0dr10b1ut3k.apps.googleusercontent.com',
    iosBundleId: 'com.academia.estilodevida.estilodevida',
  );

}