library pinpad;

import 'dart:typed_data';

class DataPackage {
  DataPackage();

  DataPackage withBytes(Uint8List bytes) {
    this.bytes = bytes;
    return this;
  }

  Uint8List bytes;
}

Stream<DataPackage> readMessage(Stream<Uint8List> stream) {
  return null;
}
