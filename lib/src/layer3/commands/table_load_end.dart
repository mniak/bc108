import 'package:bc108/src/layer2/exports.dart';

import '../handler.dart';
import '../mapper.dart';

class Mapper implements RequestResponseMapper<void, void> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("TLE", []);
  }

  @override
  void mapResponse(void request, CommandResponse result) {}
}

class TableLoadEndFactory {
  RequestHandler<void, void> tableLoadEnd(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
