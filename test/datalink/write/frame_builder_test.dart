import 'dart:convert';

import 'package:bc108/datalink/utils/checksum.dart';
import 'package:bc108/datalink/write/frame_builder.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ChecksumMock extends Mock implements ChecksumAlgorithm {}

class SUT {
  ChecksumAlgorithm checksumAlgorithm;
  FrameBuilder builder;
  SUT() {
    checksumAlgorithm = ChecksumMock();
    builder = FrameBuilder(checksumAlgorithm: checksumAlgorithm);
  }
}

void main() {
  test('happy scenario', () {
    final sut = SUT();
    when(sut.checksumAlgorithm.compute(any)).thenReturn([0x98, 0x99]);

    final payload = faker.lorem.sentence();
    final bytes = sut.builder.build(payload);

    final expected = [0x16, ...ascii.encode(payload), 0x17, 0x98, 0x99];
    expect(bytes, equals(expected));
  });
}
