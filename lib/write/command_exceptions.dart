class InvalidCommandLengthException implements Exception {
  String message;
  InvalidCommandLengthException(int length) {
    this.message =
        "The command must be 3 characters long but has $length characters";
  }

  String toString() {
    return "InvalidCommandLengthException: $message";
  }
}

class ParameterTooLongException implements Exception {
  String message;
  ParameterTooLongException(int length) {
    this.message =
        "Parameter must be at most 999 characters long but has $length characters";
  }

  String toString() {
    return "ParameterTooLongException: $message";
  }
}
