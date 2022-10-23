import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../v_non_view_object.dart';

class ChartRecordAnalysis<T extends ViewAbstract>
    extends VObject<ChartRecordAnalysis>
    implements CustomViewResponse<ChartRecordAnalysis> {
  List<GrowthRate>? responseListAnalysis = [];
  DateObject? date;
  EnteryInteval? enteryInteval;

  @JsonKey(ignore: true)
  T? viewAbstract;
  ChartRecordAnalysis() : super();

  ChartRecordAnalysis.init(
      T viewAbstract, DateObject date, EnteryInteval enteryInteval) {
    this.viewAbstract = viewAbstract;
    this.date = date;
    this.enteryInteval = enteryInteval;
  }

  @override
  Map<String, String> get getCustomMap => {
        "enteryInteval": _$EnteryInteval[enteryInteval] ?? "",
        "date": jsonEncode(date?.toJson() ?? "")
      };

  @override
  String? getCustomAction() => "list_dashboard_single_item";
  @override
  String? getTableNameApi() => viewAbstract?.getTableNameApi();

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return {};
  }

  @override
  ChartRecordAnalysis fromJsonViewAbstract(Map<String, dynamic> json) {
    return ChartRecordAnalysis()
      ..responseListAnalysis = (json['responseListAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..date = DateObject.fromJson(json['date'])
      ..enteryInteval = $enumDecodeNullable(_$EnteryInteval, json['status']);
  }

  @override
  String getCustomViewKey() {
    return "list_dashboard_single_item$T";
  }

  @override
  ResponseType getCustomViewResponseType() {
    return ResponseType.SINGLE;
  }

  @override
  void onCustomViewCardClicked(
      BuildContext context, ChartRecordAnalysis istem) {
    debugPrint("onCustomViewCardClicked=> $istem");
  }

  @override
  Widget? getCustomViewListResponseWidget(
      BuildContext context, List<ChartRecordAnalysis> item) {
    return null;
  }

  @override
  Widget? getCustomViewSingleResponseWidget(
      BuildContext context, ChartRecordAnalysis item) {
    debugPrint(
        "getCustomViewSingleResponseWidget ${item.responseListAnalysis?.length}");
    return LineChartItem<GrowthRate, DateTime>(
      title:
          "${AppLocalizations.of(context)!.total}: ${item.responseListAnalysis?.length} ",
      list: item.responseListAnalysis ?? [],
      xValueMapper: (item, value) =>
          DateTime(item.year ?? 0, item.month ?? 0, item.day ?? 0),
      yValueMapper: (item, n) => item.total,
    );
  }

  // Widget getDecription(BuildContext context, ChartRecordAnalysis item) {
  //   return RichText(
  //     text: TextSpan(
  //       text: AppLocalizations.of(context)!.youHave,
  //       // style: TextStyle(fontWeight: FontWeight.bold),
  //       children: <TextSpan>[
  //         TextSpan(
  //             text:
  //                 "${item.list.length} ${AppLocalizations.of(context)!.unUsed}",
  //             style: TextStyle(fontWeight: FontWeight.bold)),
  //         // TextSpan(text: ' world!'),
  //       ],
  //     ),
  //   );
  // }
}

enum EnteryInteval { monthy, daily }

const _$EnteryInteval = {
  EnteryInteval.monthy: 'monthy',
  EnteryInteval.daily: 'daily',
};
