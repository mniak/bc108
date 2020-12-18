class ReaderEvent {
  final String data;
  final int _interrupt;

  ReaderEvent.data(this.data) : _interrupt = 0 {
    if (data == null) throw ArgumentError.notNull('data');
  }
  bool get isDataEvent => this.data != null;

  ReaderEvent.ack()
      : _interrupt = 1,
        data = null;
  bool get ack => this._interrupt == 1;

  ReaderEvent.nak()
      : _interrupt = 2,
        data = null;
  bool get nak => this._interrupt == 2;

  ReaderEvent.badCRC()
      : _interrupt = 3,
        data = null;
  bool get badCRC => this._interrupt == 3;

  ReaderEvent.aborted()
      : _interrupt = 4,
        data = null;
  bool get aborted => this._interrupt == 4;
}
