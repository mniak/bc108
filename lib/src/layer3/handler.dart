import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer2/command_processor.dart';

import 'mapper.dart';
import '../layer1/pinpad_result.dart';

class RequestHandler<TRequest, TResponse> {
  CommandProcessor _operator;
  RequestMapper<TRequest> _requestMapper;
  ResponseMapper<TRequest, TResponse> _responseMapper;

  Stream<String> get notifications => _operator.notifications;

  RequestHandler(this._operator, this._requestMapper, this._responseMapper);
  factory RequestHandler.fromMapper(CommandProcessor oper,
      RequestResponseMapper<TRequest, TResponse> mapper) {
    return RequestHandler(oper, mapper, mapper);
  }

  Future<PinpadResult<TResponse>> handle(TRequest request) async {
    final command = _requestMapper.mapRequest(request);
    final result = await _operator.send(command);
    final response = _responseMapper.mapResponse(request, result);
    return PinpadResult(result.status, response);
  }
}
