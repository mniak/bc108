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

extension LastReadStatusIntExtensions on int {
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
