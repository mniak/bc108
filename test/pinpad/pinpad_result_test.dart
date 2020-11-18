import 'package:bc108/src/application/pinpad/pinpad_result.dart';
import 'package:bc108/src/application/read/command_result.dart';
import 'package:bc108/src/layer2/status.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class CommandResultMock extends Mock implements CommandResult {}

void main() {
  test('happy scenario', () {
    final cmdResult = CommandResultMock();
    final params = [
      faker.lorem.sentence(),
      faker.lorem.sentence(),
    ];
    final status = faker.randomGenerator.integer(100).toStatus();
    final data = faker.lorem.sentence();

    when(cmdResult.status).thenReturn(status);
    when(cmdResult.parameters).thenReturn(params);

    final ppResult = PinpadResult.fromCommandResult(cmdResult, (list) {
      expect(list, equals(params));
      return data;
    });

    expect(ppResult.status, equals(status));
    expect(ppResult.data, equals(data));
  });
}
