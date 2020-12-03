import 'package:bc108/src/layer2/exports.dart';

import '../fields/numeric.dart';
import '../fields/composite.dart';
import '../mapper.dart';
import '../handler.dart';

class TableLoadInitRequest {
  int acquirer = 0;
  int timestamp = 0;

  TableLoadInitRequest([this.acquirer, this.timestamp]);
}

class Mapper implements RequestResponseMapper<TableLoadInitRequest, void> {
  static final _requestField = CompositeField([
    NumericField(2),
    NumericField(10),
  ]);

  @override
  CommandRequest mapRequest(TableLoadInitRequest request) {
    return CommandRequest("TLI", [
      _requestField.serialize([
        request.acquirer,
        request.timestamp,
      ])
    ]);
  }

  @override
  void mapResponse(TableLoadInitRequest request, CommandResponse result) {}
}

class TableLoadInitFactory {
  RequestHandler<TableLoadInitRequest, void> tableLoadInit(
          CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
