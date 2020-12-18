import 'package:bc108/src/layer3/fields/exceptions.dart';
import 'package:bc108/src/layer3/fields/fixed_length.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class FixedLengthFieldMock extends FixedLengthField with Mock {
  FixedLengthFieldMock(int length) : super(length);
}

void main() {
  group('parse', () {
    test('happy scenario', () {
      final length = faker.randomGenerator.integer(100) + 10;

      final sut = FixedLengthFieldMock(length);
      final value = "A" * length;
      final expectedValue = "B" * length;
      final extra = "x" * 5;

      when(sut.simpleParse(value)).thenReturn(expectedValue);

      final result = sut.parse(value + extra);
      expect(result.data, equals(expectedValue));
      expect(result.remaining, equals(extra));
    });

    test('when text length is lower than the field length, should raise error',
        () {
      final length = 10;

      final sut = FixedLengthFieldMock(length);
      final value = "A" * (length - 1);

      expect(() => sut.parse(value), throwsA(isA<FieldParseException>()));
    });

    test('when text is null, should raise error', () {
      final length = 10;

      final sut = FixedLengthFieldMock(length);

      expect(() => sut.parse(null), throwsA(isA<FieldParseException>()));
    });
  });
}
