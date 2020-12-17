import 'dart:async';
import 'package:async/async.dart';

import '../log.dart';
import 'exceptions.dart';
import 'result_frame.dart';
import 'reader.dart';
import 'ack_frame.dart';

class FrameReceiver {
  Stream<ReaderEvent> _stream;
  StreamQueue<ReaderEvent> _queue;

  FrameReceiver(this._stream) {
    if (!_stream.isBroadcast) _stream = _stream.asBroadcastStream();
  }

  Future<AckFrame> receiveAck(Duration timeout) async {
    final queue = StreamQueue<ReaderEvent>(_stream);
    try {
      final event = await queue.next.timeout(timeout);
      if (!event.ack && !event.nak) {
        throw ExpectingAckOrNakException(event);
      }
      if (event.nak) {
        return AckFrame.tryAgain();
      }
      return AckFrame.ok();
    } on TimeoutException {
      log('Expecting ack/nak, received timout. Resetting buffer.');
      return AckFrame.timeout();
    } finally {
      await queue.cancel(immediate: true);
    }
  }

  Future<DataFrame> receiveData(Duration timeout) async {
    final queue = StreamQueue<ReaderEvent>(_stream);
    try {
      final event = await queue.next.timeout(timeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return DataFrame.data(event.data);
    } on TimeoutException {
      log('Expecting data, received timout. Resetting buffer.');
      return DataFrame.timeout();
    } finally {
      await queue.cancel(immediate: true);
    }
  }
}
