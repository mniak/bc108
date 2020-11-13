import 'command.dart';
import 'frame_builder.dart';

class FrameSender {
  FrameBuilder _frameBuilder;
  Sink<int> _sink;

  FrameSender(this._frameBuilder, this._sink);

  void send(Command cmd) {
    final frame = _frameBuilder.build(cmd);
    for (var byte in frame) {
      _sink.add(byte);
    }
  }
}
