import 'package:bc108/application/fields/numeric.dart';
import 'package:bc108/application/fields/composite.dart';

class TableLoadInitRequest {
  int network;
  int timestamp;

  TableLoadInitRequest(this.network, this.timestamp);

  static final _field = new CompositeField([
    NumericField(2),
    NumericField(10),
  ]);

  @override
  String toString() => _field.serialize([
        network,
        timestamp,
      ]);
}
