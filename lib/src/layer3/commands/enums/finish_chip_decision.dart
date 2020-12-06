enum FinishChipDecision {
  /// Transaction approved
  Approved,

  /// Transaction denied by the card
  DeniedByTheCard,

  /// Transaction requires by the Host
  DeniedByTheHost,
}

extension FinishChipDecisionIntExtension on int {
  FinishChipDecision get asFinishChipDecision {
    switch (this) {
      case 1:
        return FinishChipDecision.DeniedByTheCard;
      case 2:
        return FinishChipDecision.DeniedByTheHost;

      case 0:
      default:
        return FinishChipDecision.Approved;
    }
  }
}

extension FinishChipDecisionExtension on FinishChipDecision {
  int get value {
    switch (this) {
      case FinishChipDecision.DeniedByTheCard:
        return 1;
      case FinishChipDecision.DeniedByTheHost:
        return 2;

      case FinishChipDecision.Approved:
      default:
        return 0;
    }
  }
}
