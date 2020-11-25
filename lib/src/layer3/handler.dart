import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer2/operator.dart';

import 'mapper.dart';
import 'pinpad_result.dart';

class RequestHandler<TRequest, TResponse> {
  Operator _operator;
  RequestMapper<TRequest> _requestMapper;
  ResponseMapper<TResponse> _responseMapper;

  Stream<String> get notifications => _operator.notifications;

  RequestHandler(this._operator, this._requestMapper, this._responseMapper);
  factory RequestHandler.fromMapper(
      Operator oper, RequestResponseMapper<TRequest, TResponse> mapper) {
    return RequestHandler(oper, mapper, mapper);
  }

  Future<PinpadResult<TResponse>> handle(TRequest request) async {
    final command = _requestMapper.mapRequest(request);
    final result = await _operator.send(command);
    final response = _responseMapper.mapResponse(result);
    return PinpadResult(result.status, response);
  }
}
