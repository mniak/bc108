import 'package:bc108/src/layer2/exports.dart';

abstract class RequestMapper<T> {
  Command mapRequest(T request);
}

abstract class ResponseMapper<T> {
  T mapResponse(CommandResult result);
}

abstract class RequestResponseMapper<TRequest, TResponse>
    implements RequestMapper<TRequest>, ResponseMapper<TResponse> {}
