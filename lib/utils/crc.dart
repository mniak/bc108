library utils;

import 'dart:typed_data';

Uint8List crc16(Uint8List data) {
  final mask = 0x1021;
  int crc = 0;
  for (var b in data) {
    var word = b << 8;
    for (var i = 0; i < 8; i++) {
      if (((crc ^ word) & 0x8000) != 0) {
        crc <<= 1;
        crc ^= mask;
      } else {
        crc <<= 1;
      }

      word <<= 1;
    }
  }
  return Uint8List.fromList([crc >> 8, crc % 256]);
}
