import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/get_timestamp.dart';
import 'package:test/test.dart';

void main() {
  test('mapResponse when status is not OK, should return null', () {
    final statusesNotOk = Statuses.where((x) => x != Status.PP_OK);

    for (var status in statusesNotOk) {
      final request = GetTimestampRequest();
      final sut = Mapper();
      final response =
          sut.mapResponse(request, CommandResponse("GTS", status, []));
      expect(response, isNull);
    }
  });
}
