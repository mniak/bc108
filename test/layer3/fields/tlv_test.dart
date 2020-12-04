import 'package:bc108/src/layer3/fields/tlv.dart';
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
}
