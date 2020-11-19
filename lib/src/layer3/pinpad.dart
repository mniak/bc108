import 'package:bc108/src/layer1/exports.dart';
import 'package:bc108/src/layer2/exports.dart';
import 'exports.dart';

import 'commands/get_info.dart';
import 'factory.dart';
import 'pinpad_result.dart';

class Pinpad {
  Operator _operator;
  RequestHandlerFactory _factory;

  Pinpad(this._operator, this._factory);
  Pinpad.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(Operator.fromStreamAndSink(stream, sink), RequestHandlerFactory());

  void close() => _operator.close();

  Future<PinpadResult<GetInfo00Response>> getInfo00() =>
      _factory.getInfo(_operator).handle(null);

  Future<PinpadResult<void>> display(DisplayRequest request) =>
      _factory.display(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_operator).handle(null);

  Future<PinpadResult<GetTimestampResponse>> getTimestamp(
          GetTimestampRequest request) =>
      _factory.getTimestamp(_operator).handle(request);
}
