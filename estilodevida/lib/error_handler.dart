import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> errorHandler({
  required dynamic err,
  required StackTrace stack,
  required String reason,
  required Iterable<Object> information,
}) async =>
    await FirebaseCrashlytics.instance.recordError(
      err,
      stack,
      fatal: true,
      reason: reason,
      information: information,
    );
