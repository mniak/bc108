import 'dart:async';

import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/operator_L1.dart';
import 'package:bc108/src/layer2/read/command_result.dart';
import 'package:bc108/src/layer2/write/command.dart';

class Operator {
  OperatorL1 _operatorL1;
  StreamController<String> _notificationController = StreamController<String>();

  Stream<String> get notifications => _notificationController.stream;

  Operator(this._operatorL1);

  Operator.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(OperatorL1.fromStreamAndSink(stream, sink));

  // Future<CommandResult> _send(Command command) async {
  //   final result = await _operatorL1.send(command.payload);
  //   return CommandResult.fromAcknowledgementFrame(result);
  // }

  Future<CommandResult> _receive() async {
    CommandResult result;
    do {
      final frameResult = await _operatorL1.receive();
      result = CommandResult.parse(frameResult.data);
      if (result.code == "NTM") {
        _notificationController.sink.add(result.parameters[0]);
      } else {
        return result;
      }
    } while (true);
  }

  Future<CommandResult> send(Command command) async {
    final ackFrame = await _operatorL1.send(command.payload);
    if (ackFrame.tryAgain) return CommandResult.fromStatus(Status.PP_COMMERR);
    if (ackFrame.timeout) return CommandResult.fromStatus(Status.PP_COMMTOUT);

    final result = _receive();
    return result;
  }

  void close() {
    _operatorL1.close();
    _notificationController.close();
  }
}
