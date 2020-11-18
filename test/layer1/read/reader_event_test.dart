import 'package:bc108/src/layer1/read/reader.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructor', () {
    test('ACK', () {
      final sut = ReaderEvent.ack();
      expect(sut.ack, isTrue);
      expect(sut.nak, isFalse);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('NAK', () {
      final sut = ReaderEvent.nak();
      expect(sut.ack, isFalse);
      expect(sut.nak, isTrue);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('data', () {
      final data = faker.lorem.sentence();

      final sut = ReaderEvent.data(data);
      expect(sut.ack, isFalse);
      expect(sut.nak, isFalse);
      expect(sut.isDataEvent, isTrue);
      expect(sut.data, equals(data));
    });

    test('data null', () {
      expect(() => ReaderEvent.data(null), throwsArgumentError);
    });
  });
}
