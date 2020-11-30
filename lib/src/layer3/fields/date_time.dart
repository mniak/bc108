import 'fixed_length.dart';

class DateTimeField extends FixedLengthField<DateTime> {
  DateTimeField() : super(6);

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
    final year = int.parse(text.substring(0, 2));
    final month = int.parse(text.substring(2, 4));
    final day = int.parse(text.substring(4, 6));
    final hour = int.parse(text.substring(6, 8));
    final minute = int.parse(text.substring(8, 10));
    final second = int.parse(text.substring(10, 12));

    return DateTime(year, month, day, hour, minute, second);
  }
}
