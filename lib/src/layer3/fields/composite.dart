import '../fields/field.dart';
import '../fields/field_result.dart';
import 'exceptions.dart';

class CompositeField<T> implements Field<List<T>> {
  Iterable<Field> _fields;
  CompositeField(this._fields);

  @override
  FieldResult<List<T>> parse(String text) {
    final data = _fields.map((f) {
      final result = f.parse(text);
      text = result.remaining;
      return result.data;
    }).toList();
    return FieldResult(data, text);
  }

  String serialize(Iterable<T> values) {
    if (values.length != _fields.length)
      throw FieldSerializeException(
          'The number of values must be the same the number of fields provided in the constructor.');

    final itf = _fields.iterator;
    final itv = values.iterator;

    final sb = StringBuffer();

    while (itf.moveNext() && itv.moveNext()) {
      final f = itf.current;
      final v = itv.current;

      sb.write(f.serialize(v));
    }

    return sb.toString();
  }
}
