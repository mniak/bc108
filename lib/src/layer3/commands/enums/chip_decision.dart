enum ChipDecision {
  /// Transaction approved offline
  ApprovedOffline,

  /// Transaction denied
  Denied,

  /// Transaction requires online authorization
  PerformOnlineAuthorization,
}

extension ChipDecisionIntExtension on int {
  ChipDecision get asChipDecision {
    switch (this) {
      case 1:
        return ChipDecision.Denied;
      case 2:
        return ChipDecision.PerformOnlineAuthorization;

      case 0:
      default:
        return ChipDecision.ApprovedOffline;
    }
  }
}

extension ChipDecisionExtension on ChipDecision {
  int get value {
    switch (this) {
      case ChipDecision.Denied:
        return 1;
      case ChipDecision.PerformOnlineAuthorization:
        return 2;

      case ChipDecision.ApprovedOffline:
      default:
        return 0;
    }
  }
}
