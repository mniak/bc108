import 'package:bc108/application/read/command_result.dart';
import 'package:bc108/application/read/command_result_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when is null should raise error', () {
    expect(() => CommandResult.parse(null),
        throwsA(isInstanceOf<CommandResultParseException>()));
  });

  group('when does not match pattern should raise error', () {
    final data = [
      "ABCD000",
      "AB000",
      "ABC01A",
      "ABCDEF",
    ];
    for (var d in data) {
      test(d, () {
        expect(() => CommandResult.parse(d),
            throwsA(isInstanceOf<CommandResultParseException>()));
      });
    }
  });
}
