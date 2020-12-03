import 'fixed_length.dart';

class DateTimeField extends FixedLengthField<DateTime> {
  DateTimeField() : super(12);

  @override
  String serialize(DateTime data) {
    return (data.year % 100).toString().padLeft(2, '0') +
        data.month.toString().padLeft(2, '0') +
        data.day.toString().padLeft(2, '0') +
        data.hour.toString().padLeft(2, '0') +
        data.minute.toString().padLeft(2, '0') +
        data.second.toString().padLeft(2, '0');
  }

  @override
  DateTime simpleParse(String text) {
    var year = int.parse(text.substring(0, 2));
    final yearNow = DateTime.now().year;
    if (year < 1950) year += 1900;
    while (yearNow - year >= 100) year += 100;

    final month = int.parse(text.substring(2, 4));
    final day = int.parse(text.substring(4, 6));
    final hour = int.parse(text.substring(6, 8));
    final minute = int.parse(text.substring(8, 10));
    final second = int.parse(text.substring(10, 12));

    return DateTime(year, month, day, hour, minute, second);
  }
}
