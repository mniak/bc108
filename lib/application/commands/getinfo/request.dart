import 'package:bc108/application/fields/numeric.dart';

class GetInfoRequest {
  int network;
  GetInfoRequest(this.network);

  static final _field = NumericField(2);

  @override
  String toString() => _field.serialize(network);
}