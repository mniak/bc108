import 'package:bc108/src/layer3/fields/field.dart';
import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/composite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FieldMock extends Mock implements Field {}

void main() {
  group('parse', () {
    test('happy scenario', () {
      final recordField1 = FieldMock();
      final recordField2 = FieldMock();

      when(recordField1.parse("initial"))
          .thenReturn(FieldResult("A", "a_remaining"));
      when(recordField2.parse("a_remaining"))
          .thenReturn(FieldResult("B", "b_remaining"));

      final sut = CompositeField([recordField1, recordField2]);
      final result = sut.parse("initial");

      expect(result.data, equals(["A", "B"]));
      expect(result.remaining, equals("b_remaining"));
    });
  });

  group('serialize', () {
    test('happy scenario', () {
      final recordField1 = FieldMock();
      final recordField2 = FieldMock();

      when(recordField1.serialize(1)).thenReturn("data1");
      when(recordField2.serialize(2)).thenReturn("data2");

      final sut = CompositeField([recordField1, recordField2]);
      final result = sut.serialize([1, 2]);

      expect(result, equals("data1" + "data2"));
    });
  });
}
