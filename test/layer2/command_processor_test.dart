import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer1/read/exceptions.dart';
import 'package:bc108/src/layer1/read/frames.dart';
import 'package:bc108/src/layer2/command_processor.dart';
import 'package:bc108/src/layer2/command_request.dart';
import 'package:bc108/src/layer2/command_response.dart';
import 'package:bc108/src/layer2/status.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class OperatorMock extends Mock implements Operator {}

class CommandResponseMock extends Mock implements CommandResponse {}

class SUT {
  Operator oper;
  CommandProcessor processor;

  SUT() {
    oper = OperatorMock();
    processor = CommandProcessor(oper);
  }
}

void main() {
  test('when send returns tryAgain, should return status COMMERR', () async {
    final sut = SUT();
    final request = CommandRequest('CMD', []);

    when(sut.oper.send(request.payload))
        .thenAnswer((_) => Future.value(UnitFrame.tryAgain()));

    final result = await sut.processor.send(request);

    verify(sut.oper.send(request.payload)).called(1);
    expect(result,
        predicate<CommandResponse>((x) => x.status == Status.PP_COMMERR));
    expectLater(sut.processor.notifications, neverEmits(anything));
    sut.processor.close();
  });

  test('when send returns timeout, should return status COMMTOUT', () async {
    final sut = SUT();
    final request = CommandRequest('CMD', []);

    when(sut.oper.send(request.payload))
        .thenAnswer((_) => Future.value(UnitFrame.timeout()));

    expectLater(sut.processor.notifications, neverEmits(anything));

    final result = await sut.processor.send(request);

    verify(sut.oper.send(request.payload)).called(1);
    expect(
        result,
        predicate<CommandResponse>(
            (x) => x.code == request.code && x.status == Status.PP_COMMTOUT));

    sut.processor.close();
  });

  test(
      'when send returns ok, receive returns notification and then data, should raise notification and return data',
      () async {
    final sut = SUT();
    final request = CommandRequest('CMD', []);
    final responseData = 'X' * 123;
    final message = 'Y' * 321;

    when(sut.oper.send(request.payload))
        .thenAnswer((_) => Future.value(UnitFrame.ok()));

    final answers = [
      StringFrame.data("NTM" + "000" + "321" + message),
      StringFrame.data(request.code + "000" + "123" + responseData)
    ];

    when(sut.oper.receive())
        .thenAnswer((_) => Future.value(answers.removeAt(0)));

    expectLater(sut.processor.notifications, emits(message));

    final result = await sut.processor.send(request);

    verify(sut.oper.send(request.payload)).called(1);
    expect(result.code, equals(request.code));
    expect(result.status, equals(Status.PP_OK));
    expect(result.parameters[0], equals(responseData));
  });

  test('close should be bypassed', () {
    final sut = SUT();
    sut.processor.close();
    verify(sut.oper.close()).called(1);
    expectLater(sut.processor.notifications, emitsDone);
  });

  test('abort should be bypassed', () {
    final sut = SUT();
    sut.processor.abort();
    verify(sut.oper.abort()).called(1);
  });

  test('notification stream should allow many listeners', () {
    final sut = SUT();
    sut.processor.notifications.listen((event) {});
    sut.processor.notifications.listen((event) {});
  });

  test(
      'when calling blocking command and abort event received, should return PP_ABORT',
      () async {
    final sut = SUT();
    final request = CommandRequest('CMD', []);

    when(sut.oper.send(request.payload))
        .thenAnswer((_) => Future.value(UnitFrame.ok()));

    when(sut.oper.receive(blocking: true)).thenThrow(AbortedException());
    final result = await sut.processor.send(request, blocking: true);

    verify(sut.oper.send(request.payload)).called(1);
    expect(result.code, equals(request.code));
    expect(result.status, equals(Status.PP_CANCEL));
    expect(result.parameters, isEmpty);
  });
}
