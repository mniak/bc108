import 'package:bc108/src/layer3/fields/binary.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BinaryField', () {
    test('when serialize [] should fill with zeroes', () {
      final sut = BinaryField(4);

      final result = sut.serialize(BinaryData.empty());
      expect(result, equals("00000000"));
    });

    group('when serialize [0x41, 0x42] should pad right with zeroes', () {
      test('from bytes', () {
        final sut = BinaryField(4);

        final result = sut.serialize(BinaryData.fromBytes([0x41, 0x42]));
        expect(result, equals("00004142"));
      });

      test('from string', () {
        final sut = BinaryField(4);

        final result = sut.serialize(BinaryData.fromHex("4142"));
        expect(result, equals("00004142"));
      });

      test('from string', () {
        final sut = BinaryField(4);

        final result = sut.serialize(BinaryData.fromString("AB"));
        expect(result, equals("00004142"));
      });
    });

    test('parse 00000000 should be parsed as [0, 0, 0, 0]', () {
      final sut = BinaryField(4);

      final result = sut.parse("00000000");

      expect(result.data.hex, equals("00000000"));
      expect(result.data.bytes, equals([0, 0, 0, 0]));
    });

    test('parse 20204142 should be parsed as "  AB"', () {
      final sut = BinaryField(4);

      final result = sut.parse("20204142");

      expect(result.data.hex, equals("20204142"));
      expect(result.data.bytes, equals([32, 32, 65, 66]));
      expect(result.data.string, equals("  AB"));
    });
  });

  group('VariableBinaryField', () {
    test('when serialize [] should not fill', () {
      final sut = VariableBinaryField(3);

      final result = sut.serialize(BinaryData.empty());
      expect(result, equals("000"));
    });

    group('when serialize [0x41, 0x42] should pad right with zeroes', () {
      test('from bytes', () {
        final sut = VariableBinaryField(1);

        final result = sut.serialize(BinaryData.fromBytes([0x41, 0x42]));
        expect(result, equals("24142"));
      });

      test('from string', () {
        final sut = VariableBinaryField(2);

        final result = sut.serialize(BinaryData.fromHex("4142"));
        expect(result, equals("024142"));
      });

      test('from string', () {
        final sut = VariableBinaryField(3);

        final result = sut.serialize(BinaryData.fromString("AB"));
        expect(result, equals("0024142"));
      });
    });

    test('parse 400000000 should be parsed as [0, 0, 0, 0]', () {
      final sut = VariableBinaryField(1);

      final result = sut.parse("400000000");

      expect(result.data.hex, equals("00000000"));
      expect(result.data.bytes, equals([0, 0, 0, 0]));
    });

    test('parse 20204142 should be parsed as "  AB"', () {
      final sut = VariableBinaryField(02);

      final result = sut.parse("0420204142");

      expect(result.data.hex, equals("20204142"));
      expect(result.data.bytes, equals([32, 32, 65, 66]));
      expect(result.data.string, equals("  AB"));
    });
  });

  group('BinaryData', () {
    test('equality test', () {
      final bytes = faker.randomGenerator.numbers(255, 100);

      final a = BinaryData.fromBytes(bytes);
      final b = BinaryData.fromBytes(bytes);

      expect(a, equals(b));
      expect(b, equals(a));
      expect(a.hashCode, equals(b.hashCode));
      expect(b.hashCode, equals(a.hashCode));
    });

    test('not equality test', () {
      final bytesA = faker.randomGenerator.numbers(255, 100);
      final bytesB = faker.randomGenerator.numbers(255, 100);

      final a = BinaryData.fromBytes(bytesA);
      final b = BinaryData.fromBytes(bytesB);

      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(a)));
    });
  });
}
