import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:bc108/bc108.dart';

class CommandEvent {}

class Acknowledgement {
  bool _ack;
  bool _nak;
  Acknowledgement.ack() {
    _ack = true;
  }
  Acknowledgement.nak() {
    _nak = true;
  }

  bool get ack => _ack;
  bool get nak => _nak;
}

extension EventReaderExtension on Stream<ReaderEvent> {
  Stream<CommandResult> commandResults() {
    return this
        .where((e) => e.isDataEvent)
        .map((e) => CommandResult.parse(e.data));
  }

  Stream<Acknowledgement> acknowledgements() {
    return this.where((e) => !e.isDataEvent).map((e) {
      if (e.ack)
        return Acknowledgement.ack();
      else
        return Acknowledgement.nak();
    });
  }
}
