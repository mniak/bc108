import 'package:bc108/src/layer3/commands/close.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

void main() {
  test('constructor', () {
    final line1 = faker.lorem.sentence();
    final line2 = faker.lorem.sentence();
    final request = CloseRequest(line1, line2);

    expect(request.idleMessageLine1, equals(line1));
    expect(request.idleMessageLine2, equals(line2));
  });

  test('serialize request padding right with white space', () {
    final sut = Mapper();

    final request = CloseRequest("VICTORIA", "SUPERMARKET");

    final command = sut.mapRequest(request);

    expect(command.code, equals("CLO"));
    expect(command.parameters, hasLength(1));

    expect(command.parameters.elementAt(0),
        equals("VICTORIA        SUPERMARKET     "));
  });

  test('serialize request with very long text', () {
    final sut = Mapper();

    final request = CloseRequest('Vic' * 20, "Market" * 20);

    final command = sut.mapRequest(request);

    expect(command.code, equals("CLO"));
    expect(command.parameters, hasLength(1));

    expect(command.parameters.elementAt(0),
        equals("VicVicVicVicVicVMarketMarketMark"));
  });
}
