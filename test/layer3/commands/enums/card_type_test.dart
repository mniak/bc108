import 'package:bc108/src/layer3/exports.dart';
import 'package:test/test.dart';

void main() {
  var data = [
    [CardType.MagStripe, 0],
    [CardType.ModedeiroTibc1, 1],
    [CardType.ModedeiroTibc3, 2],
    [CardType.Emv, 3],
    [CardType.EasyEntryTibc1, 4],
    [CardType.ContactlessSimulatingStripe, 5],
    [CardType.ContactlessEmv, 6],
  ];

  data.forEach((d) {
    final e = d[0] as CardType;
    final i = d[1] as int;
    test('$e => $i', () {
      expect(e.value, i);
    });
    test('$i => $e', () {
      expect(i.asCardType, e);
    });
  });
}
