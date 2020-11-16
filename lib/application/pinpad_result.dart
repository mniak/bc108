import 'read/command_result.dart';
import 'statuses.dart';

class PinpadResult<T> {
  Status _status;
  T _data;

  Status get status => _status;
  T get data => _data;

  PinpadResult.fromCommandResult(
      CommandResult commandResult, CommandResponseMapper<T> mapFn) {
    _status = commandResult.status;
    _data = mapFn(commandResult.parameters);
  }
}

typedef CommandResponseMapper<T> = T Function(Iterable<String>);