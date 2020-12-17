import 'package:bc108/src/layer1/read/frames.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = UnitFrame.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.data, isFalse);
    });

    test('timeout', () {
      final sut = UnitFrame.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.data, isFalse);
    });

    test('ok/data', () {
      final sut = UnitFrame.ok();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.data, isTrue);
    });
  });
}
