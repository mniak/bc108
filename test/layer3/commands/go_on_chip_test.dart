import 'package:bc108/src/layer3/commands/go_on_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serialize', () {
    final mapper = Mapper();
    final cmdRequest = mapper.mapRequest(GoOnChipRequest()
      ..amount = 27465
      ..secondaryAmount = 7100
      ..blacklisted = false
      ..requireOnlineAuthorization = false
      ..requirePin = true
      ..encryption = 2
      ..masterKeyIndex = 7
      ..workingKey = List.filled(16, 0)
      ..enableRiskManagement = true
      ..floorLimit = 10000
      ..biasedRandomSelection.targetPercentage = 20
      ..biasedRandomSelection.thresholdValue = 5000
      ..biasedRandomSelection.maxTargetPercentage = 75
      ..acquirerSpecificData = ""
      ..tags = ["9F27", "9F26", "95", "9B", "9F34", "9F10"]
      ..optionalTags = ["5F20", "5F28"]);

    expect(cmdRequest.code, equals("GOC"));
    expect(
        cmdRequest.parameters.elementAt(0),
        equals(
            "00000002746500000000710000120700000000000000000000000000000000100002710200000138875000"));
    expect(
        cmdRequest.parameters.elementAt(1), equals("0109F279F26959B9F349F10"));
    expect(cmdRequest.parameters.elementAt(2), equals("0045F205F28"));

    // expect(
    //     cmdRequest.payload,
    //     equals(
    //         "GOC086000000027465000000007100001207000000000000000000000000000000001000027102000001388750000230109F279F26959B9F349F100110045F205F28"));
  });
}
