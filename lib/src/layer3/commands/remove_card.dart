import 'package:bc108/src/layer2/command_response.dart';

import 'package:bc108/src/layer2/command_request.dart';

import '../../../bc108.dart';
import '../fields/alphanumeric.dart';
import '../fields/composite.dart';
import '../handler.dart';
import '../mapper.dart';

class RemoveCardRequest {
  String line1;
  String line2;
  RemoveCardRequest([this.line1, this.line2]);
}

class Mapper implements RequestResponseMapper<RemoveCardRequest, void> {
  static final _requestField = new CompositeField([
    AlphanumericField(16),
    AlphanumericField(16),
  ]);

  @override
  CommandRequest mapRequest(RemoveCardRequest request) {
    return CommandRequest("RMC", [
      _requestField.serialize([
        request.line1,
        request.line2,
      ])
    ]);
  }

  @override
  void mapResponse(RemoveCardRequest request, CommandResponse result) {}
}

class RemoveCardFactory {
  RequestHandler<RemoveCardRequest, void> removeCard(CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
