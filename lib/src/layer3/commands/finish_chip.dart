import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/fields/alphanumeric.dart';
import 'package:bc108/src/layer3/fields/composite.dart';
import 'package:bc108/src/layer3/fields/numeric.dart';
import 'package:bc108/src/layer3/fields/field.dart';
import '../handler.dart';
import '../mapper.dart';
import '../fields/tlv.dart';

class FinishChipRequest {
  bool communicationSuccessful = false;
  int issuerType = 0;
  String authorizationResponseCode = "";
  TlvMap tags = TlvMap.empty();
  String acquirerSpecificData = "";

  List<String> tagList = [];
}

class FinishChipResponse {}

class Mapper
    implements RequestResponseMapper<FinishChipRequest, FinishChipResponse> {
  @override
  static final _requestField = CompositeField([
    NumericField(1),
    NumericField(1),
    AlphanumericField(2),
    TlvField([]).withHeader(3, (x) => x.length),
  ]);
  CommandRequest mapRequest(FinishChipRequest request) {
    return CommandRequest("FNC", []);
  }

  @override
  FinishChipResponse mapResponse(
      FinishChipRequest request, CommandResponse result) {
    return FinishChipResponse();
  }
}

class FinishChipChipFactory {
  RequestHandler<FinishChipRequest, FinishChipResponse> finishChip(
          CommandProcessor o) =>
      RequestHandler.fromMapper(o, Mapper());
}
