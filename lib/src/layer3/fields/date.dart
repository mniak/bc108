import 'fixed_length.dart';

class DateField extends FixedLengthField<DateTime> {
  DateField() : super(6);

  @override
  String serialize(DateTime data) {
    return (data.year % 100).toString().padLeft(2, '0') +
        data.month.toString().padLeft(2, '0') +
        data.day.toString().padLeft(2, '0');
  }

  @override
  DateTime simpleParse(String text) {
    var year = int.parse(text.substring(0, 2));
    final yearNow = DateTime.now().year;
    if (year < 1950) year += 1900;
    while (yearNow - year >= 100) year += 100;

    final month = int.parse(text.substring(2, 4));
    final day = int.parse(text.substring(4, 6));

    return DateTime(year, month, day);
  }
}
