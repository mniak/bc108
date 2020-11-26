import 'package:bc108/src/layer2/exports.dart';

import '../handler.dart';
import '../mapper.dart';

class Mapper extends RequestResponseMapper<void, void> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("TLE", []);
  }

  @override
  void mapResponse(CommandResponse result) {}
}

class TableLoadEndFactory {
  RequestHandler<void, void> tableLoadEnd(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
