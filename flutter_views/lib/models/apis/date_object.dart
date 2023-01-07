import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DateObject {
  String from;
  String to;

  DateObject({this.from = "", this.to = ""}) {
    from = from.isEmpty ? "".toDateTimeNowString() : from;
    to = to.isEmpty ? "".toDateTimeNowString() : to;
  }
  factory DateObject.fromJson(Map<String, dynamic> data) => DateObject()
    ..from = data["from"] as String
    ..to = data["to"] as String;

  String getTitle(BuildContext context) {
    String title = "";
    if (from == to && from == "".toDateTimeOnlyDateString()) {
      title = AppLocalizations.of(context)!.today;
    }
    title = AppLocalizations.of(context)!.customDate;
    return title;
  }

  String getDate(BuildContext context) {
    String date;
    if (from == to) {
      date = DateFormat.yMMMEd().format(from.toDateTimeOnlyDate());
    }
    if (from != "" && to != "") {
      date =
          "${DateFormat.yMMMEd().format(from.toDateTimeOnlyDate())}  -  ${DateFormat.yMMMEd().format(to.toDateTimeOnlyDate())}  ";
    } else if (from != "") {
      date =
          "${AppLocalizations.of(context)!.from} ${DateFormat.yMMMEd().format(from.toDateTimeOnlyDate())}";
    } else {
      date =
          "${AppLocalizations.of(context)!.to} ${DateFormat.yMMMEd().format(to.toDateTimeOnlyDate())}";
    }
    return date;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => {"""from""": from, """to""": to};
}
