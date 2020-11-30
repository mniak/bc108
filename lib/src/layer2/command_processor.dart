import 'dart:async';

import 'package:bc108/bc108.dart';
import 'package:bc108/src/layer1/operator.dart';
import 'package:bc108/src/layer2/command_request.dart';
import 'package:bc108/src/layer2/command_response.dart';

import 'log.dart';

class CommandProcessor {
  Operator _operator;
  StreamController<String> _notificationController = StreamController<String>();

  Stream<String> get notifications => _notificationController.stream;

  CommandProcessor(this._operator);

  CommandProcessor.fromStreamAndSink(Stream<int> stream, Sink<int> sink)
      : this(Operator.fromStreamAndSink(stream, sink));

  Future<CommandResponse> send(CommandRequest request, {bool blocking}) async {
    final ackFrame = await _operator.send(request.payload);
    if (ackFrame.tryAgain)
      return CommandResponse.fromStatus(Status.PP_COMMERR, request.code);
    if (ackFrame.timeout)
      return CommandResponse.fromStatus(Status.PP_COMMTOUT, request.code);

    CommandResponse response;
    do {
      final frameResult = await _operator.receive(blocking: blocking);
      response = CommandResponse.fromDataFrame(frameResult);
      if (response.code == "NTM") {
        final message = response.parameters[0];
        log('Notification received: $message');
        _notificationController.sink.add(message);
      } else {
        log('Command response received: ${response.code} ${response.status} ${response.parameters.join(", ")}');
        return response;
      }
    } while (true);
  }

  void close() {
    _operator.close();
    _notificationController.close();
  }
}
