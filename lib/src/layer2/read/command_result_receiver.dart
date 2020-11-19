import 'dart:async';

import 'package:bc108/src/layer1/exports.dart';

import '../../log.dart';
import '../status.dart';
import 'command_result.dart';

class CommandResultReceiver {
  FrameReceiver _frameReceiver;

  CommandResultReceiver(this._frameReceiver);
  CommandResultReceiver.fromStream(Stream<ReaderEvent> stream)
      : this(FrameReceiverWithRetry(FrameReceiver(stream)));

  Future<CommandResult> receive() async {
    final result = await _frameReceiver.receiveNonBlocking();
    log("Command Received: '${result.data}'");
    if (result.tryAgain) return CommandResult.fromStatus(Status.PP_COMMERR);
    if (result.timeout) return CommandResult.fromStatus(Status.PP_COMMTOUT);
    return CommandResult.parse(result.data);
  }
}
