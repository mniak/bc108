import 'reader.dart';

abstract class FrameReceiverException implements Exception {}

class ExpectingAckOrNakException implements FrameReceiverException {
  String message;
  ExpectingAckOrNakException(ReaderEvent event) {
    if (event.isDataEvent) {
      this.message = "Expecting ACK/NAK but got Data Event '${event.data}'";
    } else {
      this.message = "Expecting ACK/NAK but got anything else";
    }
  }

  String toString() {
    return "ExpectingAckOrNakException: $message";
  }
}

class ExpectingDataEventException implements FrameReceiverException {
  String message;
  ExpectingDataEventException(ReaderEvent event) {
    if (event.ack) {
      this.message = "Expecting Data Event but got ACK";
    } else if (event.nak) {
      this.message = "Expecting Data Event but got NAK";
    } else {
      this.message = "Expecting Data Event but got anything else";
    }
  }
  String toString() {
    return "ExpectingDataEventException: $message";
  }
}

abstract class ReaderException implements Exception {}

class AbortedException implements ReaderException {
  String message;
  AbortedException() {
    this.message = "Aborted because the byte EOT (0x04) was received";
  }
  String toString() {
    return "AbortedException: $message";
  }
}

class ByteOutOfRangeException implements ReaderException {
  String message;
  ByteOutOfRangeException(int byte) {
    this.message = "Byte out of range: 0x${byte.toRadixString(16)}";
  }
  String toString() {
    return "ByteOutOfRangeException: $message";
  }
}

class ExpectedSynException implements ReaderException {
  String message;
  ExpectedSynException(int byte) {
    this.message =
        "Expecting byte SYN (0x16) but got 0x${byte.toRadixString(16)}";
  }

  String toString() {
    return "ExpectedSynException: $message";
  }
}

class PayloadTooShortException implements ReaderException {
  String message;
  PayloadTooShortException() {
    this.message = "Payload must be at least 1 byte long";
  }

  String toString() {
    return "PayloadTooShortException: $message";
  }
}

class PayloadTooLongException implements ReaderException {
  String message;
  PayloadTooLongException(int length) {
    this.message =
        "Payload must be at most 1024 bytes long but has $length bytes";
  }

  String toString() {
    return "PayloadTooLongException: $message";
  }
}
