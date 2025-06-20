import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import '../v_non_view_object.dart';

class ChartRecordAnalysis<T extends ViewAbstract>
    extends VObject<ChartRecordAnalysis>
    implements CustomViewHorizontalListResponse<ChartRecordAnalysis> {
  List<GrowthRate>? responseListAnalysis = [];
  DateObject? date;
  EnteryInteval? enteryInteval;

  @JsonKey(includeFromJson: false, includeToJson: false)
  T? viewAbstract;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? customAction;

  ChartRecordAnalysis() : super();

  ChartRecordAnalysis.init(T this.viewAbstract, DateObject this.date,
      EnteryInteval this.enteryInteval,
      {this.customAction}) {
    customAction = customAction;
  }

  @override
  ChartRecordAnalysis getSelfNewInstance() {
    return ChartRecordAnalysis();
  }

  double getTotalListAnalysis() {
    try {
      return responseListAnalysis
              ?.map((e) => e.total)
              .reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
          0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Map<String, String> get getCustomMap => {
        "enteryInteval": _$EnteryInteval[enteryInteval] ?? "",
        "date": jsonEncode(date?.toJson() ?? ""),
        if (customAction != null) "customAction": jsonEncode(customAction)
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
    return "list_dashboard_single_item$T$customAction${enteryInteval.toString()}$date";
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
  Widget? getCustomViewSingleResponseWidget(BuildContext context) {
    debugPrint(
        "getCustomViewSingleResponseWidget ${responseListAnalysis?.length}");
    return LineChartItem<GrowthRate, DateTime>(
      title:
          "${AppLocalizations.of(context)!.total}: ${responseListAnalysis?.length} ",
      list: responseListAnalysis ?? [],
      xValueMapper: (item, value) =>
          DateTime(item.year ?? 0, item.month ?? 0, item.day ?? 0),
      yValueMapper: (item, n) => item.total,
    );
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            SizedBox(
              width: 100,
              height: 100,
              child: DropdownEnumControllerListener<EnteryInteval>(
                  viewAbstractEnum: enteryInteval ?? EnteryInteval.monthy,
                  onSelected: (obj) {
                    debugPrint("onSelected: changed $obj");
                    if (obj != null) {
                      enteryInteval = obj;
                      context.read<ListMultiKeyProvider>().recall(
                          getCustomViewKey(),
                          this,
                          getCustomViewResponseType(),context: context);
                    }
                  }),
            )
          ],
        ),
        LineChartItem<GrowthRate, DateTime>(
          title:
              "${AppLocalizations.of(context)!.total}: ${responseListAnalysis?.length} ",
          list: responseListAnalysis ?? [],
          xValueMapper: (item, value) =>
              DateTime(item.year ?? 0, item.month ?? 0, item.day ?? 0),
          yValueMapper: (item, n) => item.total,
        ),
      ],
    );
  }

  @override
  double? getCustomViewHeight() => 600;

  @override
  Widget? getCustomViewTitleWidget(
      BuildContext context, ValueNotifier valueNotifier) {
    Widget? dropDownTile;
    Widget? dateWidget;
    if (viewAbstract != null) {
      dropDownTile = DropdownEnumControllerListenerByIcon<EnteryInteval>(
          viewAbstractEnum: EnteryInteval.monthy,
          onSelected: (obj) {
            if (obj == null) return;
            if (obj == enteryInteval) return;
            valueNotifier.value = ChartRecordAnalysis.init(
                viewAbstract!, date ?? DateObject.initFirstDateOfYear(), obj);
          });
      // dateWidget = DropdownDateControllerListener(
      //   viewAbstractEnum: DateEnum.this_year,
      //   onSelected: (o) {},
      //   onSelectedDateObject: (dateObject) {
      //     if (dateObject == null) return;
      //     if (dateObject.isEqual(date)) return;
      //     valueNotifier.value = ChartRecordAnalysis.init(
      //         viewAbstract!, dateObject, enteryInteval ?? EnteryInteval.monthy);
      //   },
      // );
    }

    Widget row = SizedBox(
      width: 200,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (dropDownTile != null) dropDownTile,
          // if (dateWidget != null) dateWidget
        ],
      ),
    );
    return HeaderDescription(
       //TODO Translate
      title: "Changes records",
      trailing: row,
    );
  }

  @override
  Widget? getCustomViewOnResponse(ChartRecordAnalysis<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponse
    throw UnimplementedError();
  }

  @override
  Widget? getCustomViewOnResponseAddWidget(
      ChartRecordAnalysis<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponseAddWidget
    throw UnimplementedError();
  }
}

enum EnteryInteval implements ViewAbstractEnum<EnteryInteval> {
  monthy,
  daily;

  @override
  IconData getMainIconData() {
    return Icons.date_range;
  }

  @override
  String getMainLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.enteryInterval;
  }

  @override
  String getFieldLabelString(BuildContext context, EnteryInteval field) {
    switch (field) {
      case EnteryInteval.monthy:
        return AppLocalizations.of(context)!.thisMonth;
      case EnteryInteval.daily:
        return AppLocalizations.of(context)!.this_day;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, EnteryInteval field) {
    switch (field) {
      case EnteryInteval.monthy:
        return Icons.date_range_outlined;
      case EnteryInteval.daily:
        return Icons.date_range;
    }
  }

  @override
  List<EnteryInteval> getValues() {
    return EnteryInteval.values;
  }
}

const _$EnteryInteval = {
  EnteryInteval.monthy: 'monthy',
  EnteryInteval.daily: 'daily',
};
