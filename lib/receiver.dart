library pinpad;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:pinpad/exceptions.dart';
import 'package:pinpad/utils/utils.dart';
import 'package:tuple/tuple.dart';

enum Stage {
  Initial,
  Payload,
  CRC1,
  CRC2,
}

class State {
  final payload = List<int>();
  Stage stage;
  int crc1;

  State() {
    this.reset();
  }

  void reset() {
    this.payload.clear();
    this.stage = Stage.Initial;
  }
}

class ReaderTransformer implements StreamTransformer<int, String> {
  final _controller = StreamController<String>();
  final _state = State();
  @override
  Stream<String> bind(Stream<int> stream) {
    stream.listen((b) => _processBytes(b));
    return _controller.stream;
  }

  void _processBytes(int b) {
    switch (this._state.stage) {
      case Stage.Initial:
        if (b == Byte.CAN.toInt()) {
          break;
        }
        if (b != Byte.SYN.toInt()) {
          _fail(ExpectedSynException(b));
          break;
        }

        this._state.stage = Stage.Payload;
        break;

      case Stage.Payload:
        if (b == Byte.ETB.toInt()) {
          if (this._state.payload.length == 0)
            _fail(InvalidPayloadLengthException(0));

          this._state.payload.forEach((b) {
            if (b < 0x20 || b > 0x7f) {
              _fail(ByteOutOfRangeException(b));
            }
          });

          this._state.stage = Stage.CRC1;
          break;
        }

        this._state.payload.add(b);
        if (this._state.payload.length > 1024)
          _fail(InvalidPayloadLengthException(this._state.payload.length));

        break;
      case Stage.CRC1:
        this._state.crc1 = b;
        this._state.stage = Stage.CRC2;
        break;
      case Stage.CRC2:
        final crc =
            crc16(Uint8List.fromList(this._state.payload + [Byte.ETB.toInt()]));
        if (crc[0] != this._state.crc1 || crc[1] != b) {
          _fail(ChecksumException(
              this._state.crc1 * 256 + b, crc[0] * 256 + crc[1]));
        } else {
          final text = ascii.decode(this._state.payload);
          _controller.sink.add(text);
        }
        this._state.reset();
        break;
    }
  }

  void _fail(Exception ex) {
    _controller.sink.addError(ex);
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
