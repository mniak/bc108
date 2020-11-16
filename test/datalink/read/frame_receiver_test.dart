import 'dart:async';

import 'package:bc108/datalink/read/frame_receiver.dart';
import 'package:bc108/datalink/read/frame_receiver_exceptions.dart';
import 'package:bc108/datalink/read/reader.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

class SUT {
  StreamController<ReaderEvent> controller;
  FrameReceiver receiver;
  SUT() {
    this.controller = new StreamController<ReaderEvent>();
    this.receiver = FrameReceiver(
      controller.stream,
      ackTimeout: Duration(milliseconds: 500),
      responseTimeout: Duration(milliseconds: 500),
    );
  }
}

void main() {
  test('when receive ACK then Data, should return data', () async {
    final sut = SUT();
    final data = faker.lorem.sentence();
    sut.controller.sink.add(ReaderEvent.ack());
    sut.controller.sink.add(ReaderEvent.data(data));
    final result = await sut.receiver.receive();

    expect(result, isNotNull);
    expect(result.timeout, isFalse);
    expect(result.tryAgain, isFalse);
    expect(result.isDataResult, isTrue);
    expect(result.data, equals(data));
  });

  test('when receive NAK then Data, should return try again', () async {
    final sut = SUT();
    sut.controller.sink.add(ReaderEvent.nak());
    final result = await sut.receiver.receive();

    expect(result, isNotNull);
    expect(result.timeout, isFalse);
    expect(result.tryAgain, isTrue);
    expect(result.isDataResult, isFalse);
    expect(result.data, isNull);
  });

  test('when does not receive anything, should return timeout', () async {
    final sut = SUT();
    final result = await sut.receiver.receive();

    expect(result, isNotNull);
    expect(result.timeout, isTrue);
    expect(result.tryAgain, isFalse);
    expect(result.isDataResult, isFalse);
    expect(result.data, isNull);
  });

  test(
      'when receive ACK but does not receive anything else, should return timeout',
      () async {
    final sut = SUT();
    sut.controller.sink.add(ReaderEvent.ack());
    final result = await sut.receiver.receive();

    expect(result, isNotNull);
    expect(result.timeout, isTrue);
    expect(result.tryAgain, isFalse);
    expect(result.isDataResult, isFalse);
    expect(result.data, isNull);
  });

  test('when receive event before ACK, should throw ExpectingAckOrNakException',
      () async {
    final sut = SUT();
    final data = faker.lorem.sentence();
    sut.controller.sink.add(ReaderEvent.data(data));
    expect(() => sut.receiver.receive(),
        throwsA(isInstanceOf<ExpectingAckOrNakException>()));
  });

  group(
      'when receive ACK then receives ACK or NAK, should throw ExpectingAckOrNakException',
      () {
    test('ACK', () async {
      final sut = SUT();
      sut.controller.sink.add(ReaderEvent.ack());
      sut.controller.sink.add(ReaderEvent.ack());
      expect(() => sut.receiver.receive(),
          throwsA(isInstanceOf<ExpectingDataEventException>()));
    });

    test('NAK', () async {
      final sut = SUT();
      sut.controller.sink.add(ReaderEvent.ack());
      sut.controller.sink.add(ReaderEvent.nak());
      expect(() => sut.receiver.receive(),
          throwsA(isInstanceOf<ExpectingDataEventException>()));
    });
  });

  test('when receive any other error, should throw', () {
    final sut = SUT();
    final error = faker.lorem.sentence();
    sut.controller.sink.addError(error);
    expect(() => sut.receiver.receive(), throwsA(equals(error)));
  });
}
