import 'package:bc108/src/layer1/write/frame_sender.dart';
import 'package:bc108/src/layer2/write/command.dart';
import 'package:bc108/src/layer2/write/command_sender.dart';
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

    verify(sut.frameSender.send(payload)).called(1);
  });

  test('done event should be bypassed', () {
    final sut = SUT();
    sut.commandSender.close();
    verify(sut.frameSender.close()).called(1);
  });
}
