import 'package:bc108/application/operator.dart';
import 'package:bc108/application/read/command_result.dart';
import 'package:bc108/application/read/command_result_receiver.dart';
import 'package:bc108/application/write/command.dart';
import 'package:bc108/application/write/command_sender.dart';
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

    when(sut.receiver.receive())
        .thenAnswer((_) => Future<CommandResult>.value(commandResult));

    final result = await sut.oper.execute(command);

    verify(sut.sender.send(command));
    expect(result, equals(commandResult));
  });
}
