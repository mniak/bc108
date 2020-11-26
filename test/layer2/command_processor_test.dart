import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer1/read/ack_frame.dart';
import 'package:bc108/src/layer1/read/result_frame.dart';
import 'package:bc108/src/layer2/command_processor.dart';
import 'package:bc108/src/layer2/command_request.dart';
import 'package:bc108/src/layer2/command_response.dart';
import 'package:bc108/src/layer2/status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
        .thenAnswer((_) => Future.value(AckFrame.tryAgain()));

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
        .thenAnswer((_) => Future.value(AckFrame.timeout()));

    final result = await sut.processor.send(request);

    verify(sut.oper.send(request.payload)).called(1);
    expect(
        result,
        predicate<CommandResponse>(
            (x) => x.code == request.code && x.status == Status.PP_COMMTOUT));

    expectLater(sut.processor.notifications, neverEmits(anything));
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
        .thenAnswer((_) => Future.value(AckFrame.ok()));

    final answers = [
      ResultFrame.data("NTM" + "000" + "321" + message),
      ResultFrame.data(request.code + "000" + "123" + responseData)
    ];

    when(sut.oper.receive())
        .thenAnswer((_) => Future.value(answers.removeAt(0)));

    final result = await sut.processor.send(request);

    verify(sut.oper.send(request.payload)).called(1);
    expect(
        result,
        predicate<CommandResponse>((x) =>
            x.code == request.code &&
            x.status == Status.PP_OK &&
            x.parameters[0] == responseData));

    expectLater(sut.processor.notifications, emits(message));
  });

  test('close should be bypassed', () {
    final sut = SUT();
    sut.processor.close();
    verify(sut.oper.close()).called(1);
    expectLater(sut.processor.notifications, emitsDone);
  });
}
