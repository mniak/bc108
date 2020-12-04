import '../layer1/exports.dart';
import '../layer2/command_processor.dart';

import 'exports.dart';

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
      _factory.getKey(_operator).handle(null, blocking: true);

  Future<PinpadResult<void>> removeCard(RemoveCardRequest request) =>
      _factory.removeCard(_operator).handle(request, blocking: true);

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_operator).handle(null);

  Future<PinpadResult<GetTimestampResponse>> getTimestamp(
          GetTimestampRequest request) =>
      _factory.getTimestamp(_operator).handle(request);

  Future<PinpadResult<GetCardResponse>> getCard(GetCardRequest request) =>
      _factory.getCard(_operator).handle(request, blocking: true);

  Future<PinpadResult<GetCardResponse>> resumeGetCard() =>
      _factory.resumeGetCard(_operator).handle(null, blocking: true);

  Future<PinpadResult<GoOnChipResponse>> goOnChip(GoOnChipRequest request) =>
      _factory.goOnChip(_operator).handle(request, blocking: true);
}
