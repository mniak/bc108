import 'command.dart';

class CommandFactory {
  Command display(String message) {
    if (message.length > 32) throw ArgumentError.value(message);
    final cmd = Command("DSP", [message]);
    return cmd;
  }

  Command getInfo(int num) {
    if (num < 0 || num >= 9) throw ArgumentError.value(num);
    final cmd = Command("GIN", [
      num.toString().padLeft(2, '0'),
    ]);
    return cmd;
  }

  Command tableLoadInit(int acquirer, int timestamp) {
    if (acquirer < 0 || acquirer >= 9) throw ArgumentError.value(num);
    if (timestamp < 0 || timestamp > 9999999999)
      throw ArgumentError.value(timestamp);
    final cmd = Command("TLI", [
      acquirer.toString().padLeft(2, '0'),
      _formatTimestamp(timestamp),
    ]);
    return cmd;
  }

  Command tableLoadRec(int acquirer, int timestamp) {
    if (acquirer < 0 || acquirer >= 9) throw ArgumentError.value(num);
    if (timestamp < 0 || timestamp > 9999999999)
      throw ArgumentError.value(timestamp);
    final cmd = Command("TLI", [
      acquirer.toString().padLeft(2, '0'),
      _formatTimestamp(timestamp),
    ]);
    return cmd;
  }

  String _formatTimestamp(int timestamp) {
    final result = timestamp.toString().padLeft(10, '0');
    return result;
  }
}
