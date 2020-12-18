import 'dart:async';

import 'package:bc108/src/layer1/utils/bytes.dart';
import 'package:bc108/src/layer1/write/frame_builder.dart';
import 'package:bc108/src/layer1/write/frame_sender.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class FrameBuilderMock extends Mock implements FrameBuilder {}

class SUT {
  // ignore: close_sinks
  StreamController<int> controller;
  FrameBuilder frameBuilder;
  FrameSender sender;

  SUT() {
    controller = StreamController<int>();
    frameBuilder = FrameBuilderMock();
    sender = FrameSender(controller.sink, frameBuilder: frameBuilder);
  }
}

void main() {
  test('send should build the frame and add to the sink', () {
    final sut = SUT();

    final payload = faker.lorem.sentence();
    final data = faker.randomGenerator.numbers(255, 15);
    when(sut.frameBuilder.build(payload)).thenReturn(data);

    sut.sender.send(payload);

    expectLater(
        sut.controller.stream,
        emitsInOrder(
          data.map((x) => equals(x)),
        ));
  });

  test('abort should add byte CAN (0x18) to the sink', () {
    final sut = SUT();

    sut.sender.abort();

    expectLater(sut.controller.stream, emits(equals(Byte.EOT.toInt())));
  });

  test('done event should be bypassed', () {
    final sut = SUT();
    sut.sender.close();
    expectLater(sut.controller.stream, emitsDone);
  });
}
