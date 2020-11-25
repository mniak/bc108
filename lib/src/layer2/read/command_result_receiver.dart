// import 'dart:async';

// import 'package:bc108/bc108.dart';
// import 'package:bc108/src/layer1/exports.dart';

// import '../../log.dart';
// import '../status.dart';
// import 'command_result.dart';

// class CommandResultReceiver {
//   FrameReceiver _frameReceiver;

//   CommandResultReceiver(this._frameReceiver);
//   CommandResultReceiver.fromStream(Stream<ReaderEvent> stream)
//       : this(FrameReceiverWithRetry(FrameReceiver(stream)));

//   Future<CommandResult> receiveAcknowledgementAndData() async {
//     final result = await _frameReceiver.receiveNonBlocking();
//     log("Command result received: $result");
//     return CommandResult.fromResultFrame(result);
//   }

//   Future<CommandResult> receiveAcknowledgement() async {
//     final result = await _frameReceiver.receiveAcknowledgement();
//     log("Acknowledgement received: $result");
//     return CommandResult.fromResultFrame(result);
//   }

//   Future withNotificationCallback(
//       NotificationCallback notificationCallback, void Function() action) {
//     action();
//   }
// }
