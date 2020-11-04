import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinpad/receiver.dart';
import 'package:pinpad/utils/utils.dart';

class TextCRC {
  TextCRC(this.text, this.crc1, this.crc2);
  String text;
  int crc1;
  int crc2;
}

void main() {
  group('receive well formatted message', () {
    final data = [
      TextCRC("OPN000", 0x77, 0x5e),
      TextCRC("AAAAAAAA", 0x9a, 0x63)
    ];
    data.forEach((d) {
      test(d.text, () {
        final streamController = StreamController<Uint8List>();
        final stream = streamController.stream.transform(ReaderTransformer());

        final bytes = BytesBuilder()
            .addByte(Byte.SYN.toInt())
            .addString(d.text)
            .addByte(Byte.ETB.toInt())
            .addBytes([d.crc1, d.crc2]).build();

        streamController.sink.add(bytes);
        expectLater(stream, emitsInOrder([d.text]));

        streamController.close();
      });
    });
  });
}
