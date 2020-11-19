import 'package:bc108/src/layer1/read/frame_acknowledgement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructors', () {
    test('try again', () {
      final sut = FrameAcknowledgement.tryAgain();
      expect(sut.tryAgain, isTrue);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isFalse);
    });

    test('timeout', () {
      final sut = FrameAcknowledgement.timeout();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isTrue);
      expect(sut.ok, isFalse);
    });

    test('ok', () {
      final sut = FrameAcknowledgement.ok();
      expect(sut.tryAgain, isFalse);
      expect(sut.timeout, isFalse);
      expect(sut.ok, isTrue);
    });
  });
}
