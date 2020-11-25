import 'package:bc108/src/layer2/exports.dart';

import '../handler.dart';
import '../mapper.dart';

class Mapper extends RequestResponseMapper<void, void> {
  @override
  Command mapRequest(void request) {
    return Command("TLE", []);
  }

  @override
  void mapResponse(CommandResult result) {}
}

class TableLoadEndFactory {
  RequestHandler<void, void> tableLoadEnd(OperatorL2 o) =>
      RequestHandler.fromMapper(o, Mapper());
}
