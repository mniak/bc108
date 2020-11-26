import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/read/ack_frame.dart';
import 'package:bc108/src/layer1/read/result_frame.dart';

import '../log.dart';

class Operator {
  FrameReceiver _receiver;
  FrameSender _sender;
  Operator(this._receiver, this._sender);

  Operator.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(FrameReceiver(stream.asEventReader()), FrameSender(sink));

  Future<AckFrame> send(String frame) async {
    var ackResult = AckFrame.tryAgain();

    log("Frame sent: '$frame'");

    for (var remainingTries = 3;
        ackResult.tryAgain && remainingTries > 0;
        remainingTries--) {
      _sender.send(frame);
      ackResult = await _receiver.receiveAck();
    }
    return ackResult;
  }

  Future<ResultFrame> receive() async {
    final frame = await _receiver.receive();
    log("Data frame received: $frame");
    return frame;
  }

  void close() {
    _sender.close();
  }
}
