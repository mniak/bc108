library pinpad;

enum _ReaderStage {
  Initial,
  Payload,
  CRC1,
  CRC2,
}

class ReaderState {
  final payload = List<int>();
  _ReaderStage stage;
  int crc1;

  ReaderState() {
    this.reset();
  }

  void reset() {
    this.payload.clear();
    this.stage = _ReaderStage.Initial;
  }
}

class ReaderEvent {
  String _data;
  ReaderEvent.data(String data) {
    if (data == null) throw ArgumentError.notNull('data');
    this._data = data;
  }
  bool get isDataEvent => this._data != null;
  String get data => this._data;

  int _interrupt;
  ReaderEvent.ack() {
    this._interrupt = 1;
  }
  bool get ack => this._interrupt == 1;
  ReaderEvent.nak() {
    this._interrupt = 2;
  }
  bool get nak => this._interrupt == 2;
}
