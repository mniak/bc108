enum GoOnChipDecision {
  /// Transaction approved offline
  ApprovedOffline,

  /// Transaction denied
  Denied,

  /// Transaction requires online authorization
  PerformOnlineAuthorization,
}

extension GoOnChipDecisionIntExtension on int {
  GoOnChipDecision get asGoOnChipDecision {
    switch (this) {
      case 1:
        return GoOnChipDecision.Denied;
      case 2:
        return GoOnChipDecision.PerformOnlineAuthorization;

      case 0:
      default:
        return GoOnChipDecision.ApprovedOffline;
    }
  }
}

extension GoOnChipDecisionExtension on GoOnChipDecision {
  int get value {
    switch (this) {
      case GoOnChipDecision.Denied:
        return 1;
      case GoOnChipDecision.PerformOnlineAuthorization:
        return 2;

      case GoOnChipDecision.ApprovedOffline:
      default:
        return 0;
    }
  }
}
