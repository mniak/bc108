abstract class PinpadException implements Exception {}

class ChecksumException implements PinpadException {
  String message;
  ChecksumException(int byte1, int byte2) {
    this.message =
        "Invalid checksum: 0x${byte1.toRadixString(16)}${byte2.toRadixString(16)}";
  }
  String toString() {
    if (message == null) return "Exception";
    return "ChecksumException: $message";
  }
}

class ByteOutOfRangeException implements PinpadException {
  String message;
  ByteOutOfRangeException(int byte) {
    this.message = "Byte out of range: 0x${byte.toRadixString(16)}";
  }
  String toString() {
    if (message == null) return "Exception";
    return "ByteOutOfRangeException: $message";
  }
}
