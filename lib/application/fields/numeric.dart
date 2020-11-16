import 'package:bc108/application/fields/field.dart';
import 'package:bc108/application/fields/field_result.dart';

class NumericField implements Field<int> {
  int _length;
  NumericField(this._length);

  int get length => _length;

  @override
  FieldResult<int> parse(String text) {
    return FieldResult(
      int.parse(text.substring(0, _length)),
      text.substring(_length),
    );
  }

  @override
  String serialize(int data) {
    final result = data.toString().padLeft(_length, '0');
    if (result.length > _length) throw ArgumentError.value(data);
    return result;
  }
}
