library utils;

import 'dart:typed_data';
import 'package:collection/collection.dart';

abstract class ChecksumAlgorithm {
  Iterable<int> compute(Iterable<int> data);
  bool validate(Iterable<int> data, Iterable<int> checksum) {
    final computed = compute(data);
    final eq = IterableEquality().equals;
    return eq(computed, checksum);
  }
}

class CRC16 extends ChecksumAlgorithm {
  @override
  Iterable<int> compute(Iterable<int> data) {
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
}
