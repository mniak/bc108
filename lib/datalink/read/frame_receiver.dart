import 'dart:async';

import 'package:async/async.dart';
import 'package:bc108/datalink/read/reader.dart';
import 'frame_receiver_exceptions.dart';

class FrameResult {
  bool _tryAgain = false;
  FrameResult.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  FrameResult.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  String _data;
  FrameResult.data(String data) {
    this._data = data;
  }
  bool get isDataResult => _data != null;
  String get data => _data;
}

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

  Future<FrameResult> receive() async {
    try {
      final event1 = await _nextEvent(_ackTimeout);
      if (!event1.ack && !event1.nak) {
        throw ExpectingAckOrNakException(event1);
      }
      if (event1.nak) {
        return FrameResult.tryAgain();
      }

      final event2 = await _nextEvent(_responseTimeout);
      if (!event2.isDataEvent) {
        throw ExpectingDataEventException(event2);
      }

      return FrameResult.data(event2.data);
    } on TimeoutException {
      return FrameResult.timeout();
    }
  }
}
