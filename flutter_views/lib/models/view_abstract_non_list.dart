import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_stand_alone.dart';
import 'package:provider/provider.dart';

abstract class ViewAbstractStandAloneCustomView<T> extends ViewAbstract<T> {
  ViewAbstractStandAloneCustomView() : super();

  ResponseType getCustomStandAloneResponseType();

  Widget getCustomStandAloneWidget(BuildContext context);
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context);

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields() {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  void onDrawerItemClicked(BuildContext context) {
    context.read<DrawerViewAbstractStandAloneProvider>().change(context, this);
  }

  @override
  String? getSortByFieldName() => null;
  @override
  SortByType getSortByType() => SortByType.ASC;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }
}
