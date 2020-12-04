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

extension CardTypeGetCardIntExtensions on int {
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
}
