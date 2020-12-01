import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer3/fields/date.dart';
import 'package:bc108/src/layer3/fields/date_time.dart';
import 'package:bc108/src/layer3/fields/list.dart';
import '../fields/alphanumeric.dart';
import '../fields/composite.dart';
import '../fields/numeric.dart';
import '../mapper.dart';
import '../handler.dart';

class GetCardRequestListItem {
  int acquirer;
  int index;
}

class GetCardRequest {
  int acquirer = 0;
  int application = 99;
  int amount = 0;
  DateTime datetime = DateTime.now();
  int timestamp = 0;
  List<GetCardRequestListItem> applications = List<GetCardRequestListItem>();
  bool enableContactless = true;
}

enum CardType {
  /// Magnetic
  MagStripe,

  /// Moedeiro VISA Cash over TIBC v1
  ModedeiroTibc1,

  /// Moedeiro VISA Cash over TIBC v3
  ModedeiroTibc3,

  /// EMV with contact
  Emv,

  /// Easy-Entry over TIBC v1
  EasyEntryTibc1,
  // Contactless chip simulating stripe
  ContactlessSimulatingStripe,

  /// Contactless EMV
  ContactlessEmv,
}

extension CardTypeExtension on CardType {
  int get value {
    switch (this) {
      case CardType.ModedeiroTibc1:
        return 1;
      case CardType.ModedeiroTibc3:
        return 2;
      case CardType.Emv:
        return 3;
      case CardType.EasyEntryTibc1:
        return 4;
      case CardType.ContactlessSimulatingStripe:
        return 5;
      case CardType.ContactlessEmv:
        return 6;

      case CardType.MagStripe:
      default:
        return 0;
    }
  }
}

enum LastReadStatus {
  /// Successful (or another status that does not imply a fallback)
  ///
  /// In this case, the magnetic card indicating the presence of a chip must not
  /// be accepted.
  Successful,

  /// Fallback error
  ///
  /// In this case, the TEF Server can request transaction approval with a
  /// magnetic card, even if it has an indication of the presence of a chip
  /// (depends on the definitions of the acquiring network)
  FallbackError,

  /// Required application not supported
  ///
  /// In this case, the TEF Server can request transaction approval with a
  /// magnetic card, even if it has an indication of the presence of a chip
  /// (depends on the definitions of the acquiring network).
  RequiredApplicationNotSupported,
}

extension LastReadStatusExtension on LastReadStatus {
  int get value {
    switch (this) {
      case LastReadStatus.FallbackError:
        return 1;
      case LastReadStatus.RequiredApplicationNotSupported:
        return 2;

      case LastReadStatus.Successful:
      default:
        return 0;
    }
  }
}

enum CardType {
  /// Magnetic
  MagStripe,

  /// Moedeiro VISA Cash over TIBC v1
  ModedeiroTibc1,

  /// Moedeiro VISA Cash over TIBC v3
  ModedeiroTibc3,

  /// EMV with contact
  Emv,

  /// Easy-Entry over TIBC v1
  EasyEntryTibc1,
  // Contactless chip simulating stripe
  ContactlessSimulatingStripe,

  /// Contactless EMV
  ContactlessEmv,
}

enum LastReadStatus {
  /// Successful (or another status that does not imply a fallback)
  ///
  /// In this case, the magnetic card indicating the presence of a chip must not
  /// be accepted.
  Successful,

  /// Fallback error
  ///
  /// In this case, the TEF Server can request transaction approval with a
  /// magnetic card, even if it has an indication of the presence of a chip
  /// (depends on the definitions of the acquiring network)
  FallbackError,

  /// Required application not supported
  ///
  /// In this case, the TEF Server can request transaction approval with a
  /// magnetic card, even if it has an indication of the presence of a chip
  /// (depends on the definitions of the acquiring network).
  RequiredApplicationNotSupported,
}

class GetCardResponse {
  int cardType;
  int statusLastChipRead;
  int applicationType;
  int acquirer;
  int applicationIndex;
  String track1;
  String track2;
  String track3;
  String pan;
  int panSequenceNumber;
  String applicationLabel;
  int serviceCode;
  String cardHolderName;
  DateTime applicationExpirationDate;
  String externalCardNumber;
  int moedeiroBalance;
  int issuerCountryCode;
  String acquirerSpecificData;
}

