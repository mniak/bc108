abstract class CommandResultException implements Exception {}

class CommandResultParseException implements CommandResultException {
  String message;
  CommandResultParseException(String reason) {
    this.message = "The result is invalid. $reason";
  }

  String toString() {
    return "CommandResultParseException: $message";
  }
}
