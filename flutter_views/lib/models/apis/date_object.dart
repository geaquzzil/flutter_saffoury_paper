import 'package:flutter_view_controller/ext_utils.dart';

class DateObject {
  String from;
  String to;

  DateObject({this.from = "", this.to = ""}) {
    from = from.isEmpty ? "".toDateTimeFirstDateYearString() : from;
    to = to.isEmpty ? "".toDateTimeNowString() : to;
  }
  factory DateObject.fromJson(Map<String, dynamic> data) => DateObject()
    ..from = data["from"] as String
    ..to = data["to"] as String;

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => {"""from""": from, """to""": to};
}
