abstract class CommandResultParseException implements Exception {}

class InvalidResultException implements CommandResultParseException {
  String message;
  InvalidResultException(String reason) {
    this.message = "The result is invalid. $reason";
  }

  String toString() {
    return "InvalidResultException: $message";
  }
}
