import 'package:bc108/src/layer3/commands/remove_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('request mapping', () {
    test('when lines are empty, shoul fill with spaces', () {
      final sut = Mapper();

      final cmd = sut.mapRequest(RemoveCardRequest("line1", "line2"));

      expect(cmd.code, equals("RMC"));
      expect(cmd.parameters.elementAt(0),
          equals("line1           line2           "));
    });

    test('when short length, should pad right with spaces', () {
      final sut = Mapper();

      final cmd = sut.mapRequest(RemoveCardRequest("line1", "line2"));

      expect(cmd.code, equals("RMC"));
      expect(cmd.parameters.elementAt(0),
          equals("line1           line2           "));
    });

    test('line 1 should not overflow to line 2', () {
      final sut = Mapper();

      final cmd = sut.mapRequest(
          RemoveCardRequest("the line 1 is so long, man", "--- line2 ---"));

      expect(cmd.code, equals("RMC"));
      expect(cmd.parameters.elementAt(0),
          equals("the line 1 is so--- line2 ---   "));
    });

    test('should truncate lines', () {
      final sut = Mapper();

      final cmd = sut.mapRequest(RemoveCardRequest('1' * 40, '2' * 40));

      expect(cmd.code, equals("RMC"));
      expect(cmd.parameters.elementAt(0),
          equals("11111111111111112222222222222222"));
    });
  });
}
