import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'fixed_length.dart';
import 'variable_length.dart';

class BinaryField extends FixedLengthField<Iterable<int>> {
  BinaryField(int length) : super(length * 2);

  @override
  Iterable<int> simpleParse(String text) => hex.decode(text);

  @override
  String serialize(Iterable<int> data) => hex
      .encode(List.from(data.take(length)))
      .toUpperCase()
      .padLeft(length, '0');
}

class VariableBinaryField
    extends VariableLengthField<BinaryField, Iterable<int>> {
  VariableBinaryField(int headerLength, {bool inclusive = false})
      : super(headerLength, inclusive: inclusive);

  @override
  BinaryField getField(int length) => BinaryField(length);

  @override
  int getLength(Iterable<int> data) => data.length;
}

extension IntExtension on int {
  Uint8List get int32Binary =>
      Uint8List(4)..buffer.asByteData().setInt32(0, this, Endian.big);
}
