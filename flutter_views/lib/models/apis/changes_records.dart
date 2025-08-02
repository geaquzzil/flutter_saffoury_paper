import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_components/chart/pie_chart.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../view_abstract.dart';

part 'changes_records.g.dart';

class ChangesRecords<T extends ViewAbstract> extends VObject<ChangesRecords>
    implements CustomViewHorizontalListResponse<ChangesRecords> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  T? viewAbstract;
  String? fieldToGroupBy;
  String? fieldToSumBy;
  bool? pieChartEnabled = false;
  @Deprecated(
    "this field is already can calculate from totalGrouped.total and its do sql query twice",
  )
  int? total;
  List<ChangesRecordGroup>? totalGrouped = [];
  ChangesRecords() : super();

  @override
  ChangesRecords getSelfNewInstance() {
    return ChangesRecords();
  }

  int getTotal() {
    return total.toNonNullable();
  }

  List<ChangesRecordGroup> getTotalGrouped() {
    return totalGrouped ?? [];
  }

  ChangesRecords.init(
    T this.viewAbstract,
    String this.fieldToGroupBy, {
    this.fieldToSumBy,
    this.pieChartEnabled = false,
  });

  @override
  String? getTableNameApi() => null;

  @override
  List<String>? getCustomAction() {
    return [
      if (viewAbstract?.getTableNameApi() != null)
        viewAbstract!.getTableNameApi()!,
      "changed_records",
    ];
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addGroupBy(fieldToGroupBy).addSumBy(fieldToSumBy);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  ChangesRecords fromJsonViewAbstract(Map<String, dynamic> json) =>
      ChangesRecords.fromJson(json);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  factory ChangesRecords.fromJson(Map<String, dynamic> data) => ChangesRecords()
    // ..viewAbstract = this.viewAbstract
    ..total = data["total"] as int?
    ..fieldToGroupBy = data["fieldToGroupBy"] as String?
    ..fieldToSumBy = data["fieldToSumBy"] as String?
    ..pieChartEnabled = data["pieChartEnabled"] as bool?
    ..totalGrouped = (data['totalGrouped'] as List<dynamic>?)
        ?.map((e) => ChangesRecordGroup.fromJson(e as Map<String, dynamic>))
        .toList();

  Map<String, dynamic> toJson() => {};

  @override
  String getCustomViewKey() {
    return "changesRecords$T$fieldToGroupBy";
  }

  @override
  Widget getCustomViewListResponseWidget(
    BuildContext context,
    List<ChangesRecords> item,
  ) {
    // TODO: implement getCustomViewListResponseWidget
    throw UnimplementedError();
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.SINGLE;

  @override
  dynamic getCustomViewResponseWidget(
    BuildContext context, {
    required SliverApiWithStaticMixin state,
    List<dynamic>? items,
    required dynamic requestObjcet,
    required bool isSliver,
  }) {
    debugPrint("getCustomViewSingleResponseWidget $totalGrouped");
    return SliverToBoxAdapter(child: Text("saddsa"));
    if (pieChartEnabled == false) {
      return LineChartItem<ChangesRecordGroup, String>(
        title:
            "${AppLocalizations.of(context)!.total}: ${totalGrouped?.length} ",
        list: totalGrouped ?? [],
        xValueMapper: (item, value) => "${item.groupBy}",
        yValueMapper: (item, n) =>
            fieldToSumBy == null ? item.count : item.total,
      );
    }

    return CirculeChartItem<ChangesRecordGroup, String>(
      title:
          "${AppLocalizations.of(context)!.total}: ${total.toCurrencyFormat()} ",
      list: totalGrouped ?? [],
      xValueMapper: (item, value) => item.groupBy,
      dataLabelMapper: (item, value) =>
          NumberFormat.compact().format(item.total),
      yValueMapper: (item, n) => fieldToSumBy == null ? item.count : item.total,
    );
  }

  @override
  void onCustomViewCardClicked(BuildContext context, ChangesRecords istem) {
    // TODO: implement onCustomViewCardClicked
  }

  @override
  Widget? getCustomViewTitleWidget(
    BuildContext context,
    ValueNotifier valueNotifier,
  ) {
    Widget? dropDownTile;
    if (viewAbstract != null) {
      dropDownTile = DropdownStringListControllerListenerByIcon(
        icon: Icons.sort_by_alpha,
        hint: AppLocalizations.of(context)!.sortBy,
        list: viewAbstract!.getMainFieldsIconsAndValues(context),
        onSelected: (obj) {
          if (obj == null) return;

          debugPrint("obj selected is ${obj.value}");
          valueNotifier.value = ChangesRecords.init(
            viewAbstract!,
            viewAbstract!.getFieldValueFromDropDownString(obj.value.toString()),
            fieldToSumBy: fieldToSumBy,
          );
        },
      );
    }

    return HeaderDescription(
      title: AppLocalizations.of(context)!.profit_analysis,
      trailing: dropDownTile,
    );
  }

  @override
  Widget? getCustomViewOnResponse(ChangesRecords<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponse
    throw UnimplementedError();
  }

  @override
  void getCustomViewOnResponseAddWidget(ChangesRecords<ViewAbstract> response) {
    // TODO: implement getCustomViewOnResponseAddWidget
    throw UnimplementedError();
  }

  // @Override
  // public ViewAbstract<?> onReadNewObject(Context context, ViewAbstract<?> newObject, ViewAbstract<?> oldCalledViewAbstract) {
  //     ((ChangesRecords) newObject).viewAbstract = ((ChangesRecords) oldCalledViewAbstract).viewAbstract;
  //     return super.onReadNewObject(context, newObject, oldCalledViewAbstract);
  // }
}

@JsonSerializable()
class ChangesRecordGroup {
  int? count;
  @JsonKey(fromJson: convertToString)
  String? groupBy;
  @JsonKey(fromJson: convertToDouble)
  double? total;

  ChangesRecordGroup();

  int? getCount() {
    return count;
  }

  void setCount(int count) {
    this.count = count;
  }

  String? getGroupBy() {
    return groupBy;
  }

  void setGroupBy(String groupBy) {
    this.groupBy = groupBy;
  }

  @override
  String toString() {
    return "count: $count, groupBy: $groupBy, total: $total";
  }

  factory ChangesRecordGroup.fromJson(Map<String, dynamic> data) =>
      ChangesRecordGroup()
        ..count = data['count'] as int?
        ..total = convertToDouble(data['total'])
        ..groupBy = convertToString(data['groupBy']);

  Map<String, dynamic> toJson() => {};
}
