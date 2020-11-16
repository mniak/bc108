import 'package:bc108/datalink/write/frame_builder.dart';

import '../../datalink/write/frame_sender.dart';
import 'command.dart';

class CommandSender {
  FrameSender _frameSender;
  CommandSender(this._frameSender);
  CommandSender.fromSink(Sink<int> sink, {FrameBuilder frameBuilder}) {
    this._frameSender = FrameSender(sink, frameBuilder: frameBuilder);
  }

  void send(Command command) {
    _frameSender.send(command.payload);
  }

  void close() {
    this._frameSender.close();
  }
}
