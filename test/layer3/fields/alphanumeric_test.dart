import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:bc108/src/layer3/fields/fixed_length.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  group('AlphanumericField', () {
    test('is a FixedLengthField', () {
      final sut = AlphanumericField(8);
      expect(sut, isA<FixedLengthField<String>>());
    });

    test('simpleParse trims right the text', () {
      final sut = AlphanumericField(faker.randomGenerator.integer(200));
      final data = faker.lorem.sentence();
      final result = sut.simpleParse(data + "       ");
      expect(result, equals(data));
    });

    test('serialize pads right the text with spaces', () {
      final sut = AlphanumericField(8);
      final data = "123456";
      final result = sut.serialize(data);
      expect(result, equals(data + "  "));
    });

    test('serialize truncates the text', () {
      final sut = AlphanumericField(4);
      final result = sut.serialize("ABCDEFGHIJ");
      expect(result, equals("ABCD"));
    });
  });

  group('VariableAlphanumericField', () {
    test('getField creates an AlphanumericField with lenth N', () {
      final sut = VariableAlphanumericField(3);
      final length = faker.randomGenerator.integer(20) + 5;
      final field = sut.getField(length);

      expect(field, isA<AlphanumericField>());
      expect(field.length, equals(length));
    });

    test('getLength returns the appropriate length of the string', () {
      final sut = VariableAlphanumericField(3);
      final data = faker.lorem.sentence();
      final result = sut.getLength(data);

      expect(result, equals(data.length));
    });
  });

  group('FixedVariableAlphanumericField', () {
    test('serialize adds size header and pads with white spaces', () {
      final sut = FixedVariableAlphanumericField(3, 100);
      final data = faker.randomGenerator.string(20, min: 20);
      final result = sut.serialize(data);
      expect(result, equals("020" + data + (" " * 80)));
    });

    group(
        'parse ignores the data that exceeds the size indicated by the header',
        () {
      final data = [
        ["003ABCDEFGHIJhij", "ABC", "hij"],
        ["006ABCDEFGHIJhij", "ABCDEF", "hij"],
      ];
      data.forEach((d) {
        final string = d[0];
        final data = d[1];
        final remaining = d[2];

        test('$string => $data + $remaining', () {
          final sut = FixedVariableAlphanumericField(3, 10);
          final result = sut.parse(string);
          expect(result.data, equals(data));
          expect(result.remaining, equals(remaining));
        });
      });
    });
  });
}
