class Command {
  String _code;
  Iterable<String> _parameters;
  Command(this._code, this._parameters);

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
