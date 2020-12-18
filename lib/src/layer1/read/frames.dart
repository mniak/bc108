abstract class Frame {
  final bool tryAgain;
  final bool timeout;

  Frame({this.tryAgain = false, this.timeout = false});
}

class DataFrame<T> extends Frame {
  final T data;

  DataFrame.tryAgain()
      : data = null,
        super(tryAgain: true);

  DataFrame.timeout()
      : data = null,
        super(timeout: true);

  DataFrame.data(this.data);

  @override
  String toString() {
    if (timeout) return "TIMEOUT";
    if (tryAgain) return "TRY_AGAIN";
    return "'$data'";
  }

  bool get hasData => data != null;
}

class StringFrame extends DataFrame<String> {
  StringFrame.tryAgain() : super.tryAgain();
  StringFrame.timeout() : super.timeout();
  StringFrame.data(String data) : super.data(data) {
    if (data == null) throw ArgumentError.notNull('data');
  }
}

class UnitFrame extends DataFrame<void> {
  final bool ok;

  UnitFrame.tryAgain()
      : ok = false,
        super.tryAgain();
  UnitFrame.timeout()
      : ok = false,
        super.timeout();
  UnitFrame.ok()
      : ok = true,
        super.data(null);
}
