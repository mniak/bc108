import 'package:bc108/bc108.dart';
import '../mapper.dart';
import '../handler.dart';

class Mapper implements RequestResponseMapper<void, void> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("GKY", []);
  }

  @override
  void mapResponse(void request, CommandResponse result) {
    return null;
  }
}

class GetKeyFactory {
  RequestHandler<void, void> getKey(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
