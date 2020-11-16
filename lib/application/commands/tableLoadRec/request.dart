import 'package:bc108/application/fields/alphanumeric.dart';
import 'package:bc108/application/fields/list.dart';

class TableLoadRecRequest {
  Iterable<String> records;

  TableLoadRecRequest(this.records);

  static final _field = new ListField(
    2,
    VariableAlphanumericField(3, true),
  );

  @override
  String toString() => _field.serialize(records);
}
