import 'package:bc108/src/layer3/fields/field.dart';
import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/hexadecimal.dart';

class TlvField implements Field<Map<String, Iterable<int>>> {
  List<String> _knownTags;
  TlvField(Iterable<String> knownTags) {
    _knownTags = List.from(knownTags);
    _knownTags.sort((a, b) => b.length - a.length);
  }

  static final _binaryField = VariableBinaryField(2);

  FieldResult<List<dynamic>> _parseSingleTag(String text) {
    for (var tag in _knownTags) {
      if (text.startsWith(tag)) {
        final parsedBin = _binaryField.parse(text.substring(tag.length));
        return FieldResult([
          tag,
          parsedBin.data,
        ], parsedBin.remaining);
      }
    }
    return FieldResult(null, text);
  }

  @override
  FieldResult<Map<String, Iterable<int>>> parse(String text) {
    final result = Map<String, Iterable<int>>();
    while (text.isNotEmpty) {
      final parsed = _parseSingleTag(text);
      text = parsed.remaining;
      if (parsed.data == null) break;
      result[parsed.data[0] as String] = parsed.data[1] as Iterable<int>;
    }
    return FieldResult(result, text);
  }

  @override
  String serialize(Map<String, Iterable<int>> data) =>
      data.entries.map((x) => x.key + _binaryField.serialize(x.value)).join();
}
