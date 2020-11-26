import 'dart:async';
import 'package:async/async.dart';

import 'exceptions.dart';
import 'result_frame.dart';
import 'reader.dart';
import 'ack_frame.dart';

class FrameReceiver {
  StreamQueue<ReaderEvent> _queue;
  Duration _ackTimeout;

  FrameReceiver(Stream<ReaderEvent> stream) {
    this._queue = StreamQueue<ReaderEvent>(stream);
  }

  Future<ReaderEvent> _nextEvent(Duration timeout) =>
      _queue.next.timeout(timeout);

  Future<AckFrame> receiveAck(Duration timeout) async {
    try {
      final event = await _nextEvent(timeout);
      if (!event.ack && !event.nak) {
        throw ExpectingAckOrNakException(event);
      }
      if (event.nak) {
        return AckFrame.tryAgain();
      }
      return AckFrame.ok();
    } on TimeoutException {
      return AckFrame.timeout();
    }
  }

  Future<DataFrame> receiveData(Duration timeout) async {
    try {
      final event = await _nextEvent(timeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return DataFrame.data(event.data);
    } on TimeoutException {
      return DataFrame.timeout();
    }
  }
}
