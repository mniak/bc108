import 'package:bc108/src/layer3/fields/fixed_length.dart';

import 'field.dart';
import 'field_result.dart';
import 'numeric.dart';

abstract class VariableLengthField<TField extends FixedLengthField<T>, T>
    implements Field<T> {
  NumericField _headerField;
  bool _inclusive;

  TField getField(int length);
  int getLength(T data);

  VariableLengthField(int headerLength, {bool inclusive = false}) {
    _headerField = NumericField(headerLength);
    _inclusive = inclusive;
  }

  @override
  FieldResult<T> parse(String text) {
    final header = _headerField.parse(text);
    text = header.remaining;

    final fieldLength =
        _inclusive ? header.data - _headerField.length : header.data;
    return getField(fieldLength).parse(header.remaining);
  }

  @override
  String serialize(T data) {
    final dataLength = getLength(data);
    final fieldLength =
        _inclusive ? dataLength + _headerField.length : dataLength;
    return _headerField.serialize(fieldLength) +
        getField(dataLength).serialize(data);
  }
}
