import 'package:bc108/src/layer3/exports.dart';
import 'package:test/test.dart';

void main() {
  var data = [
    [GoOnChipDecision.ApprovedOffline, 0],
    [GoOnChipDecision.Denied, 1],
    [GoOnChipDecision.PerformOnlineAuthorization, 2],
  ];

  data.forEach((d) {
    final e = d[0] as GoOnChipDecision;
    final i = d[1] as int;
    test('$e => $i', () {
      expect(e.value, i);
    });
    test('$i => $e', () {
      expect(i.asGoOnChipDecision, e);
    });
  });
}
