import 'package:convert/convert.dart';

enum EmvTagClass {
  Universal,
  Application,
  ContextSpecific,
  Private,
}

class EmvTag {
  EmvTagClass emvClass;
  bool isPrimitive;
  int value;

  EmvTag();

  EmvTag.parse(String tag) {
    final bytes = hex.decode(tag);
    emvClass = getClass(bytes);
    isPrimitive = checkPrimitive(bytes);
    value = getValue(bytes);
  }

  static EmvTagClass getClass(Iterable<int> bytes) {
    switch (bytes.first >> 6 & 3) {
      case 0:
        return EmvTagClass.Universal;
      case 1:
        return EmvTagClass.Application;
      case 2:
        return EmvTagClass.ContextSpecific;
      case 3:
        return EmvTagClass.Private;
    }
    return EmvTagClass.Universal;
  }

  static bool checkPrimitive(Iterable<int> bytes) {
    return bytes.first >> 5 & 1 == 0;
  }

  static int getValue(Iterable<int> bytes) {
    final it = bytes.iterator;
    it.moveNext();

    final v = it.current & 31;
    if (v != 31) return v;

    var result = 0;
    while (it.moveNext()) {
      result *= 128;
      result += it.current & 127;

      if (it.current < 128) return result;
    }
    throw ArgumentError.value(bytes, "bytes", "Expecting more bytes");
  }

  @override
  String toString() {
    int classNumber = 0;
    switch (emvClass) {
      case EmvTagClass.Application:
        classNumber = 1;
        break;
      case EmvTagClass.ContextSpecific:
        classNumber = 2;
        break;
      case EmvTagClass.Private:
        classNumber = 3;
        break;
    }

    final primitiveBit = isPrimitive ? 0 : 1;

    var value = this.value;
    final hasMoreBytes = value > 31;
    final bit6 = (hasMoreBytes || value > 15) ? 1 : 0;

    final firstOctet =
        ((classNumber << 2) + (primitiveBit << 1) + bit6).toRadixString(16);

    if (value < 32)
      return (firstOctet + (value & 15).toRadixString(16)).toUpperCase();

    var hex = "";
    var last = true;
    do {
      var num = value & 127;
      if (last) {
        last = false;
      } else {
        num += 128;
      }
      hex = num.toRadixString(16) + hex;
      value >>= 7;
    } while (value > 0);
    return (firstOctet + "F" + hex).toUpperCase();
  }
}
