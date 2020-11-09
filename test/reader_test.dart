import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:bc108/reader_exceptions.dart';
import 'package:bc108/reader.dart';
import 'package:bc108/utils/utils.dart';

void main() {
  group('when bytes are well formatted message, should return string', () {
    final data = [
      ["OPN000", 0x77, 0x5e],
      ["AAAAAAAA", 0x9a, 0x63],
    ];
    data.forEach((d) {
      final text = d[0] as String;
      final crc1 = d[1] as int;
      final crc2 = d[2] as int;
      test(text, () {
        final streamController = StreamController<int>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte2(Byte.SYN)
            .addString(text)
            .addByte2(Byte.ETB)
            .addBytes([crc1, crc2]).build();

        for (var b in bytes) {
          streamController.sink.add(b);
        }
        expectLater(
            stream,
            emitsInOrder([
              predicate((x) => x.isDataEvent && x.data == text),
            ]));

        streamController.close();
      });
    });
  });

  group('when bytes are CAN+well formatted message, should return string', () {
    final data = [
      ["OPN000", 0x77, 0x5e],
      ["AAAAAAAA", 0x9a, 0x63],
    ];
    data.forEach((d) {
      final text = d[0] as String;
      final crc1 = d[1] as int;
      final crc2 = d[2] as int;
      test(text, () {
        final streamController = StreamController<int>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte2(Byte.CAN)
            .addByte2(Byte.SYN)
            .addString(text)
            .addByte2(Byte.ETB)
            .addBytes([crc1, crc2]).build();

        for (var b in bytes) {
          streamController.sink.add(b);
        }
        expectLater(
            stream,
            emitsInOrder([
              predicate((x) => x.isDataEvent && x.data == text),
            ]));

        streamController.close();
      });
    });
  });

  test('when there is no bytes, should receive no string', () {
    final streamController = StreamController<int>();
    final stream = streamController.stream.transform(ReaderTransformer());
    stream.listen(expectAsync1((x) {}, count: 0));
    streamController.close();
  });

  test('when CRC is wrong, should raise error', () {
    final streamController = StreamController<int>();
    final stream = streamController.stream.transform(ReaderTransformer());

    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addString("ABCDEFG")
        .addByte2(Byte.ETB)
        .addBytes([0x11, 0x22]).build();

    for (var b in bytes) {
      streamController.sink.add(b);
    }
    expectLater(stream, emitsError(TypeMatcher<ChecksumException>()));

    streamController.close();
  });

  group('when byte in payload section is out of range, should raise error', () {
    final data = [
      0x00,
      0x11,
      0x19,
      0x90,
      0xa0,
      0xf0,
    ];

    data.forEach((b) {
      test('0x${b.toRadixString(16)}', () {
        final streamController = StreamController<int>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte2(Byte.SYN)
            .addString("ABCD")
            .addByte(b)
            .addString("EFGH")
            .addByte2(Byte.ETB)
            .addBytes([0x11, 0x22]).build();

        for (var b in bytes) {
          streamController.sink.add(b);
        }
        expectLater(stream, emitsError(TypeMatcher<ByteOutOfRangeException>()));

        streamController.close();
      });
    });
  });

  test('when payload length is 0, should raise error', () {
    final streamController = StreamController<int>();
    final stream = streamController.stream.transform(ReaderTransformer());

    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addByte2(Byte.ETB)
        .addBytes([0x11, 0x22]).build();

    for (var b in bytes) {
      streamController.sink.add(b);
    }
    expectLater(stream, emitsError(TypeMatcher<PayloadTooShortException>()));

    streamController.close();
  });

  test('when payload length > 1024, should raise error', () {
    final streamController = StreamController<int>();
    final stream = streamController.stream.transform(ReaderTransformer());

    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addString('A' * 1025)
        .addByte2(Byte.ETB)
        .addBytes([0x11, 0x22]).build();

    for (var b in bytes) {
      streamController.sink.add(b);
    }
    expectLater(stream, emitsError(TypeMatcher<PayloadTooLongException>()));

    streamController.close();
  });

  group('when ACK/NAK are received, should raise event ACK/NAK', () {
    final data = [
      [Byte.ACK.toInt(), predicate((x) => !x.isDataEvent && x.ack)],
      [Byte.NAK.toInt(), predicate((x) => !x.isDataEvent && x.nak)],
    ];
    data.forEach((d) {
      final byte = d[0] as int;
      final matcher = d[1] as Matcher;
      test('0x${byte.toRadixString(16)}', () {
        final streamController = StreamController<int>();
        final stream = streamController.stream.transform(ReaderTransformer());

        streamController.sink.add(byte);

        expectLater(stream, emitsInOrder([matcher]));

        streamController.close();
      });
    });
  });

  group('when ETB/X/8 are received, should raise error', () {
    final data = [
      Byte.ETB.toInt(),
      'X'.codeUnitAt(0),
      8,
    ];
    data.forEach((byte) {
      test('0x${byte.toRadixString(16)}', () {
        final streamController = StreamController<int>();
        final stream = streamController.stream.transform(ReaderTransformer());

        streamController.sink.add(byte);

        expectLater(stream, emitsError(TypeMatcher<ExpectedSynException>()));

        streamController.close();
      });
    });
  });
}
