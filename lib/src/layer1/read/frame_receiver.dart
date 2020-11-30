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
    _reset();
  }

  Future<ReaderEvent> _nextEvent(Duration timeout) =>
      _queue.next.timeout(timeout);

  void _reset() {
    if (_queue != null) _queue.cancel();
    _queue = StreamQueue<ReaderEvent>(_stream);
  }

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
      log('Expecting ack/nak, received timout. Resetting buffer.');
      _reset();
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
      log('Expecting data, received timout. Resetting buffer.');
      _reset();
      return DataFrame.timeout();
    }
  }
}
