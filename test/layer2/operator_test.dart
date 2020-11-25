import 'package:bc108/src/layer1/operator_L1.dart';
import 'package:bc108/src/layer2/operator.dart';
import 'package:bc108/src/layer2/read/command_result.dart';
import 'package:bc108/src/layer2/write/command.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class OperatorL1Mock extends Mock implements OperatorL1 {}

class CommandResultMock extends Mock implements CommandResult {}

class SUT {
  OperatorL1 operL1;
  Operator oper;

  SUT() {
    operL1 = OperatorL1Mock();
    oper = Operator(operL1);
  }
}

void main() {
  // test('happy scenario', () async {
  //   final sut = SUT();
  //   final command = Command('CMD', []);
  //   final commandResult = CommandResultMock();

  //   when(sut.operL1.receiveAcknowledgementAndData())
  //       .thenAnswer((_) => Future<CommandResult>.value(commandResult));

  //   final result = await sut.oper.sendNonBlocking(command);

  //   verify(sut.operL1.send(command.payload)).called(1);
  //   expect(result, equals(commandResult));
  // });

  test('close should be bypassed', () {
    final sut = SUT();
    sut.oper.close();
    verify(sut.operL1.close()).called(1);
  });
}
