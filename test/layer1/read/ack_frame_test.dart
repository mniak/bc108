import 'package:bc108/src/layer1/read/frames.dart';
import 'package:test/test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = UnitFrame.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isFalse);
    });

    test('timeout', () {
      final sut = UnitFrame.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.ok, isFalse);
    });

    test('ok', () {
      final sut = UnitFrame.ok();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isTrue);
    });
  });
}
