import 'package:bc108/src/layer2/exports.dart';

import '../fields/numeric.dart';
import '../handler.dart';
import '../mapper.dart';

class GetTimestampRequest {
  int acquirer;
  GetTimestampRequest([this.acquirer]);
}

class GetTimestampResponse {
  int timestamp;
}

class Mapper
    extends RequestResponseMapper<GetTimestampRequest, GetTimestampResponse> {
  static final _requestField = NumericField(2);

  static final _responseField = NumericField(10);

  @override
  Command mapRequest(GetTimestampRequest request) {
    return Command("GTS", [_requestField.serialize(request.acquirer)]);
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