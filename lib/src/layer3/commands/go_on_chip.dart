import 'package:bc108/src/layer2/exports.dart';
import 'package:convert/convert.dart';

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
  Iterable<int> workingKey;

  bool enableRiskManagement;
  int floorLimit;
  GoOnChipRequestBiasedRandomSelection biasedRandomSelection =
      GoOnChipRequestBiasedRandomSelection();

  String acquirerSpecificData;

  List<String> tags = List<String>();
  List<String> optionalTags = List<String>();
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
    NumericField(1),
    NumericField(2),
    BinaryField(16),
    BooleanField(),
    BinaryField(4),
    NumericField(2),
    BinaryField(4),
    NumericField(2),
    VariableAlphanumericField(3),
  ]);
  static final _tagsField = VariableBinaryField(3);
  static final _optionalTagsField = VariableBinaryField(3);
  @override
  CommandRequest mapRequest(GoOnChipRequest request) {
    return CommandRequest("GOC", [
      _inputField.serialize([
        request.amount,
        request.secondaryAmount,
        request.blacklisted,
        request.requireOnlineAuthorization,
        request.requirePin,
        request.encryption,
        request.masterKeyIndex,
        request.workingKey,
        request.enableRiskManagement,
        request.floorLimit.int32Binary,
        request.biasedRandomSelection.targetPercentage,
        request.biasedRandomSelection.thresholdValue.int32Binary,
        request.biasedRandomSelection.maxTargetPercentage,
        request.acquirerSpecificData,
      ]),
      _tagsField.serialize(request.tags.expand((x) => hex.decode(x))),
      _optionalTagsField
          .serialize(request.optionalTags.expand((x) => hex.decode(x))),
    ]);
  }

  static final _responseField = CompositeField([]);
  @override
  GoOnChipResponse mapResponse(CommandResponse result) {
    return GoOnChipResponse();
  }
}
