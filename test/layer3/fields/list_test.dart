import 'package:bc108/src/layer3/fields/field.dart';
import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/list.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class FieldMock extends Mock implements Field {}

void main() {
  group('parse', () {
    test('happy scenario', () {
      final recordField = FieldMock();

      when(recordField.parse("initial"))
          .thenReturn(FieldResult("A", "a_remaining"));
      when(recordField.parse("a_remaining"))
          .thenReturn(FieldResult("B", "b_remaining"));
      when(recordField.parse("b_remaining"))
          .thenReturn(FieldResult("C", "c_remaining"));

      final sut = ListField(4, recordField);
      final result = sut.parse("0002initial");

      expect(result.data, equals(["A", "B"]));
      expect(result.remaining, equals("b_remaining"));
    });
  });

  group('serialize', () {
    test('happy scenario', () {
      final recordField = FieldMock();

      when(recordField.serialize(1)).thenReturn("data1");
      when(recordField.serialize(2)).thenReturn("data2");

      final sut = ListField(4, recordField);
      final result = sut.serialize([1, 2]);

      expect(result, equals("0002" + "data1" + "data2"));
    });
  });
}
