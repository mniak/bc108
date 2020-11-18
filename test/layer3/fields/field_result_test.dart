import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constructor happy scenario', () {
    final data = faker.lorem.sentence();
    final remaining = faker.lorem.sentence();

    final sut = FieldResult(data, remaining);

    expect(sut.data, equals(data));
    expect(sut.remaining, equals(remaining));
  });
}
