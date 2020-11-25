import 'package:bc108/src/layer2/operator.dart';
import 'package:bc108/src/layer2/read/command_result.dart';
import 'package:bc108/src/layer2/read/command_result_receiver.dart';
import 'package:bc108/src/layer2/write/command.dart';
import 'package:bc108/src/layer2/write/command_sender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class CommandReceiverMock extends Mock implements CommandResultReceiver {}

class CommandSenderMock extends Mock implements CommandSender {}

class CommandResultMock extends Mock implements CommandResult {}

class SUT {
  CommandResultReceiver receiver;
  CommandSender sender;
  Operator oper;

  SUT() {
    receiver = CommandReceiverMock();
    sender = CommandSenderMock();
    oper = Operator(receiver, sender);
  }
}

void main() {
  test('happy scenario', () async {
    final sut = SUT();
    final command = Command('CMD', []);
    final commandResult = CommandResultMock();

    when(sut.receiver.receiveAcknowledgementAndData()).thenAnswer((_) => Future<CommandResult>.value(commandResult));

    final result = await sut.oper.executeNonBlocking(command);

    verify(sut.sender.send(command)).called(1);
    expect(result, equals(commandResult));
  });

  test('close should be bypassed', () {
    final sut = SUT();
    sut.oper.close();
    verify(sut.sender.close()).called(1);
  });
}
