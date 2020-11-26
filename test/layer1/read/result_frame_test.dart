import 'package:bc108/src/layer1/read/result_frame.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = ResultFrame.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.isDataResult, isFalse);
      expect(sut.data, isNull);
    });

    test('timeout', () {
      final sut = ResultFrame.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.isDataResult, isFalse);
      expect(sut.data, isNull);
    });

    test('data', () {
      final data = faker.lorem.sentence();

      final sut = ResultFrame.data(data);
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.isDataResult, isTrue);
      expect(sut.data, equals(data));
    });

    test('data null', () {
      expect(() => ResultFrame.data(null), throwsArgumentError);
    });
  });
}
