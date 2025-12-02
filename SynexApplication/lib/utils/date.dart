import 'package:intl/intl.dart';

class DateHelper {
  static String formatMessageDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeFormat = DateFormat('HH:mm');

    if (messageDate == today) {
      // Bugün
      return timeFormat.format(dateTime);
    } else if (messageDate == yesterday) {
      // Dün
      return 'Dün ${timeFormat.format(dateTime)}';
    } else {
      // Daha eski
      final dateFormat = DateFormat('d.M.yyyy');
      return '${timeFormat.format(dateTime)} - ${dateFormat.format(dateTime)}';
    }
  }
}
