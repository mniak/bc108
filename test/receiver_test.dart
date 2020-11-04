import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinpad/receiver.dart';
import 'package:pinpad/utils/utils.dart';

class TextCRC {
  TextCRC(this.text, this.crc1, this.crc2);
  String text;
  int crc1;
  int crc2;
}

void main() {
  group('when bytes are wellformatted message, should return string', () {
    final data = [
      TextCRC("OPN000", 0x77, 0x5e),
      TextCRC("AAAAAAAA", 0x9a, 0x63)
    ];
    data.forEach((d) {
      test(d.text, () {
        final streamController = StreamController<Uint8List>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte(Byte.SYN.toInt())
            .addString(d.text)
            .addByte(Byte.ETB.toInt())
            .addBytes([d.crc1, d.crc2]).build();

        streamController.sink.add(bytes);
        expectLater(stream, emitsInOrder([d.text]));

        streamController.close();
      });
    });
  });
  group('when bytes are CAN+wellformatted message, should return string', () {
    final data = [
      TextCRC("OPN000", 0x77, 0x5e),
      TextCRC("AAAAAAAA", 0x9a, 0x63)
    ];
    data.forEach((d) {
      test(d.text, () {
        final streamController = StreamController<Uint8List>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte(Byte.CAN.toInt())
            .addByte(Byte.SYN.toInt())
            .addString(d.text)
            .addByte(Byte.ETB.toInt())
            .addBytes([d.crc1, d.crc2]).build();

        streamController.sink.add(bytes);
        expectLater(stream, emitsInOrder([d.text]));

        streamController.close();
      });
    });
  });

  test('when there is no bytes, should receive no string', () {
    final streamController = StreamController<Uint8List>();
    final stream = streamController.stream.transform(ReaderTransformer());
    stream.listen(expectAsync1((x) {}, count: 0));
    streamController.close();
  });

  test('when CRC is wrong, should raise error', () {
    final streamController = StreamController<Uint8List>();
    final stream = streamController.stream.transform(ReaderTransformer());

    final bytes = BytesBuilder()
        .addByte(Byte.SYN.toInt())
        .addString("ABCDEFG")
        .addByte(Byte.ETB.toInt())
        .addBytes([0x11, 0x22]).build();

    streamController.sink.add(bytes);
    expectLater(stream, emitsError());

    streamController.close();
  });
}
