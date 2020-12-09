import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:convert/convert.dart' as convert;

import 'fixed_length.dart';
import 'variable_length.dart';

class BinaryField extends FixedLengthField<BinaryData> {
  BinaryField(int length) : super(length * 2);

  @override
  BinaryData simpleParse(String text) => BinaryData.fromHex(text);

  @override
  String serialize(BinaryData data) => data.hex.padLeft(length, '0');
}

class VariableBinaryField extends VariableLengthField<BinaryField, BinaryData> {
  VariableBinaryField(int headerLength, {bool inclusive = false})
      : super(headerLength, inclusive: inclusive);

  @override
  BinaryField getField(int length) => BinaryField(length);

  @override
  int getLength(BinaryData data) => data.bytes.length;
}

extension IntExtension on int {
  Uint8List get int32Binary =>
      Uint8List(4)..buffer.asByteData().setInt32(0, this, Endian.big);
}

class BinaryData {
  Iterable<int> _bytes;

  BinaryData.fromBytes(this._bytes);

  factory BinaryData.fromHex(String hex) =>
      BinaryData.fromBytes(convert.hex.decode(hex));

  factory BinaryData.fromString(String string) =>
      BinaryData.fromBytes(utf8.encode(string));

  factory BinaryData.empty() => BinaryData.fromBytes([]);

  Iterable<int> get bytes => _bytes;
  String get hex => convert.hex.encode(bytes).toUpperCase();
  String get string => utf8.decode(_bytes);

  static final Function _listEquality = ListEquality().equals;
  bool operator ==(o) =>
      o is BinaryData && _listEquality(this._bytes, o._bytes);
  @override
  int get hashCode =>
      _bytes.fold(17, (v, e) => (v * 37 + e.hashCode) * 37 + e.hashCode) %
      2147483647;

  @override
  String toString() => "{0x$hex}";
}
