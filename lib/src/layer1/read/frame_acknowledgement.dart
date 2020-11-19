//TODO: rename to AcknowledgementFrame
class FrameAcknowledgement {
  bool _tryAgain = false;
  FrameAcknowledgement.tryAgain() {
    this._tryAgain = true;
  }
  bool get tryAgain => _tryAgain;

  bool _timeout = false;
  FrameAcknowledgement.timeout() {
    this._timeout = true;
  }
  bool get timeout => _timeout;

  bool _ok = false;
  FrameAcknowledgement.ok() {
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
