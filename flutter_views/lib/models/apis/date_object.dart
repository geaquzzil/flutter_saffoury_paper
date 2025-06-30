import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:intl/intl.dart';

class DateObject {
  String from;
  String to;

  DateObject({this.from = "", this.to = ""}) {
    from = from.isEmpty ? "".toDateTimeNowString() : from;
    to = to.isEmpty ? "".toDateTimeNowString() : to;
  }
  DateObject.initFirstDateOfYear({this.from = "", this.to = ""}) {
    from = "".toDateTimeFirstDateYearString();
    to = "".toDateTimeNowString();
  }
  DateObject.initThisWeek({this.from = "", this.to = ""}) {
    from = findFirstDateOfTheWeek(DateTime.now()).toDateTimeStringOnlyDate();
    to = findLastDateOfTheWeek(DateTime.now()).toDateTimeStringOnlyDate();
  }
  DateObject.initThisMonth({this.from = "", this.to = ""}) {
    from = findFirstDateOfTheMonth(DateTime.now()).toDateTimeStringOnlyDate();
    to = findLastDateOfTheMonth(DateTime.now()).toDateTimeStringOnlyDate();
  }
  DateObject.initFromDateTime(DateTime date,
      {DateTime? toDate, this.from = "", this.to = ""}) {
    from = date.toDateTimeStringOnlyDate();
    to = toDate?.toDateTimeStringOnlyDate() ?? date.toDateTimeStringOnlyDate();
  }
  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  static DateTime fromDateObject(DateObject dateObject) {
    return dateObject.from.toDateTime();
  }

  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static DateObject today() {
    return DateObject();
  }

  factory DateObject.fromJson(Map<String, dynamic> data) => DateObject()
    ..from = data["from"] as String
    ..to = data["to"] as String;

  String getTitle(BuildContext context) {
    String title = "";
    if (from == to && from == "".toDateTimeOnlyDateString()) {
      title = AppLocalizations.of(context)!.today;
    }
    if (from == to && to == from && from == "".toDateTimeOnlyDateString()) {
      title = AppLocalizations.of(context)!.today;
    } else {
      title = AppLocalizations.of(context)!.customDate;
    }
    return title;
  }

  String getDate(BuildContext context) {
    String date;
    if (from == to) {
      debugPrint("getDate from==to");
      date = DateFormat.yMMMEd().format(from.toDateTimeOnlyDate());
    } else {
      if (from != "" && to != "") {
        debugPrint("getDate from != " " && to != " "");
        date =
            "${DateFormat.yMMMEd().format(from.toDateTimeOnlyDate())}\n${DateFormat.yMMMEd().format(to.toDateTimeOnlyDate())}  ";
      } else if (from != "") {
        date =
            "${AppLocalizations.of(context)!.from} ${DateFormat.yMMMEd().format(from.toDateTimeOnlyDate())}";
      } else {
        date =
            "${AppLocalizations.of(context)!.to} ${DateFormat.yMMMEd().format(to.toDateTimeOnlyDate())}";
      }
    }
    return date;
  }

  bool isEqual(DateObject? object) {
    if (object == null) return false;
    return (from + to) == (object.from + object.to);
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => {"""from""": from, """to""": to};
}
