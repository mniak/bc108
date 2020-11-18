import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/read/frame_receiver_with_retry.dart';
import 'package:bc108/src/layer1/read/frame_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FrameReceiverMock extends Mock implements FrameReceiver {}

class SUT {
  FrameReceiver receiver, inner;
  SUT() {
    inner = FrameReceiverMock();
    receiver = FrameReceiverWithRetry(inner);
  }
}

void main() {
  group('frame receiver with retry decorator', () {
    test('when timeout, should not be retried', () async {
      final sut = SUT();

      when(sut.inner.receiveNonBlocking())
          .thenAnswer((_) => Future.value(FrameResult.timeout()));

      final result = await sut.receiver.receiveNonBlocking();

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.inner.receiveNonBlocking()).called(1);
    });

    test('when data result, should not be retried', () async {
      final sut = SUT();
      final data = faker.lorem.sentence();

      when(sut.inner.receiveNonBlocking())
          .thenAnswer((_) => Future.value(FrameResult.data(data)));

      final result = await sut.receiver.receiveNonBlocking();

      expect(result.timeout, isFalse);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isTrue);
      expect(result.data, equals(data));

      verify(sut.inner.receiveNonBlocking()).called(1);
    });

    test('when try-again, should retry 2 more times', () async {
      final sut = SUT();

      when(sut.inner.receiveNonBlocking())
          .thenAnswer((_) => Future.value(FrameResult.tryAgain()));

      final result = await sut.receiver.receiveNonBlocking();

      expect(result.timeout, isFalse);
      expect(result.tryAgain, isTrue);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.inner.receiveNonBlocking()).called(3);
    });

    test(
        'when try-again and the first retry returns is timeout, should return timeout',
        () async {
      final sut = SUT();

      var answers = [
        FrameResult.tryAgain(),
        FrameResult.timeout(),
      ];
      when(sut.inner.receiveNonBlocking())
          .thenAnswer((_) => Future.value(answers.removeAt(0)));

      final result = await sut.receiver.receiveNonBlocking();

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.inner.receiveNonBlocking()).called(2);
    });

    test(
        'when try-again and the second retry returns is timeout, should return timeout',
        () async {
      final sut = SUT();

      var answers = [
        FrameResult.tryAgain(),
        FrameResult.tryAgain(),
        FrameResult.timeout(),
      ];
      when(sut.inner.receiveNonBlocking())
          .thenAnswer((_) => Future.value(answers.removeAt(0)));

      final result = await sut.receiver.receiveNonBlocking();

      expect(result.timeout, isTrue);
      expect(result.tryAgain, isFalse);
      expect(result.isDataResult, isFalse);
      expect(result.data, isNull);

      verify(sut.inner.receiveNonBlocking()).called(3);
    });
  });
}
