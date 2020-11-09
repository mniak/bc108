import 'package:bc108/command.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatting parameters', () {
    test('when there are no parameters, should format as CMD 000', () {
      final cmd = Command("AAA", []);
      final payload = cmd.getPayload();
      expect("AAA000", payload);
    });

    test('when there is one empty parameter, should format as CMD 000', () {
      final cmd = Command("BBB", ['']);
      final payload = cmd.getPayload();
      expect("BBB000", payload);
    });

    test('when there are two empty parameters, should format as CMD 000 000',
        () {
      final cmd = Command("CCC", ['', '']);
      final payload = cmd.getPayload();
      expect("CCC000000", payload);
    });
  });
}
