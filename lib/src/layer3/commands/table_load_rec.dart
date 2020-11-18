import 'package:bc108/src/layer2/exports.dart';

import '../fields/alphanumeric.dart';
import '../fields/list.dart';
import '../handler.dart';
import '../mapper.dart';

class TableLoadRecRequest {
  Iterable<String> records;
  TableLoadRecRequest([this.records]);
}

class Mapper extends RequestResponseMapper<TableLoadRecRequest, void> {
  static final _requestField = new ListField(
    2,
    VariableAlphanumericField(3, inclusive: true),
  );

  @override
  Command mapRequest(TableLoadRecRequest request) {
    return Command("TLR", [_requestField.serialize(request.records)]);
  }

  @override
  void mapResponse(CommandResult result) {}
}

class TableLoadRecFactory {
  RequestHandler<TableLoadRecRequest, void> tableLoadRec(Operator o) =>
      RequestHandler.fromMapper(o, Mapper());
}
