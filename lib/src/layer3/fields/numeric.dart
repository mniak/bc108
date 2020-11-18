import 'fixed_length.dart';

class NumericField extends FixedLengthField<int> {
  NumericField(int length) : super(length);

  @override
  int simpleParse(String text) => int.parse(text);

  @override
  String serialize(int data) {
    return data.toString().padLeft(length, '0').substring(0, length);
  }
}
