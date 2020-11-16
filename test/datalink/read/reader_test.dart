import 'dart:async';
import 'dart:typed_data';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import 'package:bc108/datalink/read/reader.dart';
import 'package:bc108/datalink/read/reader_exceptions.dart';
import 'package:bc108/datalink/utils/bytes.dart';
import 'package:bc108/datalink/utils/bytes_builder.dart';
import 'package:bc108/datalink/utils/crc.dart';

class ChecksumMock extends Mock implements Checksum {}

class SUT {
  StreamController<int> controller;
  Stream<ReaderEvent> eventStream;
  Checksum checksumAlgorightm;

  SUT() {
    this.controller = StreamController<int>();
    this.checksumAlgorightm = ChecksumMock();
    this.eventStream =
        controller.stream.asEventReader(checksumAlgorithm: checksumAlgorightm);
  }
  void close() => controller.close();
}

void main() {
  group('when bytes are well formatted message, should return string', () {
    final data = [
      "OPN000",
      "AAAAAAAA",
    ];
    data.forEach((text) {
      test(text, () {
        final sut = SUT();
        when(sut.checksumAlgorightm.validate(any, any)).thenAnswer((_) => true);
        final bytes = BytesBuilder()
            .addByte2(Byte.SYN)
            .addString(text)
            .addByte2(Byte.ETB)
            .addBytes([0x00, 0x00]).build();

        for (var b in bytes) {
          sut.controller.sink.add(b);
        }
        expectLater(
            sut.eventStream,
            emitsInOrder([
              predicate((x) => x.isDataEvent && x.data == text),
            ]));

        sut.close();
      });
    });
  });

  group('when bytes are CAN+well formatted message, should return string', () {
    final data = [
      "OPN000",
      "AAAAAAAA",
    ];
    data.forEach((text) {
      test(text, () {
        final sut = SUT();
        when(sut.checksumAlgorightm.validate(any, any)).thenAnswer((_) => true);

        final bytes = BytesBuilder()
            .addByte2(Byte.CAN)
            .addByte2(Byte.SYN)
            .addString(text)
            .addByte2(Byte.ETB)
            .addBytes([0x00, 0x00]).build();

        for (var b in bytes) {
          sut.controller.sink.add(b);
        }
        expectLater(
            sut.eventStream,
            emitsInOrder([
              predicate((x) => x.isDataEvent && x.data == text),
            ]));

        sut.close();
      });
    });
  });

  test('when there is no bytes, should receive no string', () {
    final sut = SUT();
    sut.eventStream.listen(expectAsync1((x) {}, count: 0));
    sut.close();
  });

  test('when CRC is wrong, should raise error', () {
    final sut = SUT();
    when(sut.checksumAlgorightm.validate(any, any)).thenAnswer((_) => false);
    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addString("ABCDEFG")
        .addByte2(Byte.ETB)
        .addBytes([0x00, 0x00]).build();

    for (var b in bytes) {
      sut.controller.sink.add(b);
    }
    expectLater(sut.eventStream, emitsError(TypeMatcher<ChecksumException>()));

    sut.close();
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
        final sut = SUT();
        when(sut.checksumAlgorightm.validate(any, any)).thenAnswer((_) => true);

        final bytes = BytesBuilder()
            .addByte2(Byte.SYN)
            .addString("ABCD")
            .addByte(b)
            .addString("EFGH")
            .addByte2(Byte.ETB)
            .addBytes([0x00, 0x00]).build();

        for (var b in bytes) {
          sut.controller.sink.add(b);
        }
        expectLater(sut.eventStream,
            emitsError(TypeMatcher<ByteOutOfRangeException>()));

        // sut.close();
      });
    });
  });

  test('when payload length is 0, should raise error', () {
    final sut = SUT();
    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addByte2(Byte.ETB)
        .addBytes([0x00, 0x00]).build();

    for (var b in bytes) {
      sut.controller.sink.add(b);
    }
    expectLater(
        sut.eventStream, emitsError(TypeMatcher<PayloadTooShortException>()));

    sut.close();
  });

  test('when payload length > 1024, should raise error', () {
    final sut = SUT();
    final bytes = BytesBuilder()
        .addByte2(Byte.SYN)
        .addString('A' * 1025)
        .addByte2(Byte.ETB)
        .addBytes([0x00, 0x00]).build();

    for (var b in bytes) {
      sut.controller.sink.add(b);
    }
    expectLater(
        sut.eventStream, emitsError(TypeMatcher<PayloadTooLongException>()));

    sut.close();
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
        final sut = SUT();

        sut.controller.sink.add(byte);

        expectLater(sut.eventStream, emitsInOrder([matcher]));

        sut.close();
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
        final sut = SUT();

        sut.controller.sink.add(byte);

        expectLater(
            sut.eventStream, emitsError(TypeMatcher<ExpectedSynException>()));

        sut.close();
      });
    });
  });

  test("Error events are bypassed", () {
    final sut = SUT();
    final error = faker.lorem.sentence();
    sut.controller.addError(error);

    expectLater(sut.eventStream, emitsError(equals(error)));
    sut.close();
  });

  test("Close event is bypassed", () {
    final sut = SUT();

    sut.close();
    expectLater(sut.eventStream, emitsDone);
  });
}
