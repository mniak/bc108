import 'package:bc108/src/layer1/read/reader.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  group('constructor', () {
    test('ACK', () {
      final sut = ReaderEvent.ack();
      expect(sut.ack, isTrue);
      expect(sut.nak, isFalse);
      expect(sut.badCRC, isFalse);
      expect(sut.aborted, isFalse);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('NAK', () {
      final sut = ReaderEvent.nak();
      expect(sut.ack, isFalse);
      expect(sut.nak, isTrue);
      expect(sut.badCRC, isFalse);
      expect(sut.aborted, isFalse);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('Bad CRC', () {
      final sut = ReaderEvent.badCRC();
      expect(sut.ack, isFalse);
      expect(sut.nak, isFalse);
      expect(sut.badCRC, isTrue);
      expect(sut.aborted, isFalse);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('Aborted', () {
      final sut = ReaderEvent.aborted();
      expect(sut.ack, isFalse);
      expect(sut.nak, isFalse);
      expect(sut.badCRC, isFalse);
      expect(sut.aborted, isTrue);
      expect(sut.isDataEvent, isFalse);
      expect(sut.data, isNull);
    });

    test('Data', () {
      final data = faker.lorem.sentence();

      final sut = ReaderEvent.data(data);
      expect(sut.ack, isFalse);
      expect(sut.nak, isFalse);
      expect(sut.badCRC, isFalse);
      expect(sut.aborted, isFalse);
      expect(sut.isDataEvent, isTrue);
      expect(sut.data, equals(data));
    });

    test('Data null', () {
      expect(() => ReaderEvent.data(null), throwsArgumentError);
    });
  });
}
