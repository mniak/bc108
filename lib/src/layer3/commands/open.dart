import 'package:bc108/src/layer2/exports.dart';

import '../handler.dart';
import '../mapper.dart';

class Mapper extends RequestResponseMapper<void, void> {
  @override
  Command mapRequest(void request) {
    return Command("OPN", []);
  }

  @override
  void mapResponse(CommandResult result) {}
}

class OpenFactory {
  RequestHandler<void, void> open(Operator o) =>
      RequestHandler.fromMapper(o, Mapper());
}
