import 'package:bc108/src/layer1/read/ack_frame.dart';
import 'package:bc108/src/layer1/read/result_frame.dart';

import 'status.dart';
import 'exceptions.dart';

class CommandResponse {
  String _code;
  Status _status;
  Iterable<String> _parameters;

  String get code => _code;
  Status get status => _status;
  List<String> get parameters => List.of(_parameters);

  CommandResponse.fromStatus(Status status, [String code = "ERR"]) {
    _code = code;
    _status = status;
    _parameters = [];
  }
  factory CommandResponse.fromResultFrame(ResultFrame frame) {
    if (frame.tryAgain) return CommandResponse.fromStatus(Status.PP_COMMERR);
    if (frame.timeout) return CommandResponse.fromStatus(Status.PP_COMMTOUT);
    return CommandResponse.parse(frame.data);
  }

  factory CommandResponse.fromAckFrame(AckFrame frame) {
    if (frame.tryAgain) return CommandResponse.fromStatus(Status.PP_COMMERR);
    if (frame.timeout) return CommandResponse.fromStatus(Status.PP_COMMTOUT);
    return CommandResponse.fromStatus(Status.PP_OK);
  }

  CommandResponse.parse(String payload) {
    if (payload == null)
      throw CommandResponseParseException("The payload must cannot be null.");

    final pattern = RegExp(r"(\w{3})(\d{3})");
    final match = pattern.matchAsPrefix(payload);
    if (match == null) {
      throw CommandResponseParseException(
          "Could not find the command code or the status code.");
    }

    this._code = match.group(1);
    this._status = int.parse(match.group(2)).toStatus();

    String remaining = payload.substring(6);
    final params = List<String>();
    while (remaining.isNotEmpty && remaining.length >= 3) {
      final size = int.tryParse(remaining.substring(0, 3));
      remaining = remaining.substring(3);
      if (size == null || size < 0)
        throw CommandResponseParseException(
            "The size of a parameter is invalid: '$size'.");

      if (size > remaining.length)
        throw CommandResponseParseException(
            "The size of a parameter is greater than the remaining count: '$size' > ${remaining.length}.");

      final param = remaining.substring(0, size);
      params.add(param);
      remaining = remaining.substring(size);
    }

    if (remaining.isNotEmpty) {
      throw CommandResponseParseException(
          "The payload still has data after all the parameters were parsed.");
    }

    this._parameters = params;
  }
}
