import 'dart:async';
import 'package:async/async.dart';

import 'exceptions.dart';
import 'result_frame.dart';
import 'reader.dart';
import 'ack_frame.dart';

class FrameReceiver {
  StreamQueue<ReaderEvent> _queue;
  Duration _ackTimeout;
  Duration _responseTimeout;

  FrameReceiver(Stream<ReaderEvent> stream,
      {Duration ackTimeout, Duration responseTimeout}) {
    this._queue = StreamQueue<ReaderEvent>(stream);
    this._ackTimeout = ackTimeout ?? Duration(seconds: 2);
    this._responseTimeout = responseTimeout ?? Duration(seconds: 10);
  }

  Future<ReaderEvent> _nextEvent(Duration timeout) =>
      _queue.next.timeout(timeout);

  Future<AckFrame> receiveAck() async {
    try {
      final event = await _nextEvent(_ackTimeout);
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

  Future<ResultFrame> receive() async {
    try {
      final event = await _nextEvent(_responseTimeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return ResultFrame.data(event.data);
    } on TimeoutException {
      return ResultFrame.timeout();
    }
  }
}
