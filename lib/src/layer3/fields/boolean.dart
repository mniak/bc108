import 'field_result.dart';
import 'field.dart';

class BooleanField implements Field<bool> {
  @override
  FieldResult<bool> parse(String text) {
    return FieldResult(text[0] == "1", text.substring(1));
  }

  @override
  String serialize(bool data) {
    return data ? "1" : "0";
  }
}
