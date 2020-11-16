import 'dart:async';

import 'package:bc108/datalink/write/frame_builder.dart';
import 'package:bc108/datalink/write/frame_sender.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
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
  Stream<Iterable<int>> get stream =>
      controller.stream.bufferTime(Duration(milliseconds: 100));
}

void main() {
  test('happy scenario', () {
    final sut = SUT();

    final payload = faker.lorem.sentence();
    final data = faker.randomGenerator.numbers(255, 15);
    when(sut.frameBuilder.build(payload)).thenReturn(data);

    sut.sender.send(payload);

    expectLater(sut.stream, emits(equals(data)));
  });

  test('done event should be bypassed', () {
    final sut = SUT();
    sut.controller.close();
    expectLater(sut.stream, emitsDone);
  });
}
