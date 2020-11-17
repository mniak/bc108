abstract class CommandResultReceiverException implements Exception {}

class CommandAbortedException implements CommandResultReceiverException {
  String message;
  CommandAbortedException(String reason) {
    this.message = "The command was aborted: $reason";
  }

  String toString() {
    return "CommandAbortedException: $message";
  }
}
