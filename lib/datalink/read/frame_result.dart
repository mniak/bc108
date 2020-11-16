class FrameResult {
  bool _tryAgain = false;
  FrameResult.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  FrameResult.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  String _data;
  FrameResult.data(String data) {
    if (data == null) throw ArgumentError.notNull('data');
    this._data = data;
  }
  bool get isDataResult => _data != null;
  String get data => _data;
}
