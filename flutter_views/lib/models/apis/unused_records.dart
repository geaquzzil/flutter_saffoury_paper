import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class UnusedRecords extends VObject<UnusedRecords> {
  List<int> list = [];
  List<dynamic> listObjects = [];
  ViewAbstract? viewAbstract;
  bool? requireObjects;
  UnusedRecords() : super();

  UnusedRecords.init(ViewAbstract viewAbstract) {
    this.viewAbstract = viewAbstract;
  }

  // @Override
  // public ViewAbstractHeader getHeaderOnRecyclerServerResponse(Context context) {
  //     return null;
  // }

  // @Override
  // public Object getObjectOnRecyclerServerResponse(Context context, Object object) {
  //     UnusedRecords response = (UnusedRecords) object;
  //     return new LikeAbout() {
  //         @Override
  //         public void onListItemClicked(Context context, View itemView) {
  //             showFragment(context,
  //                     new FragmentDetailList((BaseActivity) context,
  //                             new Gson().fromJson(response.listObjects.toString(), Objects.makeGenericList(response.getViewAbstract().getClass()))),
  //                     response.getViewAbstract().getHeaderLabel(context));
  //         }

  //         @Override
  //         public Spanned getText(Context context) {
  //             return response.getHeaderText(context);
  //         }
  //     };
  // }

  @override
  Map<String, String> get getCustomMap =>
      {if (requireObjects != null) "requireObjects": "true"};

  @override
  UnusedRecords fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  String? getCustomAction() => "list_not_used_records";
  @override
  String? getTableNameApi() => viewAbstract?.getTableNameApi();

  // @Override
  // public ViewAbstract<?> onReadNewObject(Context context, ViewAbstract<?> newObject, ViewAbstract<?> oldCalledViewAbstract) {
  //     ((UnusedRecords) newObject).viewAbstract = ((UnusedRecords) oldCalledViewAbstract).viewAbstract;
  //     return super.onReadNewObject(context, newObject, oldCalledViewAbstract);
  // }

  // @Override
  // public Spanned getHeaderText(Context context) {
  //     SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder(context.getString(R.string.youHave));
  //     Spannable asDate;
  //     asDate = new SpannableString(
  //             getHtmlFormat(String.format("&nbsp;<big>%s %s %s</big>", listObjects.size(), context.getString(R.string.unUsed), viewAbstract.getHeaderLabel(context))));
  //     asDate.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.colorAccent)),
  //             0, asDate.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

  //     spannableStringBuilder.append(asDate);
  //     return spannableStringBuilder;
  // }

}
