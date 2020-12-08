import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/fields/tlv.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

void main() {
  test('parse', () {
    var sut = TlvField(["A1", "A2"]);

    var result = sut.parse("A1021234A2039876540000");
    var resultDataMapStringString =
        result.data.map((key, value) => MapEntry(key, value.hex));

    expect(
        resultDataMapStringString,
        equals({
          "A1": "1234",
          "A2": "987654",
        }));
    expect(result.remaining, equals("0000"));
    expect(result.data.raw, equals("A1021234A203987654"));
  });

  group('TlvMap', () {
    test('equality test', () {
      final key = faker.lorem.word();
      final raw = faker.lorem.sentence();
      final bytes = faker.randomGenerator.numbers(255, 100);

      final a = TlvMap({
        key: BinaryData.fromBytes(bytes),
      }, raw);
      final b = TlvMap({
        key: BinaryData.fromBytes(bytes),
      }, raw);

      expect(a, equals(b));
      expect(b, equals(a));
      expect(a.hashCode, equals(b.hashCode));
      expect(b.hashCode, equals(a.hashCode));
    });

    test('not equality test with different data but same raw', () {
      final key = faker.lorem.word();
      final raw = faker.lorem.sentence();
      final bytesA = faker.randomGenerator.numbers(255, 100);
      final bytesB = faker.randomGenerator.numbers(255, 100);

      final a = TlvMap({
        key: BinaryData.fromBytes(bytesA),
      }, raw);
      final b = TlvMap({
        key: BinaryData.fromBytes(bytesB),
      }, raw);

      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(a)));
    });

    test('not equality test with same data but different raw', () {
      final key = faker.lorem.word();
      final rawA = faker.lorem.sentence();
      final rawB = faker.lorem.sentence();
      final bytes = faker.randomGenerator.numbers(255, 100);

      final a = TlvMap({
        key: BinaryData.fromBytes(bytes),
      }, rawA);
      final b = TlvMap({
        key: BinaryData.fromBytes(bytes),
      }, rawB);

      expect(a != b, isTrue, reason: "A should be different of B");
      expect(b != a, isTrue, reason: "B should be different of A");
    });
  });
}
