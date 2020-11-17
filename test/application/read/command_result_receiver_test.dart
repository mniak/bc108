import 'dart:async';

import 'package:bc108/application/read/command_result_receiver.dart';
import 'package:bc108/application/read/command_result_receiver_exceptions.dart';
import 'package:bc108/application/statuses.dart';
import 'package:bc108/datalink/read/frame_receiver.dart';
import 'package:bc108/datalink/read/frame_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FrameReceiverMock extends Mock implements FrameReceiver {}

class SUT {
  FrameReceiver frameReceiver;
  CommandReceiver commandReceiver;
  SUT() {
    frameReceiver = FrameReceiverMock();
    commandReceiver = CommandReceiver(frameReceiver);
  }
}

void main() {
  test('when there is data, should return parsed command', () async {
    final sut = SUT();
    when(sut.frameReceiver.receiveNonBlocking())
        .thenAnswer((_) => Future.value(FrameResult.data("CMD004")));

    final result = await sut.commandReceiver.receive();

    expect(result.code, equals("CMD"));
    expect(result.status, equals(Status.PP_F1));
  });

  test('when tryAgain, should raise abort error', () async {
    final sut = SUT();
    when(sut.frameReceiver.receiveNonBlocking())
        .thenAnswer((_) => Future.value(FrameResult.tryAgain()));

    expect(() => sut.commandReceiver.receive(),
        throwsA(isInstanceOf<CommandAbortedException>()));
  });

  test('when timeout, should raise timeout error', () async {
    final sut = SUT();
    when(sut.frameReceiver.receiveNonBlocking())
        .thenAnswer((_) => Future.value(FrameResult.timeout()));

    expect(() => sut.commandReceiver.receive(),
        throwsA(isInstanceOf<TimeoutException>()));
  });
}
