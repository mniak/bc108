import '../datalink/read/reader.dart';

import 'read/command_result_receiver.dart';
import 'read/command_result.dart';
import 'write/command_sender.dart';
import 'write/command.dart';

class Operator {
  CommandResultReceiver _receiver;
  CommandSender _sender;
  Operator(this._receiver, this._sender);

  Operator.fromStreamAndSink(Stream<ReaderEvent> stream, Sink<int> sink)
      : this(CommandResultReceiver.fromStream(stream),
            CommandSender.fromSink(sink));

  Future<CommandResult> execute(Command command) async {
    _sender.send(command);
    return _receiver.receive();
  }

  void close() {
    this._sender.close();
  }
}
