import 'package:bc108/src/layer2/exports.dart';

import '../fields/numeric.dart';
import '../fields/composite.dart';
import '../mapper.dart';
import '../handler.dart';

class TableLoadInitRequest {
  int acquirer;
  int timestamp;

  TableLoadInitRequest([this.acquirer, this.timestamp]);
}

class Mapper extends RequestResponseMapper<TableLoadInitRequest, void> {
  static final _requestField = CompositeField([
    NumericField(2),
    NumericField(10),
  ]);

  @override
  Command mapRequest(TableLoadInitRequest request) {
    return Command("TLI", [
      _requestField.serialize([
        request.acquirer,
        request.timestamp,
      ])
    ]);
  }

  @override
  void mapResponse(CommandResult result) {}
}

class TableLoadInitFactory {
  RequestHandler<TableLoadInitRequest, void> tableLoadInit(OperatorL2 o) =>
      RequestHandler.fromMapper(o, Mapper());
}
