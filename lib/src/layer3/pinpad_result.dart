import 'package:bc108/src/layer2/exports.dart';

class PinpadResult<T> {
  Status _status;
  T _data;

  Status get status => _status;
  T get data => _data;

  PinpadResult(this._status, this._data);

  // static PinpadResult<T> fromCommandResult<T>(
  //     CommandResult commandResult, CommandResponseMapper<T> mapFn) {
  //   return PinpadResult(commandResult.status, mapFn(commandResult.parameters));
  // }
}

// typedef CommandResponseMapper<T> = T Function(Iterable<String> params);
