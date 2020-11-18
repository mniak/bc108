abstract class FieldException implements Exception {}

class FieldParseException implements FieldException {
  String message;
  FieldParseException(String reason) {
    this.message = reason;
  }

  FieldParseException.isNull() : this('The value provided is null.');
  FieldParseException.short(int fieldLength)
      : this(
            'The value provided is shorter than the field length ($fieldLength).');

  String toString() {
    return "FieldParseException: $message";
  }
}
