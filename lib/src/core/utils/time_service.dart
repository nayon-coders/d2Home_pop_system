import 'package:intl/intl.dart';

abstract class TimeService {
  TimeService._();

  static DateTime dateFormatYMD(DateTime? time) {
    return DateTime.tryParse(
            DateFormat("yyyy-MM-dd").format(time ?? DateTime.now())) ??
        DateTime.now();
  }

  static String dateFormatMDYHm(DateTime? time) {
    return DateFormat("MMM d, yyyy - HH:mm").format(time ?? DateTime.now());
  }

  static String dateFormatYMDHm(DateTime? time) {
    return DateFormat("yyyy-MM-dd HH:mm").format(time ?? DateTime.now());
  }

  static String dateFormatMDHm(DateTime? time) {
    return DateFormat("MMM d, HH:mm").format(time ?? DateTime.now());
  }

  static String dateFormatDMY(DateTime? time) {
    return DateFormat("d MMM, yyyy").format(time ?? DateTime.now());
  }

  static String dateFormatDM(DateTime? time) {
    if (DateTime.now().year == time?.year) {
      return DateFormat("d MMMM").format(time ?? DateTime.now());
    }
    return DateFormat("d MMMM, yyyy").format(time ?? DateTime.now());
  }

  static String dateFormatHM(DateTime? time) {
    return DateFormat("HH:mm").format(time ?? DateTime.now());
  }

  static String dateFormatWDM(DateTime? time) {
    return DateFormat("EEE, d MMM").format(time ?? DateTime.now());
  }

  static String dateFormatForChat(DateTime? time) {
    if ((DateTime.now().difference(time ?? DateTime.now()).inHours) > 24 &&
        (DateTime.now().difference(time ?? DateTime.now()).inDays) < 7) {
      return DateFormat("EEEE").format(time ?? DateTime.now());
    }
    if ((DateTime.now().difference(time ?? DateTime.now()).inDays) > 7) {
      return DateFormat("MMM/d/yyyy").format(time ?? DateTime.now());
    }
    return DateFormat("HH:mm").format(time ?? DateTime.now());
  }

  static String dateFormatForNotification(DateTime? time) {
    return DateFormat("d MMM, h:mm a").format(time ?? DateTime.now());
  }

  static String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  static String timeFormat(DateTime? time) {
    return DateFormat("HH:mm").format(time ?? DateTime.now());
  }
}
