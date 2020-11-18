import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:bc108/src/layer1/utils/bytes_builder.dart';

final random = Random();

int randomByte() {
  return random.nextInt(256);
}

int randomChar() {
  return random.nextInt(0x7e - 0x20 + 1) + 0x20;
}

void main() {
  test('new has no bytes', () {
    final bytes = BytesBuilder().build();
    expect(bytes, Uint8List.fromList([]));
  });

  test('addByte adds a byte', () {
    final b1 = randomByte();
    final b2 = randomByte();
    final b3 = randomByte();
    final bytes = BytesBuilder().addByte(b1).addByte(b2).addByte(b3).build();
    expect(bytes, Uint8List.fromList([b1, b2, b3]));
  });

  test('addBytes adds a byte list', () {
    final b1 = randomByte();
    final b2 = randomByte();
    final b3 = randomByte();
    final b4 = randomByte();
    final bytes = BytesBuilder().addBytes([b1, b2]).addBytes([b3, b4]).build();
    expect(bytes, Uint8List.fromList([b1, b2, b3, b4]));
  });

  test('addString adds a string as ascii bytes', () {
    final c1 = randomChar();
    final c2 = randomChar();
    final c3 = randomChar();
    final c4 = randomChar();
    final bytes = BytesBuilder()
        .addString(String.fromCharCodes([c1, c2]))
        .addString(String.fromCharCodes([c3, c4]))
        .build();
    expect(bytes, Uint8List.fromList([c1, c2, c3, c4]));
  });

  test('addString ignores chars lower than 0x20', () {
    final c1 = random.nextInt(0x20);
    final c2 = randomChar();
    final c3 = random.nextInt(0x20);
    final c4 = randomChar();
    final bytes = BytesBuilder()
        .addString(ascii.decode([c1, c2]))
        .addString(ascii.decode([c3, c4]))
        .build();
    expect(bytes, Uint8List.fromList([c2, c4]));
  });

  test('addString ignores chars greater than 0x7E', () {
    final c1 = randomChar();
    final c2 = random.nextInt(256 - 0x7e - 1) + 0x7e + 1;
    final c3 = randomChar();
    final c4 = random.nextInt(256 - 0x7e - 1) + 0x7e + 1;
    final bytes = BytesBuilder()
        .addString(ascii.decode([c1, c2], allowInvalid: true))
        .addString(ascii.decode([c3, c4], allowInvalid: true))
        .build();
    expect(bytes, Uint8List.fromList([c1, c3]));
  });
}
