import 'package:bc108/src/layer3/fields/date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('happy scenario', () {
    final data = [
      [DateTime(2001, 1, 1, 1, 1, 1), "010101010101"],
      [DateTime(2000, 1, 2, 3, 4, 5), "000102030405"],
      [DateTime(2015, 12, 3, 19, 59, 44), "151203195944"],
    ];
    data.forEach((d) {
      final date = d[0] as DateTime;
      final string = d[1] as String;

      test('serialize', () {
        final sut = DateTimeField();

        final result = sut.serialize(date);
        expect(result, string);
      });

      test('parse', () {
        final sut = DateTimeField();

        final result = sut.parse(string);
        expect(result.data, date);
      });
    });
  });
}
