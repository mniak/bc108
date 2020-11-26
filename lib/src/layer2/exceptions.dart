abstract class CommandResponseException implements Exception {}

class CommandResponseParseException implements CommandResponseException {
  String message;
  CommandResponseParseException(String reason) {
    this.message = "The result is invalid. $reason";
  }

  String toString() {
    return "CommandResponseParseException: $message";
  }
}

abstract class CommandException implements Exception {}

class InvalidCommandLengthException implements CommandException {
  String message;
  InvalidCommandLengthException(int length) {
    this.message =
        "The command must be 3 characters long but has $length characters";
  }

  String toString() {
    return "InvalidCommandLengthException: $message";
  }
}

class ParameterTooLongException implements CommandException {
  String message;
  ParameterTooLongException(int length) {
    this.message =
        "Parameter must be at most 999 characters long but has $length characters";
  }

  String toString() {
    return "ParameterTooLongException: $message";
  }
}
