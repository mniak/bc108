import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/go_on_chip.dart';
import 'package:bc108/src/layer3/fields/binary.dart';
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
      ..encryptionMode = EncryptionMode.DukptDes
      ..keyIndex = 7
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

    expect(
        cmdRequest.payload,
        equals(
            "GOC086000000027465000000007100001207000000000000000000000000000000001000027102000001388750000230109F279F26959B9F349F100110045F205F28"));
  });

  test('parse', () {
    final data =
        "GOC0001422000018D540BCF3001577AFFFF9876543210E0000C0479F2701809F260804CA8F1428AB5901950580000100009B02E8009F34030201009F100706011A039000005F28020076000";
    final mapper = Mapper();

    final request = GoOnChipRequest()
      ..tags = ["9F27", "9F26", "95", "9B", "9F34", "9F10"]
      ..optionalTags = ["5F20", "5F28"];

    final response = mapper.mapResponse(
        request, CommandResponse.fromDataFrame(DataFrame.data(data)));

    expect(response.decision, equals(ChipDecision.PerformOnlineAuthorization));
    expect(response.requireSignature, equals(false));
    expect(response.pinValidatedOffline, equals(false));
    expect(response.invalidOfflinePinAttempts, equals(0));
    expect(response.offlinePinBlocked, equals(false));
    expect(response.pinOnline, equals(true));
    expect(response.encryptedPin,
        orderedEquals([0x8D, 0x54, 0x0B, 0xCF, 0x30, 0x01, 0x57, 0x7A]));
    expect(
        response.keySerialNumber,
        orderedEquals(
            [0xFF, 0xFF, 0x98, 0x76, 0x54, 0x32, 0x10, 0xE0, 0x00, 0x0C]));
    expect(
        response.tags,
        equals({
          "9F27": [0x80],
          "9F26": [0x04, 0xCA, 0x8F, 0x14, 0x28, 0xAB, 0x59, 0x01],
          "95": [0x80, 0x00, 0x01, 0x00, 0x00],
          "9B": [0xE8, 0x00],
          "9F34": [0x02, 0x01, 0x00],
          "9F10": [0x06, 0x01, 0x1A, 0x03, 0x90, 0x00, 0x00],
          "5F28": [0x00, 0x76],
        }));
    expect(response.acquirerSpecificData, equals(""));
  });
  group('EncryptionMode', () {
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
  });

  group('ChipDecision', () {
    var data = [
      [ChipDecision.ApprovedOffline, 0],
      [ChipDecision.Denied, 1],
      [ChipDecision.PerformOnlineAuthorization, 2],
    ];

    data.forEach((d) {
      final e = d[0] as ChipDecision;
      final i = d[1] as int;
      test('$e => $i', () {
        expect(e.value, i);
      });
      test('$i => $e', () {
        expect(i.asChipDecision, e);
      });
    });
  });
}
