import 'package:bc108/src/layer3/fields/exceptions.dart';

import 'field.dart';
import 'field_result.dart';
import 'numeric.dart';

class AlphanumericField implements Field<String> {
  int _length;
  AlphanumericField(this._length);

  @override
  FieldResult<String> parse(String text) {
    if (text == null) throw FieldParseException.isNull();
    if (text.length < _length) throw FieldParseException.short(_length);
    return FieldResult(
      text.substring(0, _length).trim(),
      text.substring(_length),
    );
  }

  @override
  String serialize(String data) {
    return data.padRight(_length, ' ').substring(0, _length);
  }
}

class VariableAlphanumericField implements Field<String> {
  NumericField _headerField;
  bool _inclusive;

  VariableAlphanumericField(int headerLength, {inclusive = false}) {
    _headerField = NumericField(headerLength);
    _inclusive = inclusive;
  }

  @override
  FieldResult<String> parse(String text) {
    final header = _headerField.parse(text);
    text = header.remaining;

    final length = _inclusive ? header.data - _headerField.length : header.data;
    final elementField = AlphanumericField(length);
    return elementField.parse(header.remaining);
  }

  @override
  String serialize(String data) {
    final length = _inclusive ? data.length + _headerField.length : data.length;
    return _headerField.serialize(length) + data;
  }
}
