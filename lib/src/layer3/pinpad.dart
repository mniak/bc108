import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer2/command_processor.dart';
import 'package:bc108/src/layer3/commands/close.dart';
import 'exports.dart';

import 'commands/get_info.dart';
import 'factory.dart';
import '../layer1/pinpad_result.dart';

class Pinpad {
  CommandProcessor _operator;
  RequestHandlerFactory _factory;

  Pinpad(this._operator, this._factory);
  Pinpad.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(CommandProcessor.fromStreamAndSink(stream, sink),
            RequestHandlerFactory());

  void done() => _operator.close();

  Stream<String> get notifications => _operator.notifications;

  Future<PinpadResult<void>> open() => _factory.open(_operator).handle(null);
  Future<PinpadResult<void>> close(CloseRequest request) =>
      _factory.close(_operator).handle(request);

  Future<PinpadResult<GetInfo00Response>> getInfo00() =>
      _factory.getInfo(_operator).handle(null);

  Future<PinpadResult<void>> display(DisplayRequest request) =>
      _factory.display(_operator).handle(request);

  Future<PinpadResult<void>> getKey() =>
      _factory.getKey(_operator).handle(null);

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_operator).handle(null);

  Future<PinpadResult<GetTimestampResponse>> getTimestamp(
          GetTimestampRequest request) =>
      _factory.getTimestamp(_operator).handle(request);

  // Future<PinpadResult<GetCardResponse>> getCard(GetCardRequest request) =>
  //     _factory.getCard(_operator).handle(request);
}
