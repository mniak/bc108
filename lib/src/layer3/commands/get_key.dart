import 'package:bc108/bc108.dart';
import '../mapper.dart';
import '../handler.dart';

class GetKeyRequest {}

class GetKeyResponse {}

class Mapper extends RequestResponseMapper<void, void> {
  @override
  Command mapRequest(void request) {
    return Command("GKY", []);
  }

  @override
  void mapResponse(CommandResult result) {
    return null;
  }
}

class GetKeyFactory {
  RequestHandler<void, void> getKey(Operator o) =>
      RequestHandler.fromMapper(o, Mapper());
}
