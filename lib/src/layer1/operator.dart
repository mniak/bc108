import 'log.dart';
import 'read/ack_frame.dart';
import 'read/result_frame.dart';
import '../../bc108.dart';

class Operator {
  FrameReceiver _receiver;
  FrameSender _sender;
  Operator(this._receiver, this._sender);

  Duration ackTimeout = Duration(seconds: 2);
  Duration dataTimeout = Duration(seconds: 10);

  Operator.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(FrameReceiver(stream.asEventReader()), FrameSender(sink));

  Future<AckFrame> send(String frame) async {
    var ackResult = AckFrame.tryAgain();
    for (var remainingTries = 3;
        ackResult.tryAgain && remainingTries > 0;
        remainingTries--) {
      _sender.send(frame);
      log("Frame sent: '$frame'");
      ackResult = await _receiver.receiveAck(ackTimeout);
    }
    return ackResult;
  }

  Future<DataFrame> receive({bool blocking}) async {
    final timeout = blocking == true ? Duration(days: 1) : dataTimeout;
    final frame = await _receiver.receiveData(timeout);
    log("Data frame received: $frame");
    return frame;
  }

  void close() {
    _sender.close();
  }
}
