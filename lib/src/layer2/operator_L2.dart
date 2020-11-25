import 'dart:async';

import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/operator_l1.dart';
import 'package:bc108/src/layer2/read/command_result.dart';
import 'package:bc108/src/layer2/write/command.dart';

import '../log.dart';

class OperatorL2 {
  OperatorL1 _operatorL1;
  StreamController<String> _notificationController = StreamController<String>();

  Stream<String> get notifications => _notificationController.stream;

  OperatorL2(this._operatorL1);

  OperatorL2.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(OperatorL1.fromStreamAndSink(stream, sink));

  // Future<CommandResult> _send(Command command) async {
  //   log("Command sent: '${command.payload}'");
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

  Future<CommandResult> sendNonBlocking(Command command) async {
    log("Command sent: '${command.payload}'");
    final ackFrame = await _operatorL1.send(command.payload);
    if (ackFrame.tryAgain) return CommandResult.fromStatus(Status.PP_COMMERR);
    if (ackFrame.timeout) return CommandResult.fromStatus(Status.PP_COMMTOUT);

    final result = _receive();
    return result;
  }

  Future<CommandResult> sendBlocking(Command command) async {
    log("Command sent: '${command.payload}'");
    final ackFrame = await _operatorL1.send(command.payload);
    if (ackFrame.tryAgain) return CommandResult.fromStatus(Status.PP_COMMERR);
    if (ackFrame.timeout) return CommandResult.fromStatus(Status.PP_COMMTOUT);

    final secondCommand = Command(command.code, []);
    await _operatorL1.send(secondCommand.payload);
    if (ackFrame.tryAgain) return CommandResult.fromStatus(Status.PP_COMMERR);
    if (ackFrame.timeout) return CommandResult.fromStatus(Status.PP_COMMTOUT);

    CommandResult result;
    bool first = true;
    do {
      if (first)
        first = false;
      else
        await Future.delayed(Duration(milliseconds: 100));
      result = await _receive();
    } while (result.status == Status.PP_PROCESSING);
    return result;
  }

  void close() {
    _operatorL1.close();
    _notificationController.close();
  }
}
