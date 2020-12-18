import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer1/pinpad_result.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class CommandResponseMock extends Mock implements CommandResponse {}

void main() {
  test('happy scenario', () {
    final status = faker.randomGenerator.integer(100).toStatus();
    final data = faker.lorem.sentence();

    final ppResult = PinpadResult(status, data);

    expect(ppResult.status, equals(status));
    expect(ppResult.data, equals(data));
  });
}
