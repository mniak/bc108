import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer2/command_processor.dart';
import 'package:bc108/src/layer2/command_request.dart';
import 'package:bc108/src/layer2/command_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class OperatorMock extends Mock implements Operator {}

class CommandResponseMock extends Mock implements CommandResponse {}

class SUT {
  Operator operL1;
  CommandProcessor oper;

  SUT() {
    operL1 = OperatorMock();
    oper = CommandProcessor(operL1);
  }
}

void main() {
  // test('happy scenario', () async {
  //   final sut = SUT();
  //   final command = CommandRequest('CMD', []);
  //   final CommandResponse = CommandResponseMock();

  //   when(sut.operL1.receiveAcknowledgementAndData())
  //       .thenAnswer((_) => Future<CommandResponse>.value(CommandResponse));

  //   final result = await sut.oper.send(command);

  //   verify(sut.operL1.send(command.payload)).called(1);
  //   expect(result, equals(CommandResponse));
  // });

  test('close should be bypassed', () {
    final sut = SUT();
    sut.oper.close();
    verify(sut.operL1.close()).called(1);
  });
}
