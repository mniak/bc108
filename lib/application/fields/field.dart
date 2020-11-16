import 'field_result.dart';

abstract class Field<T> {
  FieldResult<T> parse(String text);
  String serialize(T data);
}
