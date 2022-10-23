import 'package:json_annotation/json_annotation.dart';

class GrowthRate {
  int? year;
  int? month;
  int? day;
  @JsonKey(fromJson: convertToDouble)
  double? total;
  GrowthRate();

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());

  factory GrowthRate.fromJson(Map<String, dynamic> data) => GrowthRate()
    ..total = GrowthRate.convertToDouble(data["total"])
    ..day = data["day"] as int?
    ..month = data["month"] as int?
    ..year = data["year"] as int?;

  Map<String, dynamic> toJson() => {};
}
