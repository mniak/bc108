import 'package:bc108/bc108.dart';
import '../mapper.dart';
import '../handler.dart';

class GetKeyRequest {}

class GetKeyResponse {}

class Mapper extends RequestResponseMapper<void, void> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("GKY", []);
  }

  @override
  void mapResponse(CommandResponse result) {
    return null;
  }
}

class GetKeyFactory {
  RequestHandler<void, void> getKey(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
