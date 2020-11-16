import 'package:bc108/application/commands/getinfo/request.dart';
import 'package:bc108/application/commands/getinfo/response.dart';
import 'package:bc108/application/commands/tableLoadInit/request.dart';
import 'package:bc108/application/operator.dart';
import 'package:bc108/datalink/read/reader.dart';

import 'commands/tableLoadRec/request.dart';
import 'pinpad_exceptions.dart';
import 'pinpad_result.dart';
import 'write/command.dart';

class Pinpad {
  Operator _operator;
  Pinpad(this._operator);
  Pinpad.fromStreamAndSink(Stream<ReaderEvent> stream, Sink<int> sink)
      : this(Operator.fromStreamAndSink(stream, sink));

  Future<PinpadResult<TResponse>> _execute<TRequest, TResponse>(String code,
      TRequest request, CommandResponseMapper<TResponse> mapFn) async {
    final request = GetInfoRequest(0);
    final commandResult = await _operator.execute(Command(code, [
      request.toString(),
    ]));

    if (commandResult.code != code)
      throw InvalidCommandCodeInResponseException(commandResult.code, code);

    return PinpadResult<TResponse>.fromCommandResult(commandResult, mapFn);
  }

  void close() => _operator.close();

  Future<PinpadResult<GetInfo00Response>> getInfo00() => _execute(
        "GIN",
        GetInfoRequest(0),
        (x) => GetInfo00Response.parse(x.first),
      );

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _execute(
        "TLI",
        request,
        (_) {},
      );

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _execute(
        "TLR",
        request,
        (_) {},
      );

  Future<PinpadResult<void>> tableLoadEnd() => _execute("TLE", "", (_) {});
}
