import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';
@JsonSerializable(explicitToJson: true)
class ChangesRecords<T extends ViewAbstract> extends VObject<ChangesRecords>
    implements CustomViewResponse<ChangesRecords> {
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

  ViewAbstract? getViewAbstract() {
    return viewAbstract;
  }

  @override
  String? getTableNameApi() => viewAbstract?.getTableNameApi();

  @override
  String? getCustomAction() => "list_changes_records_table";
  @override
  Map<String, String> get getCustomMap =>
      {"fieldToGroupBy": fieldToGroupBy ?? ""};

  @override
  ChangesRecords fromJsonViewAbstract(Map<String, dynamic> json) =>ChangesRecords()..

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

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
    // TODO: implement getCustomViewSingleResponseWidget
    throw UnimplementedError();
  }

  @override
  void onCustomViewCardClicked(BuildContext context, ChangesRecords istem) {
    // TODO: implement onCustomViewCardClicked
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

  factory ChangesRecordGroup.fromJson(Map<String, dynamic> data) =>
      _$ServerResponseMasterFromJson(data);

  Map<String, dynamic> toJson() => _$ChangesRecordGroup(this);
}
