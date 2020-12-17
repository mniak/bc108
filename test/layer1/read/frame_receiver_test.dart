import 'dart:async';

import 'package:bc108/src/layer1/read/frame_receiver.dart';
import 'package:bc108/src/layer1/read/exceptions.dart';
import 'package:bc108/src/layer1/read/reader.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

final ackTimeout = Duration(milliseconds: 50);
final dataTimeout = Duration(milliseconds: 50);

class SUT {
  // ignore: close_sinks
  StreamController<ReaderEvent> controller;
  FrameReceiver receiver;
  SUT() {
    this.controller = StreamController<ReaderEvent>();
    this.receiver = FrameReceiver(
      controller.stream,
    );
  }
}

void main() {
  group('ack', () {
    test('when receive ACK, should return ok', () async {
      final sut = SUT();
      sut.controller.sink.add(ReaderEvent.ack());
      final result = await sut.receiver.receiveAck(ackTimeout);

      expect(result, isNotNull);
      expect(result.timeout, isFalse);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isTrue);
    });

    test('when does not receive anything, should return timeout', () async {
      final sut = SUT();
      final result = await sut.receiver.receiveAck(ackTimeout);

      expect(result, isNotNull);
      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isFalse);
    });

    test('when receive any other error, should throw', () {
      final sut = SUT();
      final error = faker.lorem.sentence();
      sut.controller.sink.addError(error);
      expect(() => sut.receiver.receiveAck(ackTimeout), throwsA(equals(error)));
    });
  });
  group('data', () {
    test('when receive Data, should return data', () async {
      final sut = SUT();
      final data = faker.lorem.sentence();
      sut.controller.sink.add(ReaderEvent.data(data));
      final result = await sut.receiver.receiveData(dataTimeout);

      expect(result, isNotNull);
      expect(result.timeout, isFalse);
      expect(result.tryAgain, isFalse);
      expect(result.hasData, isTrue);
      expect(result.data, equals(data));
    });

    test('when does not receive anything, should return timeout', () async {
      final sut = SUT();
      final result = await sut.receiver.receiveData(dataTimeout);

      expect(result, isNotNull);
      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.hasData, isFalse);
      expect(result.data, isNull);
    });

    group('when receives ACK or NAK, should throw ExpectingDataEventException',
        () {
      test('ACK', () async {
        final sut = SUT();
        sut.controller.sink.add(ReaderEvent.ack());
        expect(() => sut.receiver.receiveData(dataTimeout),
            throwsA(isA<ExpectingDataEventException>()));
      });

      test('NAK', () async {
        final sut = SUT();
        sut.controller.sink.add(ReaderEvent.nak());
        expect(() => sut.receiver.receiveData(dataTimeout),
            throwsA(isA<ExpectingDataEventException>()));
      });
    });

    test('when receive any other error, should throw', () {
      final sut = SUT();
      final error = faker.lorem.sentence();
      sut.controller.sink.addError(error);
      expect(
          () => sut.receiver.receiveData(dataTimeout), throwsA(equals(error)));
    });

    test(
        'when is waiting for ACK and receives ACK, then waiting for data and receives data, then should be ok',
        () async {
      final sut = SUT();

      sut.controller.sink.add(ReaderEvent.ack());
      final ackResult = await sut.receiver.receiveAck(ackTimeout);

      expect(ackResult, isNotNull);
      expect(ackResult.timeout, isFalse);
      expect(ackResult.tryAgain, isFalse);
      expect(ackResult.ok, isTrue);

      final data = faker.lorem.sentence();
      sut.controller.sink.add(ReaderEvent.data(data));
      final dataResult = await sut.receiver.receiveData(dataTimeout);

      expect(dataResult, isNotNull);
      expect(dataResult.timeout, isFalse);
      expect(dataResult.tryAgain, isFalse);
      expect(dataResult.hasData, isTrue);
      expect(dataResult.data, equals(data));
    });

    test('when a call times out, the second should not raise error', () async {
      final sut = SUT();

      final ackResult =
          await sut.receiver.receiveAck(Duration(milliseconds: 20));

      expect(ackResult.timeout, isNotNull);
      expect(ackResult.timeout, isTrue);
      sut.controller.sink.add(ReaderEvent.ack());
      await Future.delayed(Duration(milliseconds: 20));

      final data = faker.lorem.sentence();
      sut.controller.sink.add(ReaderEvent.data(data));
      final dataResult = await sut.receiver.receiveData(dataTimeout);

      expect(dataResult, isNotNull);
      expect(dataResult.timeout, isFalse);
      expect(dataResult.tryAgain, isFalse);
      expect(dataResult.hasData, isTrue);
      expect(dataResult.data, equals(data));
    });
  });
}
