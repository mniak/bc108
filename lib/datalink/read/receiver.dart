import 'dart:async';

import 'package:bc108/datalink/read/reader.dart';
import 'package:bc108/datalink/utils/crc.dart';

import 'receiver_exceptions.dart';

class ReceiverResult {
  bool _tryAgain = false;
  ReceiverResult.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  ReceiverResult.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  String _data;
  ReceiverResult.data(String data) {
    this._data = data;
  }
  bool get isDataResult => _data != null;
  String get data => _data;
}

class Receiver {
  Stream<ReaderEvent> _stream;
  Duration _ackTimeout;
  Duration _responseTimeout;

  Receiver(Stream<ReaderEvent> stream,
      {Duration ackTimeout, Duration responseTimeout}) {
    this._stream = stream.asBroadcastStream();
    this._ackTimeout = ackTimeout ?? Duration(seconds: 2);
    this._responseTimeout = responseTimeout ?? Duration(seconds: 10);
  }

  Future<ReaderEvent> _nextEvent(Duration timeout) =>
      _stream.first.timeout(timeout);

  Future<ReceiverResult> receive() async {
    try {
      final event1 = await _nextEvent(_ackTimeout);
      if (!event1.ack && !event1.nak) {
        throw ExpectingAckOrNakException(event1);
      }
      if (event1.nak) {
        return ReceiverResult.tryAgain();
      }

      final event2 = await _nextEvent(_responseTimeout);
      if (!event2.isDataEvent) {
        throw ExpectingDataEventException(event2);
      }

      return ReceiverResult.data(event2.data);
    } on TimeoutException {
      return ReceiverResult.timeout();
    }
  }
}
