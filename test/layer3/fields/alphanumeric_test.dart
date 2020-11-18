import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:bc108/src/layer3/fields/exceptions.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlphanumericField', () {
    test('happy scenario', () {
      final length = faker.randomGenerator.integer(100) + 10;

      final sut = AlphanumericField(length);
      final value = "A" * length;
      final extra = "x" * 5;

      final result = sut.parse(value + extra);
      expect(result.data, equals(value));
      expect(result.remaining, equals(extra));
    });

    test('when text length is lower than the field length, should raise error',
        () {
      final length = 100;

      final sut = AlphanumericField(length);
      final value = "A" * (length - 10);

      expect(() => sut.parse(value), throwsA(isA<FieldParseException>()));
    });

    test('when text is null, should raise error', () {
      final length = 100;

      final sut = AlphanumericField(length);

      expect(() => sut.parse(null), throwsA(isA<FieldParseException>()));
    });
  });

  group('VariableAlphanumericField', () {
    group('Inclusive', () {
      test('happy scenario', () {
        final length = 100;
        final headerLength = 4;
        final header = "0104";

        final sut = VariableAlphanumericField(headerLength, inclusive: true);
        final value = "A" * length;
        final extra = "x" * 5;

        final result = sut.parse(header + value + extra);
        expect(result.data, equals(value));
        expect(result.remaining, equals(extra));
      });

      test(
          'when text length is lower than the field length, should raise error',
          () {
        final length = 10;
        final headerLength = 4;
        final header = "0014";

        final sut = VariableAlphanumericField(headerLength, inclusive: true);
        final value = "A" * (length - 1);

        expect(() => sut.parse(header + value),
            throwsA(isA<FieldParseException>()));
      });
    });
    group('Exclusive', () {
      test('happy scenario', () {
        final length = 10;
        final headerLength = 4;
        final header = "0010";

        final sut = VariableAlphanumericField(headerLength, inclusive: false);
        final expected = "A" * length;
        final extra = "x" * 5;

        final result = sut.parse(header + expected + extra);
        expect(result.data, equals(expected));
        expect(result.remaining, equals(extra));
      });

      test(
          'when text length is lower than the field length, should raise error',
          () {
        final length = 10;
        final headerLength = 4;
        final header = "0010";

        final sut = VariableAlphanumericField(headerLength, inclusive: false);
        final value = "A" * (length - 1);

        expect(() => sut.parse(header + value),
            throwsA(isA<FieldParseException>()));
      });
    });
    // test('when text length is lower than the field length, should raise error',
    //     () {
    //   final length = 100;

    //   final sut = AlphanumericField(length);
    //   final expected = "A" * (length - 10);

    //   expect(() => sut.parse(expected), throwsA(isA<FieldParseException>()));
    // });

    // test('when text is null, should raise error', () {
    //   final length = 100;

    //   final sut = AlphanumericField(length);

    //   expect(() => sut.parse(null), throwsA(isA<FieldParseException>()));
    // });
  });
}
