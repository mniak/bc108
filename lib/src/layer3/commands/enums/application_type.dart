enum ApplicationType {
  FromList,
  Credito,
  Debito,
  Any,
}

extension ApplicationTypeExtension on ApplicationType {
  int get value {
    switch (this) {
      case ApplicationType.FromList:
        return 0;

      case ApplicationType.Credito:
        return 1;
      case ApplicationType.Debito:
        return 2;

      case ApplicationType.Any:
      default:
        return 99;
    }
  }
}

extension ApplicationTypeGetCardIntExtensions on int {
  ApplicationType get asApplicationType {
    switch (this) {
      case 0:
        return ApplicationType.FromList;

      case 1:
        return ApplicationType.Credito;
      case 2:
        return ApplicationType.Debito;

      case 99:
      default:
        return ApplicationType.Any;
    }
  }
}
