import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  static FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  static Future<void> simulateCrash() async {
    await recordError(
      Exception('Simulated crash report triggered manually'),
      StackTrace.current,
      reason: 'User pressed "Simulate Crash" button',
    );
  }
}
