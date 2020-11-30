import 'package:bc108/src/layer2/exports.dart';

import '../fields/alphanumeric.dart';
import '../fields/boolean.dart';
import '../fields/composite.dart';
import '../fields/hexadecimal.dart';
import '../fields/numeric.dart';
import '../mapper.dart';

class GoOnChipRequestBiasedRandomSelection {
  int targetPercentage;
  int thresholdValue;
  int maxTargetPercentage;
}

class GoOnChipRequest {
  int amount;
  int secondaryAmount;
  bool blacklisted;
  bool requireOnlineAuthorization;
  bool requirePin;
  int encryption;
  int masterKeyIndex;
  String workingKey;

  bool enableRiskManagement;
  int floorLimit;
  GoOnChipRequestBiasedRandomSelection biasedRandomSelection =
      GoOnChipRequestBiasedRandomSelection();

  String acquirerSpecificData;

  List<Iterable<int>> tags = List<Iterable<int>>();
  List<Iterable<int>> optionalTags = List<Iterable<int>>();
}

class GoOnChipResponse {
  int decision;
  bool requireSignature;
  bool pinValidatedOffline;
  int invalidOfflinePinAttempts;
  bool offlinePinBlocked;
  bool pinOnline;
  Iterable<int> encryptedPin;
  Iterable<int> keySerialNumber;

  int bit55DataLength;
  String bit55Data;

  String acquirerSpecificData;
}

class Mapper
    implements RequestResponseMapper<GoOnChipRequest, GoOnChipResponse> {
  static final _inputField = CompositeField([
    NumericField(12),
    NumericField(12),
    BooleanField(),
    BooleanField(),
    BooleanField(),
    BooleanField(),
    NumericField(2),
    BinaryField(16),
    BooleanField(),
    BinaryField(8),
    NumericField(2),
    BinaryField(8),
    NumericField(2),
    VariableAlphanumericField(3, inclusive: true)
  ]);
  static final _tagsField = CompositeField([]);
  static final _optionalTagsField = CompositeField([]);
  @override
  CommandRequest mapRequest(GoOnChipRequest request) {
    return CommandRequest("GOC", [
      _inputField.serialize([]),
      _tagsField.serialize([]),
      _optionalTagsField.serialize([]),
    ]);
  }

  static final _responseField = CompositeField([]);
  @override
  GoOnChipResponse mapResponse(CommandResponse result) {
    return GoOnChipResponse();
  }
}
