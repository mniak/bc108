import 'package:bc108/datalink/read/frame_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = FrameResult.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.isDataResult, isFalse);
      expect(sut.data, isNull);
    });

    test('timeout', () {
      final sut = FrameResult.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.isDataResult, isFalse);
      expect(sut.data, isNull);
    });

    test('data', () {
      final data = faker.lorem.sentence();

      final sut = FrameResult.data(data);
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.isDataResult, isTrue);
      expect(sut.data, equals(data));
    });

    test('data null', () {
      expect(() => FrameResult.data(null), throwsArgumentError);
    });
  });
}
