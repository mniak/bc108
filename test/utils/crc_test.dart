import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:bc108/utils/utils.dart';

class TextCRC {
  TextCRC(this.text, this.crc1, this.crc2);
  String text;
  int crc1;
  int crc2;
}

void main() {
  group('CRC16', () {
    final data = [
      TextCRC("ABCD1234", 0xe7, 0x1b),
      TextCRC("AAAAAAAA", 0x14, 0xaa)
    ];
    data.forEach((d) {
      test(d.text, () {
        final bytes = crc16(ascii.encode(d.text));
        expect(bytes, [d.crc1, d.crc2]);
      });
    });
  });
}
