import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/enums/application_type.dart';
import 'package:bc108/src/layer3/commands/get_card.dart';
import 'package:test/test.dart';

void main() {
  test('serialize', () {
    final mapper = GetCardMapper();
    final cmdRequest = mapper.mapRequest(GetCardRequest()
      ..acquirer = 0
      ..applicationType = ApplicationType.Debito
      ..amount = 1500
      ..datetime = DateTime(2002, 10, 24, 19, 38, 45)
      ..timestamp = 2310200201
      ..applications = []
      ..enableContactless = true);

    expect(cmdRequest.code, equals("GCR"));
    expect(cmdRequest.parameters.elementAt(0),
        equals("00020000000015000210241938452310200201001"));

    expect(cmdRequest.payload,
        equals("GCR04100020000000015000210241938452310200201001"));
  });

  test('parse', () {
    final mapper = GetCardMapper();

    final request = GetCardRequest();

    final response = mapper.mapResponse(
        request,
        CommandResponse("GCR", Status.PP_OK, [
          "03001010200                                                                            29376436871651006=0305000523966        000                                                                                                        15376436871651006    01AMEX GREEN      246JOAO DA SILVA             04123100                   00000000076000"
        ]));

    expect(response.cardType, equals(CardType.Emv));
    expect(response.statusLastChipRead, equals(0));
    expect(response.applicationType, equals(1));
    expect(response.acquirer, equals(01));
    expect(response.applicationIndex, equals(2));
    expect(response.track1, equals(""));
    expect(response.track2, equals("376436871651006=0305000523966"));
    expect(response.track3, equals(""));
    expect(response.pan, equals("376436871651006"));
    expect(response.panSequenceNumber, equals(1));
    expect(response.applicationLabel, equals("AMEX GREEN"));
    expect(response.serviceCode, equals(246));
    expect(response.cardHolderName, equals("JOAO DA SILVA"));
    expect(response.applicationExpirationDate, equals(DateTime(2004, 12, 31)));
    expect(response.externalCardNumber, equals(""));
    expect(response.moedeiroBalance, equals(0));
    expect(response.issuerCountryCode, equals(76));
    expect(response.acquirerSpecificData, equals(""));
  });

  test('mapResponse when status is not OK, should return null', () {
    final statusesNotOk = Statuses.where((x) => x != Status.PP_OK);

    for (var status in statusesNotOk) {
      final request = GetCardRequest();
      final sut = GetCardMapper();
      final response =
          sut.mapResponse(request, CommandResponse("GRC", status, []));
      expect(response, isNull);
    }
  });
}
