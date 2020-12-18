import 'package:bc108/src/layer3/exports.dart';
import 'package:test/test.dart';

void main() {
  var data = [
    [LastReadStatus.Successful, 0],
    [LastReadStatus.FallbackError, 1],
    [LastReadStatus.RequiredApplicationNotSupported, 2],
  ];

  data.forEach((d) {
    final e = d[0] as LastReadStatus;
    final i = d[1] as int;
    test('$e => $i', () {
      expect(e.value, i);
    });
    test('$i => $e', () {
      expect(i.asLastReadStatus, e);
    });
  });
}
