import 'dart:async';

import 'package:bc108/src/layer2/read/command_result_receiver.dart';
import 'package:bc108/src/layer2/status.dart';
import 'package:bc108/src/layer1/read/frame_receiver.dart';
import 'package:bc108/src/layer1/read/frame_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FrameReceiverMock extends Mock implements FrameReceiver {}

class SUT {
  FrameReceiver frameReceiver;
  CommandResultReceiver commandReceiver;
  SUT() {
    frameReceiver = FrameReceiverMock();
    commandReceiver = CommandResultReceiver(frameReceiver);
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

  test('when tryAgain, should return status Communication Error', () async {
    final sut = SUT();
    when(sut.frameReceiver.receiveNonBlocking())
        .thenAnswer((_) => Future.value(FrameResult.tryAgain()));

    final result = await sut.commandReceiver.receive();

    expect(result.code, equals("ERR"));
    expect(result.status, equals(Status.PP_COMMERR));
  });

  test('when timeout, should return status Timeout', () async {
    final sut = SUT();
    when(sut.frameReceiver.receiveNonBlocking())
        .thenAnswer((_) => Future.value(FrameResult.timeout()));

    final result = await sut.commandReceiver.receive();

    expect(result.code, equals("ERR"));
    expect(result.status, equals(Status.PP_COMMTOUT));
  });
}
