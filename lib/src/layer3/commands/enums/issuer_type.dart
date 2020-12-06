enum IssuerType {
  EmvFullGrade,
  EmvPartialGrade,
}

extension IssuerTypeIntExtension on int {
  IssuerType get asIssuerType {
    switch (this) {
      case 1:
        return IssuerType.EmvPartialGrade;

      case 0:
      default:
        return IssuerType.EmvFullGrade;
    }
  }
}

extension IssuerTypeExtension on IssuerType {
  int get value {
    switch (this) {
      case IssuerType.EmvPartialGrade:
        return 1;

      case IssuerType.EmvFullGrade:
      default:
        return 0;
    }
  }
}
