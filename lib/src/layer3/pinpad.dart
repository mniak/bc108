import 'package:bc108/src/layer1/exports.dart';
import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/commands/table_load_init.dart';
import 'package:bc108/src/layer3/commands/table_load_rec.dart';

import 'commands/get_info.dart';
import 'factory.dart';
import 'pinpad_result.dart';

class Pinpad {
  Operator _operator;
  RequestHandlerFactory _factory;

  Pinpad(this._operator, this._factory);
  Pinpad.fromStreamAndSink(Stream<ReaderEvent> stream, Sink<int> sink)
      : this(Operator.fromStreamAndSink(stream, sink), RequestHandlerFactory());

  void close() => _operator.close();

  Future<PinpadResult<void>> tableLoadInit(TableLoadInitRequest request) =>
      _factory.tableLoadInit(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadRec(TableLoadRecRequest request) =>
      _factory.tableLoadRec(_operator).handle(request);

  Future<PinpadResult<void>> tableLoadEnd() =>
      _factory.tableLoadEnd(_operator).handle(null);

  Future<PinpadResult<GetInfo00Response>> getInfo00() =>
      _factory.getInfo(_operator).handle(null);
}
