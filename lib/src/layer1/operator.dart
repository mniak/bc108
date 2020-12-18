import 'log.dart';
import 'read/frames.dart';
import '../../bc108.dart';

class Operator {
  FrameReceiver _receiver;
  FrameSender _sender;
  Operator(this._receiver, this._sender);

  Duration ackTimeout = Duration(seconds: 2);
  Duration dataTimeout = Duration(seconds: 10);

  Operator.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(FrameReceiver(stream.asEventReader()), FrameSender(sink));

  Future<UnitFrame> send(String frame) async {
    var ackResult = UnitFrame.tryAgain();
    for (var remainingTries = 3;
        ackResult.tryAgain && remainingTries > 0;
        remainingTries--) {
      _sender.send(frame);
      log("Frame sent: '$frame'");
      ackResult = await _receiver.receiveAck(ackTimeout);
    }
    return ackResult;
  }

  Future<StringFrame> receive({bool blocking = false}) async {
    final timeout = blocking == true ? Duration(days: 1) : dataTimeout;
    final frame = await _receiver.receiveData(timeout);
    log("Data frame received: $frame");
    return frame;
  }

  Future<UnitFrame> abort() async {
    var ackResult = UnitFrame.tryAgain();
    for (var remainingTries = 3;
        ackResult.tryAgain && remainingTries > 0;
        remainingTries--) {
      _sender.abort();
      log("Abortion sent");
      ackResult = await _receiver.receiveEot(ackTimeout);
    }
    return ackResult;
  }

  void close() {
    _sender.close();
  }
}
