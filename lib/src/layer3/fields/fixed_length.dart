import 'exceptions.dart';
import 'field.dart';
import 'field_result.dart';

abstract class FixedLengthField<T> implements Field<T> {
  int _length;
  int get length => _length;
  FixedLengthField(this._length);

  T simpleParse(String text);

  FieldResult<T> parse(String text) {
    if (text == null) throw FieldParseException.isNull();
    if (text.length < _length) throw FieldParseException.short(_length);
    return FieldResult(
      simpleParse(text.substring(0, _length)),
      text.substring(_length),
    );
  }
}
