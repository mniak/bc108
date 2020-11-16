import 'package:bc108/datalink/read/reader.dart';

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
