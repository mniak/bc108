import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/read/frame_acknowledgement.dart';
import 'package:bc108/src/layer1/read/frame_result.dart';

class OperatorL1 {
  FrameReceiver _receiver;
  FrameSender _sender;
  OperatorL1(this._receiver, this._sender);

  OperatorL1.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(FrameReceiver(stream.asEventReader()), FrameSender(sink));

  Future<FrameAcknowledgement> send(String frame) async {
    var ackResult = FrameAcknowledgement.tryAgain();

    for (var remainingTries = 3;
        ackResult.tryAgain && remainingTries > 0;
        remainingTries--) {
      _sender.send(frame);
      ackResult = await _receiver.receiveAcknowledgement();
    }
    return ackResult;
  }

  Future<FrameResult> receive() async {
    return await _receiver.receiveData();
  }

  void close() {
    _sender.close();
  }
}
