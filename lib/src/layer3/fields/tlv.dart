import 'package:bc108/src/layer3/fields/field.dart';
import 'package:bc108/src/layer3/fields/field_result.dart';
import 'package:bc108/src/layer3/fields/binary.dart';
import 'dart:collection';

class TlvFieldWithHeader implements Field<TlvMap> {
  VariableBinaryField _outer;
  TlvField _inner;

  TlvFieldWithHeader(int headerLength, Iterable<String> knownTags,
      {bool inclusive = false}) {
    _outer = VariableBinaryField(headerLength);
    _inner = TlvField(knownTags);
  }

  @override
  FieldResult<TlvMap> parse(String text) {
    final parsed = _outer.parse(text);
    final result = _inner.parse(parsed.data.hex);
    return FieldResult(result.data, parsed.remaining);
  }

  @override
  String serialize(TlvMap data) {
    return _outer.serialize(BinaryData.fromHex(_inner.serialize(data)));
  }
}

class TlvField implements Field<TlvMap> {
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
  FieldResult<TlvMap> parse(String text) {
    final map = Map<String, BinaryData>();
    final originalText = text;
    while (text.isNotEmpty) {
      final parsed = _parseSingleTag(text);
      text = parsed.remaining;
      if (parsed.data == null) break;
      map[parsed.data[0] as String] = parsed.data[1] as BinaryData;
    }
    final consumed =
        originalText.substring(0, originalText.length - text.length);
    return FieldResult(TlvMap(map, consumed), text);
  }

  @override
  String serialize(Map<String, BinaryData> data) =>
      data.entries.map((x) => x.key + _binaryField.serialize(x.value)).join();
}

class TlvMap extends MapBase<String, BinaryData> {
  Map<String, dynamic> _map;
  String _raw;

  TlvMap(this._map, this._raw);
  TlvMap.fromMap(this._map) {}

  TlvMap.empty() : this(Map<String, dynamic>(), "");

  String get raw => _raw;

  @override
  operator [](Object key) => _map[key];

  @override
  void operator []=(String key, value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  BinaryData remove(Object key) => _map.remove(key);
}
