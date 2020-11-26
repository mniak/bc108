import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer1/read/ack_frame.dart';
import 'package:bc108/src/layer1/read/frame_receiver.dart';
import 'package:bc108/src/layer1/read/result_frame.dart';
import 'package:bc108/src/layer1/write/frame_sender.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FrameReceiverMock extends Mock implements FrameReceiver {}

class FrameSenderMock extends Mock implements FrameSender {}

class SUT {
  FrameReceiver receiver;
  FrameSender sender;
  Operator oper;
  SUT() {
    receiver = FrameReceiverMock();
    sender = FrameSenderMock();
    oper = Operator(receiver, sender);
  }
}

void main() {
  group('send', () {
    test('when receive timeout, should not be retried', () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      when(sut.receiver.receiveAck())
          .thenAnswer((_) => Future.value(AckFrame.timeout()));

      final result = await sut.oper.send(frame);

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isFalse);

      verify(sut.receiver.receiveAck()).called(1);
    });

    test('when receive ok, should not be retried', () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      when(sut.receiver.receiveAck())
          .thenAnswer((_) => Future.value(AckFrame.ok()));

      final result = await sut.oper.send(frame);

      expect(result.timeout, isFalse);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isTrue);

      verify(sut.receiver.receiveAck()).called(1);
    });

    test('when receive try again, should retry 2 more times', () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      when(sut.receiver.receiveAck())
          .thenAnswer((_) => Future.value(AckFrame.tryAgain()));
      final result = await sut.oper.send(frame);

      expect(result, isNotNull);
      expect(result.timeout, isFalse);
      expect(result.tryAgain, isTrue);
      expect(result.ok, isFalse);

      verify(sut.receiver.receiveAck()).called(3);
    });

    test(
        'when receive try again and the first retry returns is timeout, should return timeout',
        () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      var answers = [
        AckFrame.tryAgain(),
        AckFrame.timeout(),
      ];
      when(sut.receiver.receiveAck())
          .thenAnswer((_) => Future.value(answers.removeAt(0)));

      final result = await sut.oper.send(frame);

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isFalse);

      verify(sut.receiver.receiveAck()).called(2);
    });

    test(
        'when receive try again and the second retry returns is timeout, should return timeout',
        () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      var answers = [
        AckFrame.tryAgain(),
        AckFrame.tryAgain(),
        AckFrame.timeout(),
      ];
      when(sut.receiver.receiveAck())
          .thenAnswer((_) => Future.value(answers.removeAt(0)));

      final result = await sut.oper.send(frame);

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.ok, isFalse);

      verify(sut.receiver.receiveAck()).called(3);
    });
  });

  group('receive', () {
    test('when receive timeout, should not be retried', () async {
      final sut = SUT();
      final frame = faker.lorem.sentence();

      when(sut.receiver.receive())
          .thenAnswer((_) => Future.value(ResultFrame.timeout()));

      final result = await sut.oper.receive();

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.receiver.receive()).called(1);
    });

    test('when receive data, should not be retried', () async {
      final sut = SUT();
      final data = faker.lorem.sentence();

      when(sut.receiver.receive())
          .thenAnswer((_) => Future.value(ResultFrame.data(data)));

      final result = await sut.oper.receive();

      expect(result.timeout, isFalse);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isTrue);
      expect(result.data, equals(data));

      verify(sut.receiver.receive()).called(1);
    });

    test('when receive try again, should not be retried', () async {
      final sut = SUT();

      when(sut.receiver.receive())
          .thenAnswer((_) => Future.value(ResultFrame.tryAgain()));
      final result = await sut.oper.receive();

      expect(result, isNotNull);
      expect(result.timeout, isFalse);
      expect(result.tryAgain, isTrue);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.receiver.receive()).called(1);
    });
  });
}
