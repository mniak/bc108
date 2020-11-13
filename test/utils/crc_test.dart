import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bc108/datalink/utils/bytes.dart';
import 'package:bc108/datalink/utils/bytes_builder.dart';
import 'package:bc108/datalink/utils/crc.dart';

class ChecksumStub extends Checksum {
  Iterable<int> _checksum;
  ChecksumStub(this._checksum);

  @override
  Iterable<int> compute(Iterable<int> data) => _checksum;
}

void main() {
  group('checksum validate()', () {
    test('when checksum matches, should return true', () {
      final checksum = faker.randomGenerator.numbers(255, 2);
      final sut = ChecksumStub(checksum);
      final bytes = faker.randomGenerator.numbers(255, 80);

      final result = sut.validate(bytes, checksum);
      expect(result, isTrue);
    });

    test('when checksum does not match, should return false', () {
      final checksum = faker.randomGenerator.numbers(255, 2);
      final sut = ChecksumStub(checksum);
      final bytes = faker.randomGenerator.numbers(255, 80);
      final badChecksum = faker.randomGenerator.numbers(255, 2);

      final result = sut.validate(bytes, badChecksum);
      expect(result, isFalse);
    });
  });
  group('CRC16', () {
    test('extends Checksum', () {
      final sut = CRC16();
      expect(sut, isInstanceOf<Checksum>());
    });
    group('computes/validates the checksum nicely', () {
      final data = [
        [
          "ABCD1234",
          [0xe7, 0x1b]
        ],
        [
          "AAAAAAAA",
          [0x14, 0xaa]
        ]
      ];
      data.forEach((d) {
        final text = d[0] as String;
        final data = ascii.encode(text);
        final crc = d[1] as Iterable<int>;

        test("compute '$text", () {
          final sut = CRC16();
          final bytes = sut.compute(data);
          expect(bytes, crc);
        });

        test("validate '$text", () {
          final sut = CRC16();
          final result = sut.validate(data, crc);
          expect(result, isTrue);
        });

        test("validation fails when crc is wrong: '$text", () {
          final sut = CRC16();
          final badChecksum = faker.randomGenerator.numbers(255, 2);
          final result = sut.validate(data, badChecksum);
          expect(result, isFalse);
        });
      });
    });
  });

  group('some special cases should not throw error', () {
    final data = ['GIN00200'];
    data.forEach((d) {
      test(d, () {
        final sut = CRC16();
        final bytes = BytesBuilder().addString(d).addByte2(Byte.ETB).build();
        final checksum = sut.compute(bytes);
        expect(checksum, isNotEmpty);
      });
    });
  });
}
