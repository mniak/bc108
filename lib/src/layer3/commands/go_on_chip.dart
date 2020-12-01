import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/fields/tlv.dart';
import 'package:convert/convert.dart';

import '../fields/alphanumeric.dart';
import '../fields/boolean.dart';
import '../fields/composite.dart';
import '../fields/hexadecimal.dart';
import '../fields/numeric.dart';
import '../handler.dart';
import '../mapper.dart';

class BiasedRandomSelection {
  int targetPercentage = 0;
  int thresholdValue = 0;
  int maxTargetPercentage = 0;
}

enum EncryptionMode {
  /// Master Key / Working DES (8 bytes)
  MasterKeyDes,

  ///  Master Key / Working 3DES (16 bytes)
  MasterKey3Des,

  /// DUKPT DES
  DukptDes,

  /// DUKPT 3DES
  Dukpt3Des,
}

extension EncryptionModeExtension on EncryptionMode {
  int get value {
    switch (this) {
      case EncryptionMode.MasterKey3Des:
        return 1;
      case EncryptionMode.DukptDes:
        return 2;
      case EncryptionMode.Dukpt3Des:
        return 3;

      case EncryptionMode.MasterKeyDes:
      default:
        return 0;
    }
  }
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

enum ChipDecision {
  /// Transaction approved offline
  ApprovedOffline,

  /// Transaction denied
  Denied,

  /// Transaction requires online authorization
  PerformOnlineAuthorization,
}

class GoOnChipResponse {
  ChipDecision decision;
  bool requireSignature;
  bool pinValidatedOffline;
  int invalidOfflinePinAttempts;
  bool offlinePinBlocked;
  bool pinOnline;
  Iterable<int> encryptedPin;
  Iterable<int> keySerialNumber;
  Map<String, Iterable<int>> tags;
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

  static final _responseField = CompositeField([
    NumericField(1),
    BooleanField(),
    BooleanField(),
    NumericField(1),
    BooleanField(),
    BooleanField(),
    BinaryField(8),
    BinaryField(10),
    VariableBinaryField(3),
    VariableAlphanumericField(3),
  ]);
  @override
  GoOnChipResponse mapResponse(
      GoOnChipRequest request, CommandResponse result) {
    final parsed = _responseField.parse(result.parameters[0]);
    final tagsField = TlvField([...request.tags, ...request.optionalTags]);
    final binaryData = parsed.data[8] as Iterable<int>;
    final parsedTags = tagsField.parse(hex.encode(binaryData).toUpperCase());
    return GoOnChipResponse()
      ..decision = (parsed.data[0] as int).asChipDecision
      ..requireSignature = parsed.data[1] as bool
      ..pinValidatedOffline = parsed.data[2] as bool
      ..invalidOfflinePinAttempts = parsed.data[3] as int
      ..offlinePinBlocked = parsed.data[4] as bool
      ..pinOnline = parsed.data[5] as bool
      ..encryptedPin = parsed.data[6] as Iterable<int>
      ..keySerialNumber = parsed.data[7] as Iterable<int>
      ..tags = parsedTags.data
      ..acquirerSpecificData = parsed.data[9] as String;
  }
}

extension GoOnChipIntExtension on int {
  EncryptionMode get asEncryptionMode {
    switch (this) {
      case 1:
        return EncryptionMode.MasterKey3Des;
      case 2:
        return EncryptionMode.DukptDes;
      case 3:
        return EncryptionMode.Dukpt3Des;

      case 0:
      default:
        return EncryptionMode.MasterKeyDes;
    }
  }

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

class GoOnChipFactory {
  RequestHandler<GoOnChipRequest, GoOnChipResponse> goOnChip(
          CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
