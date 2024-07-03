import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_view_controller/ext_utils.dart';

class GrowthRate extends JsonHelper<GrowthRate> {
  int? year;
  int? month;
  int? day;
  @JsonKey(fromJson: convertToDouble)
  double? total;
  GrowthRate();
  bool isEqualsByDate(GrowthRate? growthRates) {
    return growthRates?.year == year &&
        growthRates?.month == month &&
        growthRates?.day == day;
  }

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());
  @override
  GrowthRate fromJson(Map<String, dynamic> data) {
    return GrowthRate.fromJson(data);
  }

  factory GrowthRate.fromJson(Map<String, dynamic> data) => GrowthRate()
    ..total = GrowthRate.convertToDouble(data["total"])
    ..day = data["day"] as int?
    ..month = data["month"] as int?
    ..year = data["year"] as int?;

  Map<String, dynamic> toJson() => {};

  @override
  String toString() {
    return "day:$day,month:$month,year:$year total:$total";
  }

  static double getTotal(List<GrowthRate>? growthRates) {
    try {
      return growthRates?.map((e) => e.total).reduce((value, element) =>
              value.toNonNullable() + element.toNonNullable()) ??
          0;
    } catch (e) {
      return 0;
    }
  }

  static Widget getGrowthRateText(
      BuildContext context, List<GrowthRate>? growth) {
    double getGrowthRate = GrowthRate.getGrowthRate(growth);
    return Text(
      getGrowthRate.toCurrencyFormat(symbol: "%"),
      style:
          getGrowthRate > 0 ? getGrowTheme(context) : getReduceTheme(context),
    );
  }

  static double getGrowthRate(List<GrowthRate>? growth) {
    if (growth == null) return 0;
    if (growth.isEmpty) return 0;
    if (growth.length == 1) return 0;
    double period1 = growth[growth.length - 2].total.toNonNullable();
    double period2 = growth[growth.length - 1].total.toNonNullable();
    // Percent increase (or decrease) = (Period 2 – Period 1) / Period 1 * 100
    return (period2 - period1) / period1 * 100;
  }

  static getGrowTheme(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall!
      .copyWith(color: Theme.of(context).colorScheme.primary);
  static getReduceTheme(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall!
      .copyWith(color: Theme.of(context).colorScheme.error);
}

extension GrowthRateUtils<T extends GrowthRate> on List<T?>? {
  double getGrowthRate() {
    if (this == null) return 0;
    if (this!.isEmpty) return 0;
    if (this!.length == 1) return 0;
    double period1 = this![this!.length - 2]!.total.toNonNullable();
    double period2 = this![this!.length - 1]!.total.toNonNullable();
    // Percent increase (or decrease) = (Period 2 – Period 1) / Period 1 * 100
    return (period2 - period1) / period1 * 100;
  }

  Widget getGrowthRateText(BuildContext context, {bool reverseTheme = false}) {
    double getGrowthRate = this.getGrowthRate();
    getGrowthRate = reverseTheme ? getGrowthRate * -1 : getGrowthRate;
    return Text(
      getGrowthRate.toCurrencyFormat(symbol: "%"),
      style: getGrowthRate > 0
          ? GrowthRate.getGrowTheme(context)
          : GrowthRate.getReduceTheme(context),
    );
  }

  Widget getLastRecordGrowthRateText(BuildContext context,
      {bool reverseTheme = false}) {
    if (this == null) return const Text("-");
    if (this!.isEmpty) return const Text("-");
    double getGrowthRate = this![this!.length - 1]!.total.toNonNullable();
    return Text(
      "Last month:${getGrowthRate.toCurrencyFormat(symbol: "%")}",
      style: getGrowthRate > 0 && !reverseTheme
          ? GrowthRate.getGrowTheme(context)
          : GrowthRate.getReduceTheme(context),
    );
  }

  String getLastRecordText({String symple = ""}) {
    if (this == null) return "-";
    if (this!.isEmpty) return "-";
    double getGrowthRate = this![this!.length - 1]!.total.toNonNullable();
    return "Last month:${getGrowthRate.toCurrencyFormat(symbol: symple)}";
  }

  String getLastRecordTextFromSetting(BuildContext context) {
    if (this == null) return "-";
    if (this!.isEmpty) return "-";
    double getGrowthRate = this![this!.length - 1]!.total.toNonNullable();
    return "Last month:${getGrowthRate.toCurrencyFormatFromSetting(context)}";
  }

  double getTotal() {
    if (this == null) return 0;
    return GrowthRate.getTotal(this!.cast());
  }

  String getTotalText({String symple = ""}) {
    return getTotal().toCurrencyFormat(symbol: symple);
  }

  String getTotalTextFromSetting(BuildContext context) {
    return getTotal().toCurrencyFormatFromSetting(context);
  }
}
