import 'package:bc108/src/layer3/fields/composite.dart';
import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/numeric.dart';

import 'field.dart';
import 'fixed_length.dart';
import 'variable_length.dart';

class AlphanumericField extends FixedLengthField<String> {
  AlphanumericField(int length) : super(length);

  @override
  String simpleParse(String text) => text.trim();

  @override
  String serialize(String data) {
    return data.padRight(length, ' ').substring(0, length);
  }
}

class VariableAlphanumericField
    extends VariableLengthField<AlphanumericField, String> {
  VariableAlphanumericField(int headerLength, {bool inclusive})
      : super(headerLength, inclusive: inclusive);

  @override
  AlphanumericField getField(int length) => AlphanumericField(length);

  @override
  int getLength(String data) => data.length;
}

class FixedVariableAlphanumericField implements Field<String> {
  CompositeField _field;
  FixedVariableAlphanumericField(int headerLength, int fieldLength) {
    _field = CompositeField([
      NumericField(headerLength),
      AlphanumericField(fieldLength),
    ]);
  }

  @override
  FieldResult<String> parse(String text) {
    final result = _field.parse(text);
    final length = result.data[0] as int;
    final value = result.data[1] as String;
    return FieldResult<String>(value.substring(0, length), result.remaining);
  }

  @override
  String serialize(String data) {
    return _field.serialize([
      data.length,
      data,
    ]);
  }
}
