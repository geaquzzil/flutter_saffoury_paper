import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import '../view_abstract.dart';

class ChangesRecords extends VObject<ChangesRecords> {
  ViewAbstract? viewAbstract;
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

  ChangesRecords.init(ViewAbstract viewAbstract, String fieldToGroupBy) {
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
  ChangesRecords fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
  // @Override
  // public ViewAbstract<?> onReadNewObject(Context context, ViewAbstract<?> newObject, ViewAbstract<?> oldCalledViewAbstract) {
  //     ((ChangesRecords) newObject).viewAbstract = ((ChangesRecords) oldCalledViewAbstract).viewAbstract;
  //     return super.onReadNewObject(context, newObject, oldCalledViewAbstract);
  // }

}

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
}
