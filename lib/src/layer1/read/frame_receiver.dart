import 'dart:async';
import 'package:async/async.dart';

import 'exceptions.dart';
import 'frame_result.dart';
import 'reader.dart';
import 'frame_acknowledgement.dart';

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

  Future<FrameAcknowledgement> receiveAcknowledgement() async {
    try {
      final event = await _nextEvent(_ackTimeout);
      if (!event.ack && !event.nak) {
        throw ExpectingAckOrNakException(event);
      }
      if (event.nak) {
        return FrameAcknowledgement.tryAgain();
      }
      return FrameAcknowledgement.ok();
    } on TimeoutException {
      return FrameAcknowledgement.timeout();
    }
  }

  Future<FrameResult> receiveData() async {
    try {
      final event = await _nextEvent(_responseTimeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return FrameResult.data(event.data);
    } on TimeoutException {
      return FrameResult.timeout();
    }
  }

  Future<FrameResult> receiveNonBlocking() async {
    final ack = await receiveAcknowledgement();
    if (ack.timeout) return FrameResult.timeout();
    if (ack.tryAgain) return FrameResult.tryAgain();

    try {
      final event = await _nextEvent(_responseTimeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }
      return FrameResult.data(event.data);
    } on TimeoutException {
      return FrameResult.timeout();
    }
  }

  Stream<FrameResult> receiveBlocking() async* {
    // final controller = StreamController<FrameResult>();
    // // controller.sink.
    // Future.doWhile(() async {
    //    Stream.fromFuture(future)
    try {
      final event = await _nextEvent(_responseTimeout);
      if (!event.isDataEvent) {
        throw ExpectingDataEventException(event);
      }

      yield FrameResult.data(event.data);
    } on TimeoutException {
      yield FrameResult.timeout();
    }
    // return false;
    // });
    // return controller.stream;
  }
}
