import 'package:bc108/datalink/read/receiver.dart';

import 'read/reader.dart';
import 'write/frame_sender.dart';
import 'write/command.dart';

class CommandResult {
  bool _aborted = false;
  String _abortMessage;
  CommandResult.aborted(String message) {
    this._aborted = true;
    this._abortMessage = message;
  }
  bool get aborted => _aborted;
  String get abortMessage => _abortMessage;

  bool _timeout = false;
  CommandResult.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  String _data;
  CommandResult.data(String data) {
    this._data = data;
  }
  bool get isDataResult => _data != null;
  String get data => _data;
}

class Operator {
  Receiver _receiver;
  FrameSender _sender;
  Operator(this._receiver, this._sender);

  Operator.fromStreamAndSink(Stream<ReaderEvent> stream, Sink<int> sink)
      : this(Receiver(stream), FrameSender(sink));

  Future<ReceiverResult> _sendAndReceive(Command cmd) async {
    _sender.send(cmd);
    final result = await _receiver.receive();
    return result;
  }

  Future<CommandResult> execute(Command cmd) async {
    int retryCount = 3;
    ReceiverResult recv;
    do {
      recv = await _sendAndReceive(cmd);
    } while (retryCount > 0 && recv.tryAgain);

    if (recv.tryAgain) {
      return CommandResult.aborted('received NAK 3 times');
    }
    if (recv.timeout) {
      return CommandResult.timeout();
    }

    return CommandResult.data(recv.data);
  }

  void close() {
    this._sender.close();
  }
}
