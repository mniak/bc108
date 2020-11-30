class AckFrame {
  bool _tryAgain = false;
  AckFrame.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  AckFrame.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  bool _ok = false;
  AckFrame.ok() {
    _ok = true;
  }
  bool get ok => _ok;

  @override
  String toString() {
    if (timeout) return "TIMEOUT";
    if (tryAgain) return "TRY_AGAIN";
    return "OK";
  }
}
