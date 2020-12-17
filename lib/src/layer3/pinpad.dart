import 'package:bc108/src/layer3/commands/finish_chip.dart';

import '../layer1/exports.dart';
import '../layer2/command_processor.dart';

import 'exports.dart';

class Pinpad {
  CommandProcessor _processor;
  RequestHandlerFactory _factory;

  Pinpad(this._processor, this._factory);
  Pinpad.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(CommandProcessor.fromStreamAndSink(stream, sink),
            RequestHandlerFactory());

  void done() => _processor.close();

  Stream<String> get notifications => _processor.notifications;

  Future<PinpadResult<void>> open() => _factory.open(_processor).handle(null);
  Future<PinpadResult<void>> close(CloseRequest request) =>
      _factory.close(_processor).handle(request);

  Future<PinpadResult<GetInfo00Response>> getInfo00() =>
      _factory.getInfo(_processor).handle(null);

  Future<PinpadResult<void>> display(DisplayRequest request) =>
      _factory.display(_processor).handle(request);

  Future<PinpadResult<void>> getKey() =>
      _factory.getKey(_processor).handle(null, blocking: true);

  Future<PinpadResult<void>> removeCard(RemoveCardRequest request) =>
      _factory.removeCard(_processor).handle(request, blocking: true);

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_processor).handle(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_processor).handle(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_processor).handle(null);

  Future<PinpadResult<GetTimestampResponse>> getTimestamp(
          GetTimestampRequest request) =>
      _factory.getTimestamp(_processor).handle(request);

  Future<PinpadResult<GetCardResponse>> getCard(GetCardRequest request) =>
      _factory.getCard(_processor).handle(request, blocking: true);

  Future<PinpadResult<GetCardResponse>> resumeGetCard() =>
      _factory.resumeGetCard(_processor).handle(null, blocking: true);

  Future<PinpadResult<GoOnChipResponse>> goOnChip(GoOnChipRequest request) =>
      _factory.goOnChip(_processor).handle(request, blocking: true);

  Future<PinpadResult<FinishChipResponse>> finishChip(
          FinishChipRequest request) =>
      _factory.finishChip(_processor).handle(request);

  Future abort() {
    return _processor.abort();
  }
}
