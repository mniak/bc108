abstract class PinpadException implements Exception {}

class ChecksumException implements PinpadException {
  String message;
  ChecksumException(Iterable<int> expected) {
    final b1 = expected.first;
    final b2 = expected.skip(1).first;
    final long = b1 * 256 + b2;
    this.message = "Invalid checksum. Expecting 0x${long.toRadixString(16)}.";
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

class PayloadTooShortException implements PinpadException {
  String message;
  PayloadTooShortException() {
    this.message = "Payload must be at least 1 byte long";
  }

  String toString() {
    return "PayloadTooShortException: $message";
  }
}

class PayloadTooLongException implements PinpadException {
  String message;
  PayloadTooLongException(int length) {
    this.message =
        "Payload must be at most 1024 bytes long but has $length bytes";
  }

  String toString() {
    return "PayloadTooLongException: $message";
  }
}
