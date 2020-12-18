import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/fixed_length.dart';
import 'package:bc108/src/layer3/fields/variable_length.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class VariableLengthFieldMock extends VariableLengthField with Mock {
  VariableLengthFieldMock(int length, {bool inclusive})
      : super(length, inclusive: inclusive);
}

class FieldMock extends Mock implements FixedLengthField {}

class FieldResultMock extends Mock implements FieldResult {}

void main() {
  var data = [
    ['inclusive (4)', true, 4, '0014', '#' * 10],
    ['exclusive (4)', false, 4, '0010', '#' * 10],
    ['inclusive (2)', true, 2, '12', '#' * 10],
    ['exclusive (2)', false, 2, '10', '#' * 10],
  ];
  data.forEach((d) {
    final groupName = d[0] as String;
    final inclusive = d[1] as bool;
    final headerLength = d[2] as int;
    final header = d[3] as String;
    final value = d[4] as String;

    group(groupName, () {
      group('parse', () {
        test('happy scenario', () {
          final sut =
              VariableLengthFieldMock(headerLength, inclusive: inclusive);
          final extra = "x" * 5;
          final field = FieldMock();
          final expected = FieldResultMock();

          when(sut.getField(value.length)).thenReturn(field);
          when(field.parse(value + extra)).thenReturn(expected);

          final result = sut.parse(header + value + extra);
          expect(result, equals(expected));
        });

        test('inner field.parse raises error, should rethrow', () {
          final sut =
              VariableLengthFieldMock(headerLength, inclusive: inclusive);

          final field = FieldMock();
          final exception = Exception(faker.lorem.sentence());

          when(sut.getField(value.length)).thenReturn(field);
          when(field.parse(value)).thenThrow(exception);

          expect(() => sut.parse(header + value), throwsA(equals(exception)));
        });
        test('inner getField() raises error, should rethrow', () {
          final sut =
              VariableLengthFieldMock(headerLength, inclusive: inclusive);

          final exception = Exception(faker.lorem.sentence());

          when(sut.getField(value.length)).thenThrow(exception);

          expect(() => sut.parse(header + value), throwsA(equals(exception)));
        });
      });
      group('serialize', () {
        test('happy scenario', () {
          final field = FieldMock();
          final expected = faker.lorem.sentence();

          final sut =
              VariableLengthFieldMock(headerLength, inclusive: inclusive);

          when(sut.getLength(value)).thenReturn(value.length);
          when(sut.getField(value.length)).thenReturn(field);
          when(field.serialize(value)).thenReturn(expected);

          final result = sut.serialize(value);
          expect(result, equals(header + expected));
        });
      });
    });
  });
}
