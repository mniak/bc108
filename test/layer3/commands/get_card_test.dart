import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/commands/get_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serialize', () {
    final mapper = GetCardMapper();
    final cmdRequest = mapper.mapRequest(GetCardRequest()
      ..acquirer = 0
      ..application = 99
      ..amount = 1500
      ..datetime = DateTime(2002, 10, 24, 19, 38, 45)
      ..timestamp = 2310200201
      ..applications = []
      ..enableContactless = true);

    expect(cmdRequest.code, equals("GCR"));
    expect(cmdRequest.parameters.elementAt(0),
        equals("00990000000015000210241938452310200201001"));

    expect(cmdRequest.payload,
        equals("GCR04100990000000015000210241938452310200201001"));
  });

  test('parse', () {
    final data =
        "GCR00034203001010200                                                                            29376436871651006=0305000523966        000                                                                                                        15376436871651006    01AMEX GREEN      246JOAO DA SILVA             04123100                   00000000076000";
    final mapper = GetCardMapper();

    final request = GetCardRequest();

    final response = mapper.mapResponse(
        request, CommandResponse.fromDataFrame(DataFrame.data(data)));

    expect(response.cardType, equals(3));
    expect(response.statusLastChipRead, equals(0));
    expect(response.applicationType, equals(01));
    expect(response.acquirer, equals(01));
    expect(response.applicationIndex, equals(02));
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

  group('CardType', () {
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
  });

  group('LastReadStatus', () {
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
  });
}
