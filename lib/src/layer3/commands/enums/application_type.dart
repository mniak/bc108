enum ApplicationType {
  Credito,
  Debito,
  Unspecified,
}

extension ApplicationTypeExtension on ApplicationType {
  int get value {
    switch (this) {
      case ApplicationType.Credito:
        return 1;
      case ApplicationType.Debito:
        return 2;

      case ApplicationType.Unspecified:
      default:
        return 0;
    }
  }
}

extension ApplicationTypeGetCardIntExtensions on int {
  ApplicationType get asApplicationType {
    switch (this) {
      case 1:
        return ApplicationType.Credito;
      case 2:
        return ApplicationType.Debito;

      case 0:
      default:
        return ApplicationType.Unspecified;
    }
  }
}
