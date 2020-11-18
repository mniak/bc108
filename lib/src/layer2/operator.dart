import 'package:bc108/src/layer1/exports.dart';
import 'package:bc108/src/layer2/read/command_result.dart';
import 'package:bc108/src/layer2/write/command.dart';

import 'read/command_result_receiver.dart';
import 'write/command_sender.dart';

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
