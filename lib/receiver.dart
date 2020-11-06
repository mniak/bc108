library pinpad;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pinpad/exceptions.dart';
import 'package:pinpad/utils/utils.dart';
import 'package:tuple/tuple.dart';

enum ReaderState {
  Initial,
  Payload,
  CRC1,
  CRC2,
}

class ReaderTransformer implements StreamTransformer<int, String> {
  final _controller = StreamController<String>();
  final _payload = List<int>();
  var _state = ReaderState.Initial;
  int _crc1;

  @override
  Stream<String> bind(Stream<int> stream) {
    stream.listen((b) => _processBytes(b));
    return _controller.stream;
  }

  void _processBytes(int b) {
    switch (this._state) {
      case ReaderState.Initial:
        if (b == Byte.CAN.toInt()) {
          break;
        }
        if (b != Byte.SYN.toInt()) {
          _fail(Exception(
              "Protocol violation. Expecting byte SYN (0x16), ACK (0x06) or NAK (0x15"));
          break;
        }

        this._state = ReaderState.Payload;
        break;

      case ReaderState.Payload:
        if (b == Byte.ETB.toInt()) {
          if (_payload.length == 0) _fail(InvalidPayloadLengthException(0));

          _payload.forEach((b) {
            if (b < 0x20 || b > 0x7f) {
              _fail(ByteOutOfRangeException(b));
            }
          });

          _state = ReaderState.CRC1;
          break;
        }

        _payload.add(b);
        if (_payload.length > 1024)
          _fail(InvalidPayloadLengthException(_payload.length));

        break;
      case ReaderState.CRC1:
        _crc1 = b;
        _state = ReaderState.CRC2;
        break;
      case ReaderState.CRC2:
        final crc = crc16(Uint8List.fromList(_payload + [Byte.ETB.toInt()]));
        if (crc[0] != _crc1 || crc[1] != b) {
          _fail(ChecksumException(_crc1 * 256 + b, crc[0] * 256 + crc[1]));
        } else {
          final text = ascii.decode(_payload);
          _controller.sink.add(text);
        }
        _reset();
        break;
    }
  }

  void _fail(Exception ex) {
    _controller.sink.addError(ex);
  }

  void _reset() {
    _payload.clear();
    _state = ReaderState.Initial;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

Stream<String> readMessage(Stream<int> stream) {
  // final sc = StreamController<String>();
  // stream.listen((event) {
  //   sc.sink.add("event");
  // });
  // return sc.stream;

  // StreamTransformer<Uint8List, String>()
  return null;
}
