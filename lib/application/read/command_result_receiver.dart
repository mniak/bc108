import 'package:bc108/datalink/read/reader.dart';

import '../../datalink/read/frame_receiver.dart';
import 'command_result.dart';

class CommandReceiver {
  FrameReceiver _frameReceiver;

  CommandReceiver(this._frameReceiver);
  CommandReceiver.fromStream(Stream<ReaderEvent> stream)
      : this(FrameReceiver(stream));

  Future<CommandResult> receive() async {
    final result = await _frameReceiver.receive();
    //TODO: check other cases (timeout, aborted...)
    return CommandResult.parse(result.data);
  }
}
