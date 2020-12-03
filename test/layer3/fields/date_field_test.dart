import 'package:bc108/src/layer3/fields/date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('happy scenario', () {
    final data = [
      [DateTime(2001, 1, 1), "010101"],
      [DateTime(2000, 1, 2), "000102"],
      [DateTime(2015, 12, 3), "151203"],
    ];
    data.forEach((d) {
      final date = d[0] as DateTime;
      final string = d[1] as String;

      test('serialize', () {
        final sut = DateField();

        final result = sut.serialize(date);
        expect(result, string);
      });

      test('parse', () {
        final sut = DateField();

        final result = sut.parse(string);
        expect(result.data, date);
      });
    });
  });
}
