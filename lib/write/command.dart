import 'package:bc108/write/command_exceptions.dart';

class Command {
  String _code;
  Iterable<String> _parameters;
  Command(this._code, this._parameters) {
    if (_code.length != 3) throw InvalidCommandLengthException(_code.length);

    final invalidLengths =
        parameters.map((p) => p.length).where((x) => x > 999);
    if (invalidLengths.isNotEmpty)
      throw ParameterTooLongException(invalidLengths.first);
  }

  String get code => _code;
  Iterable<String> get parameters => _parameters;

  String getPayload() {
    final sb = StringBuffer(_code);
    parameters.forEach((parameter) {
      sb.write(parameter.length.toString().padLeft(3, '0'));
      sb.write(parameter);
    });
    if (parameters.isEmpty) sb.write("000");
    final text = sb.toString();
    return text;
  }
}
