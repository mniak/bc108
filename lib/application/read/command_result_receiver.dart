import 'dart:developer';

import '../../datalink/read/reader.dart';
import '../../datalink/read/frame_receiver.dart';
import 'command_result.dart';

class CommandReceiver {
  FrameReceiver _frameReceiver;

  CommandReceiver(this._frameReceiver);
  CommandReceiver.fromStream(Stream<ReaderEvent> stream)
      : this(FrameReceiver(stream));

  Future<CommandResult> receive() async {
    final result = await _frameReceiver.receive();
    log("Command received from pinpad: '${result.data}'",
        name: 'net.mniak.bc108');
    return CommandResult.parse(result.data);
  }
}
