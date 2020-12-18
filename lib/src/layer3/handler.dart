import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer2/command_processor.dart';
// import 'package:synchronized/synchronized.dart';

import 'mapper.dart';
import '../layer1/pinpad_result.dart';

class RequestHandler<TRequest, TResponse> {
  CommandProcessor _processor;
  RequestMapper<TRequest> _requestMapper;
  ResponseMapper<TRequest, TResponse> _responseMapper;

  Stream<String> get notifications => _processor.notifications;

  RequestHandler(this._processor, this._requestMapper, this._responseMapper);
  factory RequestHandler.fromMapper(CommandProcessor oper,
      RequestResponseMapper<TRequest, TResponse> mapper) {
    return RequestHandler(oper, mapper, mapper);
  }

  Future<PinpadResult<TResponse>> handle(TRequest request,
      {bool blocking = false}) async {
    final command = _requestMapper.mapRequest(request);
    final result = await _processor.send(command, blocking: blocking);
    final response = _responseMapper.mapResponse(request, result);
    return PinpadResult(result.status, response);
  }
}
