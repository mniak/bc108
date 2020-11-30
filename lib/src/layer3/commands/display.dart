import 'package:bc108/src/layer2/exports.dart';

import '../fields/alphanumeric.dart';
import '../fields/composite.dart';
import '../mapper.dart';
import '../handler.dart';

class DisplayRequest {
  String line1;
  String line2;
  DisplayRequest([this.line1, this.line2]);
}

class Mapper implements RequestResponseMapper<DisplayRequest, void> {
  static final _requestField = CompositeField([
    AlphanumericField(16),
    AlphanumericField(16),
  ]);

  @override
  CommandRequest mapRequest(DisplayRequest request) {
    return CommandRequest("DSP", [
      _requestField.serialize([
        request.line1 ?? "",
        request.line2 ?? "",
      ])
    ]);
  }

  @override
  void mapResponse(CommandResponse result) {}
}

class DisplayFactory {
  RequestHandler<DisplayRequest, void> display(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
