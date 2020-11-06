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

class ReaderTransformer implements StreamTransformer<Uint8List, String> {
  final _controller = StreamController<String>();
  final _payload = List<int>();
  var _state = ReaderState.Initial;
  int _crc1;

  @override
  Stream<String> bind(Stream<Uint8List> stream) {
    // stream.listen((bytes) => _processBytes(bytes));
    return _controller.stream;
  }

  void _processBytes(Uint8List bytes) {
    while (bytes.isNotEmpty) {
      var b = bytes[0];
      switch (this._state) {
        case ReaderState.Initial:
          if (b == Byte.CAN.toInt()) {
            // Do nothing. Just skip the byte.
          } else if (b != Byte.SYN.toInt()) {
            _fail(Exception(
                "Protocol violation. Expecting byte SYN (0x16), ACK (0x06) or NAK (0x15"));
          } else {
            this._state = ReaderState.Payload;
          }
          bytes = bytes.sublist(1);
          break;
        case ReaderState.Payload:
          var index = bytes.indexOf(Byte.ETB.toInt());
          if (index >= 0) {
            _payload.addAll(bytes.sublist(0, index));
            bytes = bytes.sublist(index + 1);
            _state = ReaderState.CRC1;
          } else {
            _payload.addAll(bytes);
            bytes = bytes.sublist(bytes.length);
          }
          break;
        case ReaderState.CRC1:
          _crc1 = b;
          // bytes.forEach((b) {
          //   if (b < 0x20 || b > 0x7f) {
          //     _fail(ByteOutOfRangeException(b));
          //   }
          // });

          bytes = bytes.sublist(1);
          _state = ReaderState.CRC2;
          break;
        case ReaderState.CRC2:
          bytes = bytes.sublist(1);

          final crc = crc16(Uint8List.fromList(_payload + [Byte.ETB.toInt()]));
          if (crc[0] != _crc1 || crc[1] != b) {
            _fail(ChecksumException(crc[0], crc[1]));
          } else {
            final text = ascii.decode(_payload);
            _controller.sink.add(text);
          }
          _reset();
          break;
      }
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

Stream<String> readMessage(Stream<Uint8List> stream) {
  // final sc = StreamController<String>();
  // stream.listen((event) {
  //   sc.sink.add("event");
  // });
  // return sc.stream;

  // StreamTransformer<Uint8List, String>()
  return null;
}

class Result {
  bool _success;
  Iterable<int> _data;
  Exception _exception;

  Result.success(Iterable<int> data) {
    this._success = true;
    this._data = data;
  }

  Result.failure(Exception ex) {
    this._success = false;
    this._exception = ex;
  }

  bool success() => this._success;
  Iterable<int> data() => this._data;
  Exception exception() => this._exception;
}

abstract class Handler {
  Result handle(Reader reader) {
    return null;
  }
}

class NoopHandler implements Handler {
  @override
  Result handle(Reader reader) {
    return Result.success([]);
  }
}

typedef Handler CompositeHandlerStep(Handler next);

class CompositeHandler implements Handler {
  Handler _handler;
  CompositeHandler(Iterable<CompositeHandlerStep> steps) {
    this._handler = _buildHandler(steps);
  }

  Handler _buildHandler(Iterable<CompositeHandlerStep> builders) {
    var iterator = List<CompositeHandlerStep>.from(builders).reversed;
    Handler success;
    final builder =
        iterator.reduce((inner, outer) => (handler) => outer(inner(handler)));

    final handler = builder(success);
    return handler;
  }

  @override
  Result handle(Reader reader) => this._handler.handle(reader);
}

class LookForSyn implements Handler {
  Handler _next;
  LookForSyn(this._next);
  @override
  Result handle(Reader reader) {
    final b = reader.readByte();
    if (b == Byte.CAN.toInt()) return this.handle(reader);
    if (b != Byte.SYN.toInt()) return Result.failure(ExpectedSynException(b));
    return this._next.handle(reader);
  }
}

class ReadPayload implements Handler {
  Handler _next;
  ReadPayload(this._next);
  @override
  Result handle(Reader reader) {
    // final b = reader.readByte();
    // if (b == Byte.CAN.toInt()) return this.handle(reader);
    // if (b != Byte.SYN.toInt()) return Result.failure(ExpectedSynException(b));
    // return _next.handle(reader);

    final i = reader.findByte(Byte.ETB.toInt(), 1024);
    if (i < 1 || i > 1024)
      return Result.failure(InvalidPayloadLengthException(i));

    final data = reader.getBytes(i + 1);
    // if (index >= 0) {
    //   _payload.addAll(bytes.sublist(0, index));
    //   bytes = bytes.sublist(index + 1);
    //   _state = ReaderState.CRC1;
    // } else {
    //   _payload.addAll(bytes);
    //   bytes = bytes.sublist(bytes.length);
    // }

    return null;
  }
}

class PinpadParser extends CompositeHandler {
  PinpadParser()
      : super([
          (h) => LookForSyn(h),
          (h) => ReadPayload(h),
        ]);
}

class Reader {
  int readByte() {
    return 0;
  }

  int findByte(int expectedByte, int maximumLength) {
    return 0;
  }

  Iterable<int> getBytes(int count) {
    return [0, 0, 0, 0];
  }
}
