import '../layer2/operator.dart';
import 'pinpad_result.dart';
import 'mapper.dart';

class RequestHandler<TRequest, TResponse> {
  Operator _operator;
  RequestMapper<TRequest> _requestMapper;
  ResponseMapper<TResponse> _responseMapper;

  RequestHandler(this._operator, this._requestMapper, this._responseMapper);
  RequestHandler.fromMapper(
      Operator oper, RequestResponseMapper<TRequest, TResponse> mapper)
      : this(oper, mapper, mapper);

  Future<PinpadResult<TResponse>> handle(TRequest request) async {
    final command = _requestMapper.mapRequest(request);
    final commandResult = await _operator.execute(command);
    final response = _responseMapper.mapResponse(commandResult);
    return PinpadResult(commandResult.status, response);
  }
}
