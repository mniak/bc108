import 'package:bc108/application/write/command.dart';
import 'package:bc108/application/write/command_sender.dart';
import 'package:bc108/datalink/write/frame_sender.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class CommandMock extends Mock implements Command {}

class FrameSenderMock extends Mock implements FrameSender {}

class SUT {
  CommandSender commandSender;
  FrameSender frameSender;

  SUT() {
    frameSender = FrameSenderMock();
    commandSender = CommandSender(frameSender);
  }
}

void main() {
  test('happy scenario', () {
    final sut = SUT();
    final payload = faker.lorem.sentence();

    final command = CommandMock();
    when(command.payload).thenReturn(payload);

    sut.commandSender.send(command);

    verify(sut.frameSender.send(payload));
  });

  test('done event should be bypassed', () {
    final sut = SUT();
    sut.commandSender.close();
    verify(sut.frameSender.close());
  });
}
