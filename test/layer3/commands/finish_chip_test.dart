import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/finish_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('request mapping', () {
    final sut = Mapper();

    final command = sut.mapRequest(FinishChipRequest()
      ..status = CommunicationStatus.Success
      ..issuerType = IssuerType.EmvFullGrade
      ..authorizationResponseCode = "00"
      ..tags = TlvMap({
        "91": BinaryData.fromHex("330D56C80029FC3A"),
      }, "9108330D56C80029FC3A")
      ..requiredTagsList = ["9F27", "9F26"]);

    expect(command.code, equals("FNC"));
    expect(command.parameters, hasLength(2));

    expect(command.parameters.elementAt(0),
        equals("00000109108330D56C80029FC3A000"));

    expect(command.parameters.elementAt(1), equals("0049F279F26"));
  });

  test('parse response', () {
    final sut = Mapper();

    final request = FinishChipRequest()..requiredTagsList = ["9F27", "9F26"];

    final commandResponse = CommandResponse(
        "FNC", Status.PP_OK, ["00159F2701409F260819C5D08A4419BBD900000"]);

    final response = sut.mapResponse(request, commandResponse);

    expect(response.decision, equals(FinishChipDecision.Approved));
    final expectedTags = TlvMap({
      "9F27": BinaryData.fromHex("40"),
      "9F26": BinaryData.fromHex("19C5D08A4419BBD9"),
    }, "9F2701409F260819C5D08A4419BBD9");
    expect(response.tags, equals(expectedTags));
    expect(response.issuerScriptResults, isEmpty);
    expect(response.acquirerSpecificData, isEmpty);
  });
}
