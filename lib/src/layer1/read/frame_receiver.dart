import 'dart:async';
import 'package:async/async.dart';

import '../log.dart';
import 'exceptions.dart';
import 'frames.dart';
import 'reader_event.dart';

class FrameReceiver {
  Stream<ReaderEvent> _stream;

  FrameReceiver(this._stream) {
    if (!_stream.isBroadcast) _stream = _stream.asBroadcastStream();
  }

  Future<UnitFrame> receiveAck(Duration timeout) async {
    final queue = StreamQueue<ReaderEvent>(_stream);
    try {
      final event = await queue.next.timeout(timeout);
      if (!event.ack && !event.nak) {
        throw ExpectingAckOrNakException(event);
      }
      if (event.nak) {
        return UnitFrame.tryAgain();
      }
      return UnitFrame.ok();
    } on TimeoutException {
      log('Expecting ack/nak, received timeout. Resetting buffer.');
      return UnitFrame.timeout();
    } finally {
      await queue.cancel(immediate: true);
    }
  }

  Future<UnitFrame> receiveEot(Duration timeout) async {
    final queue = StreamQueue<ReaderEvent>(_stream);
    try {
      final event = await queue.next.timeout(timeout);
      if (!event.ack && !event.nak) {
        throw ExpectingAckOrNakException(event);
      }
      if (event.nak) {
        return UnitFrame.tryAgain();
      }
      return UnitFrame.ok();
    } on TimeoutException {
      log('Expecting EOT, received timeout. Resetting buffer.');
      return UnitFrame.timeout();
    } finally {
      await queue.cancel(immediate: true);
    }
  }

  Future<StringFrame> receiveData(Duration timeout) async {
    final queue = StreamQueue<ReaderEvent>(_stream);
    try {
      final event = await queue.next.timeout(timeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return StringFrame.data(event.data);
    } on TimeoutException {
      log('Expecting data, received timeout. Resetting buffer.');
      return StringFrame.timeout();
    } finally {
      await queue.cancel(immediate: true);
    }
  }
}
