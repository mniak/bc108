library pinpad;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bc108/reader_exceptions.dart';
import 'package:bc108/utils/utils.dart';

enum _ReaderStage {
  Initial,
  Payload,
  CRC1,
  CRC2,
}

class ReaderState {
  final payload = List<int>();
  _ReaderStage stage;
  int crc1;

  ReaderState() {
    this.reset();
  }

  void reset() {
    this.payload.clear();
    this.stage = _ReaderStage.Initial;
  }
}

class ReaderEvent {
  String _data;
  ReaderEvent.data(String data) {
    if (data == null) throw ArgumentError.notNull('data');
    this._data = data;
  }
  bool get isDataEvent => this._data != null;
  String get data => this._data;

  int _interrupt;
  ReaderEvent.ack() {
    this._interrupt = 1;
  }
  bool get ack => this._interrupt == 1;
  ReaderEvent.nak() {
    this._interrupt = 2;
  }
  bool get nak => this._interrupt == 2;
}

class ReaderTransformer implements StreamTransformer<int, ReaderEvent> {
  @override
  Stream<ReaderEvent> bind(Stream<int> stream) {
    final state = ReaderState();
    final controller = StreamController<ReaderEvent>();
    stream.listen(
      (data) => _processBytes(data, controller.sink, state),
      onError: (error) {
        controller.sink.addError(error);
      },
      onDone: () {
        controller.sink.close();
      },
    );
    return controller.stream;
  }

  static void _processBytes(
      int b, StreamSink<ReaderEvent> sink, ReaderState state) {
    switch (state.stage) {
      case _ReaderStage.Initial:
        switch (b.toByte()) {
          case Byte.CAN:
            break;
          case Byte.ACK:
            sink.add(ReaderEvent.ack());
            break;
          case Byte.NAK:
            sink.add(ReaderEvent.nak());
            break;
          case Byte.SYN:
            state.stage = _ReaderStage.Payload;
            break;
          default:
            sink.addError(ExpectedSynException(b));
            break;
        }
        break;

      case _ReaderStage.Payload:
        if (b == Byte.ETB.toInt()) {
          if (state.payload.length == 0)
            sink.addError(PayloadTooShortException());

          state.payload.forEach((b) {
            if (b < 0x20 || b > 0x7f) {
              sink.addError(ByteOutOfRangeException(b));
            }
          });

          state.stage = _ReaderStage.CRC1;
          break;
        }

        state.payload.add(b);
        if (state.payload.length > 1024)
          sink.addError(PayloadTooLongException(state.payload.length));

        break;
      case _ReaderStage.CRC1:
        state.crc1 = b;
        state.stage = _ReaderStage.CRC2;
        break;
      case _ReaderStage.CRC2:
        final crc =
            crc16(Uint8List.fromList(state.payload + [Byte.ETB.toInt()]));
        if (crc[0] != state.crc1 || crc[1] != b) {
          sink.addError(
              ChecksumException(state.crc1 * 256 + b, crc[0] * 256 + crc[1]));
        } else {
          final text = ascii.decode(state.payload);
          sink.add(ReaderEvent.data(text));
        }
        state.reset();
        break;
    }
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}
