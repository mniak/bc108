import 'reader_event.dart';

abstract class FrameReceiverException implements Exception {}

class ExpectingAckOrNakException implements FrameReceiverException {
  String message;
  ExpectingAckOrNakException(ReaderEvent event) {
    this.message = "Expecting ACK/NAK but got ";
    if (event.isDataEvent) {
      this.message += "Data Event '${event.data}'";
    } else if (event.badCRC) {
      this.message += "Bad CRC";
    } else if (event.aborted) {
      this.message += "EOT";
    } else {
      this.message += "something else";
    }
  }

  String toString() {
    return "ExpectingAckOrNakException: $message";
  }
}

class ExpectingEotException implements FrameReceiverException {
  String message;
  ExpectingEotException(ReaderEvent event) {
    this.message = "Expecting EOT but got ";
    if (event.isDataEvent) {
      this.message += "Data Event '${event.data}'";
    } else if (event.ack) {
      this.message += "ACK instead";
    } else if (event.nak) {
      this.message += "NAK instead";
    } else if (event.badCRC) {
      this.message += "Bad CRC";
    } else {
      this.message += "anything else";
    }
  }

  String toString() {
    return "ExpectingEotException: $message";
  }
}

class ExpectingDataEventException implements FrameReceiverException {
  String message;
  ExpectingDataEventException(ReaderEvent event) {
    message = "Expecting Data Event but got ";
    if (event.ack) {
      this.message += "ACK";
    } else if (event.nak) {
      this.message += "NAK";
    } else if (event.badCRC) {
      this.message += "Bad CRC";
    } else if (event.aborted) {
      this.message += "EOT";
    } else {
      this.message += "anything else";
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
