import 'package:bc108/src/layer1/read/ack_frame.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = AckFrame.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isFalse);
    });

    test('timeout', () {
      final sut = AckFrame.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.ok, isFalse);
    });

    test('ok', () {
      final sut = AckFrame.ok();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isTrue);
    });
  });
}
