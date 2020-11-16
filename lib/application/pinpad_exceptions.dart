abstract class PinpadException implements Exception {}

class InvalidCommandCodeInResponseException implements PinpadException {
  String message;
  InvalidCommandCodeInResponseException(String code, String expectedCode) {
    this.message = "Expecting code '$expectedCode' but got '$code'.";
  }

  String toString() {
    return "InvalidCommandCodeInResponseException: $message";
  }
}
