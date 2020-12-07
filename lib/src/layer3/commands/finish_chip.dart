import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/commands/enums/communication_status.dart';
import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:bc108/src/layer3/fields/binary.dart';
import 'package:bc108/src/layer3/fields/composite.dart';
import 'package:bc108/src/layer3/fields/list.dart';
import 'package:bc108/src/layer3/fields/numeric.dart';
import '../handler.dart';
import '../mapper.dart';
import '../fields/tlv.dart';
import 'enums/finish_chip_decision.dart';

class FinishChipRequest {
  CommunicationStatus status = CommunicationStatus.Success;
  IssuerType issuerType = IssuerType.EmvFullGrade;
  String authorizationResponseCode = "";
  TlvMap tags = TlvMap.empty();
  String acquirerSpecificData = "";

  List<String> requiredTagsList = [];
}

class FinishChipResponse {
  FinishChipDecision decision;
  TlvMap tags;
  BinaryData issuerScriptResults;
  String acquirerSpecificData;
}

class Mapper
    implements RequestResponseMapper<FinishChipRequest, FinishChipResponse> {
  static final _requestField = CompositeField([
    NumericField(1),
    NumericField(1),
    AlphanumericField(2),
    TlvFieldWithHeader(3, []),
    VariableAlphanumericField(3),
  ]);

  static final _requestTagsList = VariableBinaryField(3);
  @override
  CommandRequest mapRequest(FinishChipRequest request) {
    return CommandRequest("FNC", [
      _requestField.serialize([
        request.status.value,
        request.issuerType.value,
        request.authorizationResponseCode,
        request.tags,
        request.acquirerSpecificData,
      ]),
      _requestTagsList
          .serialize(BinaryData.fromHex(request.requiredTagsList.join())),
    ]);
  }

  @override
  FinishChipResponse mapResponse(
      FinishChipRequest request, CommandResponse result) {
    final _responseField = CompositeField([
      NumericField(1),
      TlvFieldWithHeader(3, [...request.requiredTagsList]),
      VariableBinaryField(2),
      VariableAlphanumericField(3),
    ]);

    final parsed = _responseField.parse(result.parameters[0]);
    return FinishChipResponse()
      ..decision = (parsed.data[0] as int).asFinishChipDecision
      ..tags = parsed.data[1] as TlvMap
      ..issuerScriptResults = parsed.data[2] as BinaryData
      ..acquirerSpecificData = parsed.data[3] as String;
  }
}

class FinishChipFactory {
  RequestHandler<FinishChipRequest, FinishChipResponse> finishChip(
          CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
