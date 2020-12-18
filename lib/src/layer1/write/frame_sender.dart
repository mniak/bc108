import '../utils/bytes.dart';
import 'frame_builder.dart';

class FrameSender {
  FrameBuilder _frameBuilder;
  Sink<int> _sink;

  FrameSender(this._sink, {FrameBuilder frameBuilder}) {
    this._frameBuilder = frameBuilder ?? FrameBuilder();
  }

  void send(String payload) {
    final frame = _frameBuilder.build(payload);
    for (var byte in frame) {
      _sink.add(byte);
    }
  }

  void abort() {
    _sink.add(Byte.EOT.toInt());
  }

  void close() {
    this._sink.close();
  }
}
