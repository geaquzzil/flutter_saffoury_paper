import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_components/chart/pie_chart.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ChangesRecords<T extends ViewAbstract> extends VObject<ChangesRecords>
    implements CustomViewHorizontalListResponse<ChangesRecords> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  T? viewAbstract;
  String? fieldToGroupBy;
  String? fieldToSumBy;
  @Deprecated(
      "this field is already can calculate from totalGrouped.total and its do sql query twice")
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

  ChangesRecords.init(T this.viewAbstract, String this.fieldToGroupBy,
      {this.fieldToSumBy});

  // @Override
  // public Object getObjectOnRecyclerServerResponse(Context context, Object object) {
  //     ChangesRecords recordRespone = (ChangesRecords) object;
  //     return new ViewAbstractCustomView() {
  //         @Override
  //         public View getView(Context context) {
  //             SummaryViewGenerator summaryViewGenerator = new SummaryViewGenerator(context);
  //             summaryViewGenerator.setTotal(recordRespone.getTotal());
  //             for (ChangesRecords.ChangesRecordGroup c :
  //                     recordRespone.getTotalGrouped()
  //             ) {
  //                 ViewAbstract<?> viewAbstract = recordRespone.getViewAbstract();
  //                 Spanned spanned = viewAbstract.getFieldTextValueEnum(context, viewAbstract.
  //                         getChangedRecordsGroupedByFieldName(), c.getGroupBy());

  //                 List<SummaryViewGenerator.SubSummaryFill> subSummaryFills =
  //                         summaryViewGenerator.getSingleSub(c.getCount(), spanned.toString(), false);
  //                 //  SummaryViewGenerator.SummaryFill  summaryFill=
  //                 summaryViewGenerator.summaryAdd(
  //                         summaryViewGenerator.getPriorityKey(c.getGroupBy().toUpperCase(), SummaryViewGenerator.PriorityKey.TOTAL_PRIORITY),
  //                         summaryViewGenerator.getSummaryFill(subSummaryFills).setOnClickListener1(v -> {
  //                             try {
  //                                 viewAbstract.getFilterableObject().clear();
  //                                 viewAbstract.addFilterableObjectNewManual(viewAbstract.getField(viewAbstract.getChangedRecordsGroupedByFieldName()), c.getGroupBy());
  //                                 showFragment(context,
  //                                         FragmentSearchResultAnim.newInstance((BaseActivity) context, viewAbstract, viewAbstract.getFilterableObject()),
  //                                         spanned);
  //                             } catch (Exception e) {
  //                                 e.printStackTrace();
  //                             }

  //                         }));
  //             }

  //             return summaryViewGenerator.getViewSummaryViewRecyclerView();
  //         }
  //     };
  // }

  @override
  String? getTableNameApi() => viewAbstract?.getTableNameApi();

  @override
  String? getCustomAction() => "list_changes_records_table";
  @override
  Map<String, String> get getCustomMap => {
        "fieldToGroupBy": fieldToGroupBy ?? "",
        if (fieldToSumBy != null) "fieldToSumBy": fieldToSumBy!
      };

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
      BuildContext context, List<ChangesRecords> item) {
    // TODO: implement getCustomViewListResponseWidget
    throw UnimplementedError();
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.SINGLE;

  @override
  Widget? getCustomViewSingleResponseWidget(BuildContext context) {
    debugPrint("getCustomViewSingleResponseWidget ${totalGrouped}");

    // return LineChartItem<ChangesRecordGroup, String>(
    //   title: "${AppLocalizations.of(context)!.total}: ${totalGrouped?.length} ",
    //   list: totalGrouped ?? [],
    //   xValueMapper: (item, value) => "${item.groupBy}",
    //   yValueMapper: (item, n) => fieldToSumBy == null ? item.count : item.total,
    // );
    return CirculeChartItem<ChangesRecordGroup, String>(
      title:
          "${AppLocalizations.of(context)!.total}: ${total.toCurrencyFormat()} ",
      list: totalGrouped ?? [],
      xValueMapper: (item, value) => item.groupBy,
      yValueMapper: (item, n) => fieldToSumBy == null ? item.count : item.total,
    );
  }

  @override
  void onCustomViewCardClicked(BuildContext context, ChangesRecords istem) {
    // TODO: implement onCustomViewCardClicked
  }

  @override
  double? getCustomViewHeight() => 200;

  @override
  Widget? getCustomViewTitleWidget(
      BuildContext context, ValueNotifier valueNotifier) {
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
                viewAbstract!
                    .getFieldValueFromDropDownString(obj.value.toString()),
                fieldToSumBy: fieldToSumBy);
          });
    }

    return HeaderDescription(
      title: "Changes records",
      trailing: dropDownTile,
    );
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

  static String? convertToString(dynamic number) =>
      number == null ? "-" : number.toString();
  factory ChangesRecordGroup.fromJson(Map<String, dynamic> data) =>
      ChangesRecordGroup()
        ..count = data['count'] as int?
        ..total = ChangesRecordGroup.convertToDouble(data['total'])
        ..groupBy = ChangesRecordGroup.convertToString(data['groupBy']);

  Map<String, dynamic> toJson() => {};
  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());
}
