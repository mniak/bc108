import 'dart:async';

import '../../datalink/read/reader.dart';
import '../../datalink/read/frame_receiver.dart';
import '../../log.dart';

import 'command_result_receiver_exceptions.dart';
import 'command_result.dart';

class CommandReceiver {
  FrameReceiver _frameReceiver;

  CommandReceiver(this._frameReceiver);
  CommandReceiver.fromStream(Stream<ReaderEvent> stream)
      : this(FrameReceiver(stream));

  Future<CommandResult> receive() async {
    final result = await _frameReceiver.receiveNonBlocking();
    log("Command received from pinpad: '${result.data}'");
    if (result.tryAgain) throw new CommandAbortedException('received NAK');
    if (result.timeout) throw new TimeoutException('timeout');
    return CommandResult.parse(result.data);
  }
}
