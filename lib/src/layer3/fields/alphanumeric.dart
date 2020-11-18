import 'fixed_length.dart';
import 'variable_length.dart';

class AlphanumericField extends FixedLengthField<String> {
  AlphanumericField(int length) : super(length);

  @override
  String simpleParse(String text) => text;

  @override
  String serialize(String data) {
    return data.padRight(length, ' ').substring(0, length);
  }
}

class VariableAlphanumericField
    extends VariableLengthField<AlphanumericField, String> {
  VariableAlphanumericField(int headerLength) : super(headerLength);

  @override
  AlphanumericField getField(int length) => AlphanumericField(length);

  @override
  int getLength(String data) => data.length;
}
