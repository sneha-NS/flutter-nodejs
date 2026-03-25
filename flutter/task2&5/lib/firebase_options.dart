import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoDpcHfoWK0KY_Gv4t0FdwrZwsj8S1Av0',
    appId: '1:199969970820:android:ec36d1714259022ca0c0d1',
    messagingSenderId: '199969970820',
    projectId: 'todo-app-3d302',
    storageBucket: 'todo-app-3d302.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6WFi7mBRabx9iIU6zBDq6EzcK_4i9Izw',
    appId: '1:199969970820:ios:cb42d17c2a908279a0c0d1',
    messagingSenderId: '199969970820',
    projectId: 'todo-app-3d302',
    storageBucket: 'todo-app-3d302.firebasestorage.app',
    iosClientId: null,
    iosBundleId: 'com.example.task2',
  );
}
