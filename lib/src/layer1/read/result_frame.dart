class DataFrame {
  bool _tryAgain = false;
  DataFrame.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  DataFrame.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  String _data;
  DataFrame.data(String data) {
    if (data == null) throw ArgumentError.notNull('data');
    this._data = data;
  }
  bool get hasData => _data != null;
  String get data => _data;

  @override
  String toString() {
    if (timeout) return "TIMEOUT";
    if (tryAgain) return "TRY_AGAIN";
    return "'$data'";
  }
}
