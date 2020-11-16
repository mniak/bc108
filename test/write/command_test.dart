import 'package:bc108/application/write/command.dart';
import 'package:bc108/application/write/command_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('empty parameters:', () {
    test('when there are no parameters, should format as CMD 000', () {
      final cmd = Command("AAA", []);
      final payload = cmd.payload;
      expect("AAA000", payload);
    });

    test('when there is one empty parameter, should format as CMD 000', () {
      final cmd = Command("BBB", ['']);
      expect("BBB000", cmd.payload);
    });

    test('when there are two empty parameters, should format as CMD 000 000',
        () {
      final cmd = Command("CCC", ['', '']);
      expect("CCC000000", cmd.payload);
    });
  });

  group('payload examples:', () {
    final data = [
      [
        ['1234567890'],
        '010' + '1234567890'
      ],
      [
        ['123', '456', '7890'],
        '003' + '123' + '003' + '456' + '004' + '7890'
      ],
      [
        ['1234567890', '', '12345678901234567890123456789012345'],
        '010' +
            '1234567890' +
            '000' +
            '' +
            '035' +
            '12345678901234567890123456789012345'
      ],
    ];

    data.forEach((d) {
      final parameters = d[0] as Iterable<String>;
      final expected = d[1] as String;

      test('when there is one parameter, should format accordingly', () {
        final cmd = Command("CMD", parameters);
        expect("CMD" + expected, cmd.payload);
      });
    });
  });

  group('when command has length different than 3, should throw exception', () {
    final data = [1, 2, 4, 5];
    data.forEach((length) {
      test(length, () {
        expect(() => Command("X" * length, []),
            throwsA(isInstanceOf<InvalidCommandLengthException>()));
      });
    });
  });

  test('when parameter is lengthier than 999, should throw exception', () {
    expect(() => Command("CMD", ['x' * 1000]),
        throwsA(isInstanceOf<ParameterTooLongException>()));
  });
}
