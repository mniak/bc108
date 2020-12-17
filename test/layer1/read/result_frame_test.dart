import 'package:bc108/src/layer1/read/frames.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = StringFrame.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.hasData, isFalse);
      expect(sut.data, isNull);
    });

    test('timeout', () {
      final sut = StringFrame.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.hasData, isFalse);
      expect(sut.data, isNull);
    });

    test('data', () {
      final data = faker.lorem.sentence();

      final sut = StringFrame.data(data);
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.hasData, isTrue);
      expect(sut.data, equals(data));
    });

    test('data null', () {
      expect(() => StringFrame.data(null), throwsArgumentError);
    });
  });
}
