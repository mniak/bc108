import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:bc108/src/layer3/fields/composite.dart';

import '../handler.dart';
import '../mapper.dart';

class CloseRequest {
  String idleMessageLine1;
  String idleMessageLine2;
  CloseRequest(this.idleMessageLine1, this.idleMessageLine2);
}

class Mapper extends RequestResponseMapper<CloseRequest, void> {
  static final _requestField = CompositeField([
    AlphanumericField(16),
    AlphanumericField(16),
  ]);

  @override
  Command mapRequest(CloseRequest request) {
    return Command("CLO", [
      _requestField.serialize([
        request.idleMessageLine1,
        request.idleMessageLine2,
      ])
    ]);
  }

  @override
  void mapResponse(CommandResult result) {}
}

class CloseFactory {
  RequestHandler<CloseRequest, void> close(Operator o) =>
      RequestHandler.fromMapper(o, Mapper());
}
