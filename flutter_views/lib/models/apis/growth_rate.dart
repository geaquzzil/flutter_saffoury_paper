import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GrowthRate {
  int? year;
  int? month;
  int? day;
  @JsonKey(fromJson: convertToDouble)
  double? total;
  GrowthRate();

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());
}
