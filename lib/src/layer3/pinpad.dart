import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer2/operator_L2.dart';
import 'package:bc108/src/layer3/commands/close.dart';
import 'exports.dart';

import 'commands/get_info.dart';
import 'factory.dart';
import 'pinpad_result.dart';

class Pinpad {
  OperatorL2 _operator;
  RequestHandlerFactory _factory;

  Pinpad(this._operator, this._factory);
  Pinpad.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(OperatorL2.fromStreamAndSink(stream, sink),
            RequestHandlerFactory());

  void done() => _operator.close();

  Stream<String> get notifications => _operator.notifications;

  Future<PinpadResult<void>> open() =>
      _factory.open(_operator).handleNonBlocking(null);
  Future<PinpadResult<void>> close(CloseRequest request) =>
      _factory.close(_operator).handleNonBlocking(request);

  Future<PinpadResult<GetInfo00Response>> getInfo00() =>
      _factory.getInfo(_operator).handleNonBlocking(null);

  Future<PinpadResult<void>> display(DisplayRequest request) =>
      _factory.display(_operator).handleNonBlocking(request);

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_operator).handleNonBlocking(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_operator).handleNonBlocking(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_operator).handleNonBlocking(null);

  Future<PinpadResult<GetTimestampResponse>> getTimestamp(
          GetTimestampRequest request) =>
      _factory.getTimestamp(_operator).handleNonBlocking(request);

  Future<PinpadResult<GetCardResponse>> getCard(GetCardRequest request) =>
      _factory.getCard(_operator).handleBlocking(request);
}
