import 'package:bc108/src/layer2/command_processor.dart';
import 'package:bc108/src/layer2/command_request.dart';
import 'package:bc108/src/layer2/status.dart';
import 'package:bc108/src/layer2/command_response.dart';
import 'package:bc108/src/layer3/handler.dart';
import 'package:bc108/src/layer3/mapper.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class OperatorMock extends Mock implements CommandProcessor {}

class MapperMock<TRequest, TResponse> extends Mock
    implements RequestResponseMapper<TRequest, TResponse> {}

class SUT<TRequest, TResponse> {
  CommandProcessor oper;
  RequestHandler<TRequest, TResponse> handler;
  RequestResponseMapper<TRequest, TResponse> mapper;
  SUT() {
    oper = OperatorMock();
    mapper = MapperMock<TRequest, TResponse>();
    handler = RequestHandler(oper, mapper, mapper);
  }
}

void main() {
  test('happy scenario', () async {
    final sut = SUT<String, String>();
    final request = faker.lorem.sentence();
    final response = faker.lorem.sentence();

    final code =
        faker.lorem.word().padRight(3, ' ').substring(0, 3).toUpperCase();
    final status = faker.randomGenerator.integer(999).toStatus();
    final cmd = CommandRequest(code, [faker.lorem.sentence()]);
    final cmdResult = CommandResponse.fromStatus(status);

    when(sut.mapper.mapRequest(request)).thenReturn(cmd);
    when(sut.oper.send(cmd)).thenAnswer((_) => Future.value(cmdResult));
    when(sut.mapper.mapResponse(request, cmdResult)).thenReturn(response);

    final result = await sut.handler.handle(request);
    expect(result.status, equals(status));
    expect(result.data, equals(response));
  });
}
