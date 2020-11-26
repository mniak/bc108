import 'dart:async';
import 'dart:developer' as developer;

void log(
  String message, {
  DateTime time,
  int sequenceNumber,
  int level = 0,
  Zone zone,
  Object error,
  StackTrace stackTrace,
}) {
  developer.log(
    message,
    time: time,
    sequenceNumber: sequenceNumber,
    level: level,
    zone: zone,
    error: error,
    stackTrace: stackTrace,
    name: 'net.mniak.bc108.layer2',
  );
}
