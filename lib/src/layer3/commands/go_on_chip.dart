import 'package:bc108/src/layer2/exports.dart';

import '../fields/alphanumeric.dart';
import '../fields/binary.dart';
import '../fields/boolean.dart';
import '../fields/composite.dart';
import '../fields/numeric.dart';
import '../fields/tlv.dart';
import '../handler.dart';
import '../mapper.dart';
import 'enums/encryption_mode.dart';
import 'enums/go_on_chip_decision.dart';

class BiasedRandomSelection {
  int targetPercentage = 0;
  int thresholdValue = 0;
  int maxTargetPercentage = 0;
}

class GoOnChipRequest {
  int amount = 0;
  int secondaryAmount = 0;
  bool blacklisted = false;
  bool requireOnlineAuthorization = false;
  bool requirePin = false;
  EncryptionMode encryptionMode = EncryptionMode.MasterKeyDes;
  int keyIndex = 0;
  Iterable<int> workingKey = [];
  bool enableRiskManagement = false;
  int floorLimit = 0;
  BiasedRandomSelection biasedRandomSelection = BiasedRandomSelection();
  String acquirerSpecificData = "";
  List<String> tags = List<String>();
  List<String> optionalTags = List<String>();
}

class GoOnChipResponse {
  GoOnChipDecision decision;
  bool requireSignature;
  bool pinValidatedOffline;
  int invalidOfflinePinAttempts;
  bool pinBlockedOffline;
  bool pinCapturedForOnlineValidation;
  BinaryData encryptedPin;
  BinaryData keySerialNumber;
  TlvMap tags;
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
        request.encryptionMode.value,
        request.keyIndex,
        BinaryData.fromBytes(request.workingKey),
        request.enableRiskManagement,
        BinaryData.fromBytes(request.floorLimit.int32Binary),
        request.biasedRandomSelection.targetPercentage,
        BinaryData.fromBytes(
            request.biasedRandomSelection.thresholdValue.int32Binary),
        request.biasedRandomSelection.maxTargetPercentage,
        request.acquirerSpecificData,
      ]),
      _tagsField.serialize(BinaryData.fromHex(request.tags.join())),
      _optionalTagsField
          .serialize(BinaryData.fromHex(request.optionalTags.join())),
    ]);
  }

  @override
  GoOnChipResponse mapResponse(
      GoOnChipRequest request, CommandResponse result) {
    if (result.status != Status.PP_OK) return null;
    final _responseField = CompositeField([
      NumericField(1),
      BooleanField(),
      BooleanField(),
      NumericField(1),
      BooleanField(),
      BooleanField(),
      BinaryField(8),
      BinaryField(10),
      TlvFieldWithHeader(3, [...request.tags, ...request.optionalTags]),
      VariableAlphanumericField(3),
    ]);
    final parsed = _responseField.parse(result.parameters[0]);
    return GoOnChipResponse()
      ..decision = (parsed.data[0] as int).asGoOnChipDecision
      ..requireSignature = parsed.data[1] as bool
      ..pinValidatedOffline = parsed.data[2] as bool
      ..invalidOfflinePinAttempts = parsed.data[3] as int
      ..pinBlockedOffline = parsed.data[4] as bool
      ..pinCapturedForOnlineValidation = parsed.data[5] as bool
      ..encryptedPin = parsed.data[6] as BinaryData
      ..keySerialNumber = parsed.data[7] as BinaryData
      ..tags = parsed.data[8] as TlvMap
      ..acquirerSpecificData = parsed.data[9] as String;
  }
}

class GoOnChipFactory {
  RequestHandler<GoOnChipRequest, GoOnChipResponse> goOnChip(
          CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
