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

class Mapper implements RequestResponseMapper<void, GetInfo00Response> {
  static final _requestField = NumericField(2);

  static final _responseField = CompositeField([
    AlphanumericField(20),
    AlphanumericField(19),
    AlphanumericField(1),
    AlphanumericField(20),
    AlphanumericField(4),
    AlphanumericField(16),
    AlphanumericField(20),
  ]);

  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("GIN", [_requestField.serialize(0)]);
  }

  @override
  GetInfo00Response mapResponse(void request, CommandResponse result) {
    final parsed = _responseField.parse(result.parameters[0]);
    return GetInfo00Response()
      ..manufacturer = parsed.data[0]
      ..modelAndHardwareVersion = parsed.data[1]
      ..supportsContactless = parsed.data[2] == "C"
      ..softwareVersion = parsed.data[3]
      ..specificationVersion = parsed.data[4]
      ..baseApplicationVersion = parsed.data[5]
      ..serialNumber = parsed.data[6];
  }
}

class GetInfo00Factory {
  RequestHandler<void, GetInfo00Response> getInfo(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
