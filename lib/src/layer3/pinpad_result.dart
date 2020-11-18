import 'package:bc108/src/layer2/exports.dart';

class PinpadResult<T> {
  Status _status;
  T _data;

  Status get status => _status;
  T get data => _data;

  PinpadResult(this._status, this._data);
}
