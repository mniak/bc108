import 'package:bc108/bc108.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor', () {
    final line1 = faker.lorem.sentence();
    final line2 = faker.lorem.sentence();
    final request = CloseRequest(line1, line2);

    expect(request.idleMessageLine1, equals(line1));
    expect(request.idleMessageLine2, equals(line2));
  });
}
