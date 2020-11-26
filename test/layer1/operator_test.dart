import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer1/read/frame_receiver.dart';
import 'package:bc108/src/layer1/read/frame_result.dart';
import 'package:bc108/src/layer1/write/frame_sender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FrameReceiverMock extends Mock implements FrameReceiver {}

class FrameSenderMock extends Mock implements FrameSender {}

class SUT {
  FrameReceiver receiver;
  FrameSender sender;
  Operator oper;
  SUT() {
    receiver = FrameReceiverMock();
    sender = FrameSenderMock();
    oper = Operator(receiver, sender);
  }
}

void main() {
  // test('when send then receive NAK, should return try again', () async {
  //   final sut = SUT();
  //   when(sut.receiver.receive()).thenReturn(() => Future.value(FrameResult.tryAgain())).controller.sink.add(ReaderEvent.nak());
  //   final result = await sut.receiver.receive();

  //   expect(result, isNotNull);
  //   expect(result.timeout, isFalse);
  //   expect(result.tryAgain, isTrue);
  //   expect(result.isDataResult, isFalse);
  //   expect(result.data, isNull);
  // });
}
