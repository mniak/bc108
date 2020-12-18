import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/get_info.dart';
import 'package:test/test.dart';

void main() {
  test('mapResponse when status is not OK, should return null', () {
    final statusesNotOk = Statuses.where((x) => x != Status.PP_OK);

    for (var status in statusesNotOk) {
      final sut = Mapper();
      final response =
          sut.mapResponse(null, CommandResponse("GIN", status, []));
      expect(response, isNull);
    }
  });
}
