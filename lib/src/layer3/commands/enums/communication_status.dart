enum CommunicationStatus {
  Success,
  Failure,
}

extension CommunicationStatusIntExtension on int {
  CommunicationStatus get asCommunicationStatus {
    switch (this) {
      case 1:
        return CommunicationStatus.Failure;

      case 0:
      default:
        return CommunicationStatus.Success;
    }
  }
}

extension CommunicationStatusExtension on CommunicationStatus {
  int get value {
    switch (this) {
      case CommunicationStatus.Failure:
        return 1;

      case CommunicationStatus.Success:
      default:
        return 0;
    }
  }
}
