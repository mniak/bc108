abstract class PinpadException implements Exception {}

class ChecksumException implements PinpadException {
  String message;
  ChecksumException(int expected, int actual) {
    this.message =
        "Expected checksum to be 0x${expected.toRadixString(16)} 0x${actual.toRadixString(16)}";
  }
  String toString() {
    return "ChecksumException: $message";
  }
}

class ByteOutOfRangeException implements PinpadException {
  String message;
  ByteOutOfRangeException(int byte) {
    this.message = "Byte out of range: 0x${byte.toRadixString(16)}";
  }
  String toString() {
    return "ByteOutOfRangeException: $message";
  }
}

class ExpectedSynException implements PinpadException {
  String message;
  ExpectedSynException(int byte) {
    this.message =
        "Expecting byte SYN (0x16) but got 0x${byte.toRadixString(16)}";
  }

  String toString() {
    return "ExpectedSynException: $message";
  }
}

class InvalidPayloadLengthException implements PinpadException {
  String message;
  InvalidPayloadLengthException(int length) {
    this.message =
        "Payload length expected to be in range 1-1024 but got was $length";
  }

  String toString() {
    return "InvalidPayloadLengthException: $message";
  }
}
