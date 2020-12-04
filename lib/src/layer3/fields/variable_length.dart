import 'field.dart';
import 'field_result.dart';
import 'numeric.dart';

class _DelegateVariableLengthField<T> extends VariableLengthField<T> {
  FieldResult<T> Function(int length, String text) _parseFn;
  String Function(T data) _serializeFn;

  @override
  FieldResult<T> innerParse(int length, String text) => _parseFn(length, text);

  @override
  String innerSerialize(T data) => _serializeFn(data);

  _DelegateVariableLengthField(
      int headerLength, this._parseFn, this._serializeFn,
      {bool inclusive = false})
      : super(headerLength, inclusive: inclusive);
}

abstract class VariableLengthField<T> implements Field<T> {
  NumericField _headerField;
  bool _inclusive;

  VariableLengthField(int headerLength, {bool inclusive = false}) {
    _headerField = NumericField(headerLength);
    _inclusive = inclusive;
  }

  factory VariableLengthField.build(
      int headerLength,
      FieldResult<T> Function(int length, String text) parseFn,
      String Function(T data) serializeFn,
      {bool inclusive = false}) {
    return _DelegateVariableLengthField(headerLength, parseFn, serializeFn,
        inclusive: inclusive);
  }

  FieldResult<T> innerParse(int length, String text);

  @override
  FieldResult<T> parse(String text) {
    final header = _headerField.parse(text);
    text = header.remaining;

    final fieldLength =
        _inclusive ? header.data - _headerField.length : header.data;

    return innerParse(fieldLength, header.remaining);
  }

  String innerSerialize(T data);

  @override
  String serialize(T data) {
    final serialized = innerSerialize(data);
    final dataLength = serialized.length;

    final fieldLength =
        _inclusive ? dataLength + _headerField.length : dataLength;

    return _headerField.serialize(fieldLength) + serialized;
  }
}
