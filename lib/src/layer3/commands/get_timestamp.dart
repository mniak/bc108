import 'package:bc108/src/layer2/exports.dart';

import '../fields/numeric.dart';
import '../handler.dart';
import '../mapper.dart';

class GetTimestampRequest {
  int acquirer;
}

class GetTimestampResponse {
  int timestamp;
}

class Mapper extends RequestResponseMapper<void, GetTimestampResponse> {
  static final _requestField = NumericField(2);

  static final _responseField = NumericField(10);

  @override
  Command mapRequest(void request) {
    return Command("GTS", [_requestField.serialize(0)]);
  }

  @override
  GetTimestampResponse mapResponse(CommandResult result) {
    final parsed = _responseField.parse(result.parameters[0]);
    return GetTimestampResponse()..timestamp = parsed.data;
  }
}

class GetTimestampFactory {
  RequestHandler<void, GetTimestampResponse> getTimestamp(Operator o) =>
      RequestHandler.fromMapper(o, Mapper());
}
