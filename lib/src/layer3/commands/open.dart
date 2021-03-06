import 'package:bc108/src/layer2/exports.dart';

import '../handler.dart';
import '../mapper.dart';

class Mapper implements RequestResponseMapper<void, void> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("OPN", []);
  }

  @override
  void mapResponse(void request, CommandResponse result) {}
}

class OpenFactory {
  RequestHandler<void, void> open(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
