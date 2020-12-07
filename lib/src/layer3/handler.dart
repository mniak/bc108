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
      {bool blocking}) async {
    final command = _requestMapper.mapRequest(request);
    final result = await _processor.send(command, blocking: blocking);
    final response = _responseMapper.mapResponse(request, result);
    return PinpadResult(result.status, response);
  }
}

// class RequestHandlerWithSynchronization<TRequest, TResponse>
//     implements RequestHandler<TRequest, TResponse> {
//   Lock _lock;
//   RequestHandler<TRequest, TResponse> _inner;
//   RequestHandlerWithSynchronization(this._lock, this._inner);

//   @override
//   Future<PinpadResult<TResponse>> handle(TRequest request,
//       {bool blocking}) async {
//     PinpadResult<TResponse> result;
//     await _lock.synchronized(() async {
//       result = await _inner.handle(request, blocking: blocking);
//     });
//     return result;
//   }

//   @override
//   Stream<String> get notifications => _inner.notifications;

//   noSuchMethod(Invocation i) => super.noSuchMethod(i);
// }

// extension RequestHandlerExtension on RequestHandler {
//   RequestHandlerWithSynchronization syncA(Lock lock) {
//     return this;
//   }
// }
