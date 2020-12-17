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
        super(tryAgain: true);

  DataFrame.data(T data) : data = data;

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

class UnitFrame extends DataFrame<bool> {
  UnitFrame.tryAgain() : super.tryAgain();
  UnitFrame.timeout() : super.timeout();
  UnitFrame.ok() : super.data(true);
}
