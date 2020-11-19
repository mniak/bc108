import 'package:bc108/src/layer2/exports.dart';

import '../fields/numeric.dart';
import '../fields/alphanumeric.dart';
import '../fields/composite.dart';
import '../handler.dart';
import '../mapper.dart';

class GetInfo00Response {
  String manufacturer;
  String modelAndHardwareVersion;
  bool supportsContactless;
  String softwareVersion;
  String specificationVersion;
  String baseApplicationVersion;
  String serialNumber;
}

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
