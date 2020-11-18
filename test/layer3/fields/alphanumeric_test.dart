import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlphanumericField', () {
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
}