class GetCardResponseMapper {
  static final _responseField = CompositeField([
    NumericField(2),
    NumericField(1),
    NumericField(2),
    NumericField(2),
    NumericField(2),
    FixedVariableAlphanumericField(2, 76),
    FixedVariableAlphanumericField(2, 37),
    FixedVariableAlphanumericField(3, 104),
    FixedVariableAlphanumericField(2, 19),
    NumericField(2),
    AlphanumericField(16),
    NumericField(3),
    AlphanumericField(26),
    DateField(),
    FixedVariableAlphanumericField(2, 19),
    NumericField(8),
    NumericField(3),
    VariableAlphanumericField(3),
  ]);

  GetCardResponse map(CommandResponse result) {
    final parsed = _responseField.parse(result.parameters[0]);
    return GetCardResponse()
      ..cardType = parsed.data[0]
      ..statusLastChipRead = parsed.data[1]
      ..applicationType = parsed.data[2]
      ..acquirer = parsed.data[3]
      ..applicationIndex = parsed.data[4]
      ..track1 = parsed.data[5]
      ..track2 = parsed.data[6]
      ..track3 = parsed.data[7]
      ..pan = parsed.data[8]
      ..panSequenceNumber = parsed.data[9]
      ..applicationLabel = parsed.data[10]
      ..serviceCode = parsed.data[11]
      ..cardHolderName = parsed.data[12]
      ..applicationExpirationDate = parsed.data[13]
      ..externalCardNumber = parsed.data[14]
      ..moedeiroBalance = parsed.data[15]
      ..issuerCountryCode = parsed.data[16]
      ..acquirerSpecificData = parsed.data[17];
  }
}

class GetCardMapper
    with GetCardResponseMapper
    implements RequestResponseMapper<GetCardRequest, GetCardResponse> {
  static final _requestField = CompositeField([
    NumericField(2),
    NumericField(2),
    NumericField(12),
    DateTimeField(),
    NumericField(10),
    ListField(
        2,
        CompositeField([
          NumericField(2),
          NumericField(2),
        ])),
    BooleanField(),
  ]);

  @override
  CommandRequest mapRequest(GetCardRequest request) {
    return CommandRequest("GCR", [
      _requestField.serialize([
        request.acquirer,
        request.application,
        request.amount,
        request.datetime,
        request.timestamp,
        request.applications,
        request.enableContactless,
      ])
    ]);
  }

  @override
  GetCardResponse mapResponse(GetCardRequest request, CommandResponse result) =>
      super.map(result);
}

class ResumeGetCardMapper
    with GetCardResponseMapper
    implements RequestResponseMapper<void, GetCardResponse> {
  @override
  CommandRequest mapRequest(void request) {
    return CommandRequest("GCR", []);
  }

  @override
  GetCardResponse mapResponse(void request, CommandResponse result) =>
      super.map(result);
}

class GetCardFactory {
  RequestHandler<GetCardRequest, GetCardResponse> getCard(CommandProcessor o) =>
      RequestHandler.fromMapper(o, GetCardMapper());

  RequestHandler<void, GetCardResponse> resumeGetCard(CommandProcessor o) =>
      RequestHandler.fromMapper(o, ResumeGetCardMapper());
}

extension GetCardIntExtensions on int {
  CardType get asCardType {
    switch (this) {
      case 1:
        return CardType.ModedeiroTibc1;
      case 2:
        return CardType.ModedeiroTibc3;
      case 3:
        return CardType.Emv;
      case 4:
        return CardType.EasyEntryTibc1;
      case 5:
        return CardType.ContactlessSimulatingStripe;
      case 6:
        return CardType.ContactlessEmv;

      case 0:
      default:
        return CardType.MagStripe;
    }
  }

  LastReadStatus get asLastReadStatus {
    switch (this) {
      case 1:
        return LastReadStatus.FallbackError;
      case 2:
        return LastReadStatus.RequiredApplicationNotSupported;

      case 0:
      default:
        return LastReadStatus.Successful;
    }
  }
}
