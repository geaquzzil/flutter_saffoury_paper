import 'package:flutter_view_controller/ext_utils.dart';
import 'package:json_annotation/json_annotation.dart';

class DateObject {
  String from;
  String to;

  DateObject({this.from = "", this.to = ""}) {
    from = "".toDateTimeFirstDateYearString();
    to = "".toDateTimeNowString();
  }
  factory DateObject.fromJson(Map<String, dynamic> data) => DateObject()
    ..from = data["from"] as String
    ..to = data["to"] as String;

  Map<String, dynamic> toJson() =>
      {"""from""": """$from""", """to""": """$to"""};
}
