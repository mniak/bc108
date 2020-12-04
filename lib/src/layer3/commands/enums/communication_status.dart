enum CommunicationStatus {
  Successful,
  Failure,
}

extension CommunicationStatusIntExtension on int {
  CommunicationStatus get asCommunicationStatus {
    switch (this) {
      case 1:
        return CommunicationStatus.Failure;

      case 0:
      default:
        return CommunicationStatus.Successful;
    }
  }
}

extension CommunicationStatusExtension on CommunicationStatus {
  int get value {
    switch (this) {
      case CommunicationStatus.Failure:
        return 1;

      case CommunicationStatus.Successful:
      default:
        return 0;
    }
  }
}
