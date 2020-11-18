import 'dart:async';

import 'frame_receiver.dart';
import 'frame_result.dart';

class FrameReceiverWithRetry implements FrameReceiver {
  FrameReceiver _inner;
  FrameReceiverWithRetry(this._inner);

  @override
  Future<FrameResult> receiveNonBlocking() async {
    var result = FrameResult.tryAgain();
    for (var remainingTries = 3;
        result.tryAgain && remainingTries > 0;
        remainingTries--) {
      result = await _inner.receiveNonBlocking();
    }

    return result;
  }
}
