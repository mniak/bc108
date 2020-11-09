import 'package:bc108/command.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when there are no parameters, should format as CMD000', () {
    final cmd = Command("OPN", []);
    final payload = cmd.getPayload();

    expect("OPN000", payload);
  });
}
