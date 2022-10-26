import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/chart/pie_chart.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ChangesRecords<T extends ViewAbstract> extends VObject<ChangesRecords>
    implements CustomViewHorizontalListResponse<ChangesRecords> {
  @JsonKey(ignore: true)
  T? viewAbstract;
  String? fieldToGroupBy;
  int? total;
  List<ChangesRecordGroup>? totalGrouped = [];
  ChangesRecords() : super();
  int getTotal() {
    return total.toNonNullable();
  }

  List<ChangesRecordGroup> getTotalGrouped() {
    return totalGrouped ?? [];
  }

  ChangesRecords.init(T viewAbstract, String fieldToGroupBy) {
    this.viewAbstract = viewAbstract;
    this.fieldToGroupBy = fieldToGroupBy;
  }

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
  Map<String, String> get getCustomMap =>
      {"fieldToGroupBy": fieldToGroupBy ?? ""};

  @override
  ChangesRecords fromJsonViewAbstract(Map<String, dynamic> json) =>
      ChangesRecords.fromJson(json);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  factory ChangesRecords.fromJson(Map<String, dynamic> data) => ChangesRecords()
    ..total = data["total"] as int?
    ..fieldToGroupBy = data["fieldToGroupBy"] as String?
    ..totalGrouped = (data['totalGrouped'] as List<dynamic>?)
        ?.map((e) => ChangesRecordGroup.fromJson(e as Map<String, dynamic>))
        .toList();

  Map<String, dynamic> toJson() => {};

  @override
  String getCustomViewKey() {
    return "changesRecords$T";
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
  Widget? getCustomViewSingleResponseWidget(
      BuildContext context, ChangesRecords item) {
    debugPrint("getCustomViewSingleResponseWidget ${item.totalGrouped}");
    return CirculeChartItem<ChangesRecordGroup, String>(
      title:
          "${AppLocalizations.of(context)!.total}: ${item.total.toCurrencyFormat()} ",
      list: item.totalGrouped ?? [],
      xValueMapper: (item, value) => item.groupBy,
      yValueMapper: (item, n) => item.count,
    );
  }

  @override
  void onCustomViewCardClicked(BuildContext context, ChangesRecords istem) {
    // TODO: implement onCustomViewCardClicked
  }

  @override
  double getCustomViewHeight() => 200;
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

  static String? convertToString(dynamic number) =>
      number == null ? "-" : number.toString();
  factory ChangesRecordGroup.fromJson(Map<String, dynamic> data) =>
      ChangesRecordGroup()
        ..count = data['count'] as int?
        ..groupBy = ChangesRecordGroup.convertToString(['groupBy']);

  Map<String, dynamic> toJson() => {};
}
