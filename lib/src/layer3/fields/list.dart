import 'field.dart';
import 'field_result.dart';
import 'numeric.dart';

class ListField<TField extends Field<T>, T> implements Field<Iterable<T>> {
  NumericField _headerField;
  TField _elementField;

  ListField(int headerLength, this._elementField) {
    _headerField = NumericField(headerLength);
  }

  @override
  FieldResult<Iterable<T>> parse(String text) {
    final header = _headerField.parse(text);
    text = header.remaining;

    List<T> data = [];
    for (var i = 0; i < header.data; i++) {
      final p = _elementField.parse(text);
      data.add(p.data);
      text = p.remaining;
    }

    return FieldResult(data, text);
  }

  @override
  String serialize(Iterable<T> data) {
    final sb = StringBuffer(_headerField.serialize(data.length));
    for (var d in data) {
      sb.write(_elementField.serialize(d));
    }
    return sb.toString();
  }
}
