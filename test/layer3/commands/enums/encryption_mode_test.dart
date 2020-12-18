import 'package:bc108/src/layer3/exports.dart';
import 'package:test/test.dart';

void main() {
  var data = [
    [EncryptionMode.MasterKeyDes, 0],
    [EncryptionMode.MasterKey3Des, 1],
    [EncryptionMode.DukptDes, 2],
    [EncryptionMode.Dukpt3Des, 3],
  ];

  data.forEach((d) {
    final e = d[0] as EncryptionMode;
    final i = d[1] as int;
    test('$e => $i', () {
      expect(e.value, i);
    });
    test('$i => $e', () {
      expect(i.asEncryptionMode, e);
    });
  });
}
