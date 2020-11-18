import 'package:bc108/src/layer3/fields/fixed_length.dart';
import 'package:bc108/src/layer3/fields/numeric.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumericField', () {
    test('is a FixedLengthField', () {
      final sut = NumericField(8);
      expect(sut, isA<FixedLengthField<int>>());
    });
    test('simpleParse parses the int', () {
      final sut = NumericField(faker.randomGenerator.integer(4));
      final number = faker.randomGenerator.integer(9);
      final result = sut.simpleParse("000" + number.toString());
      expect(result, equals(number));
    });

    test('serialize pads left the number with zeroes', () {
      final sut = NumericField(6);
      final number = 1234;
      final result = sut.serialize(number);
      expect(result, equals("00" + number.toString()));
    });

    test('serialize truncates the number', () {
      final sut = NumericField(4);
      final result = sut.serialize(123456);
      expect(result, equals("1234"));
    });
  });
}
