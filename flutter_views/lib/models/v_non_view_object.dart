import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

abstract class VObject<T> extends ViewAbstract<T> {
  VObject() : super();

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};
  @override
  String? getMainDrawerGroupName(BuildContext context) => "_none view $T";

  @override
  List<String> getMainFields() => [];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "_none_view $T";

  @override
  String getMainHeaderTextOnly(BuildContext context) => "_none_view $T";

  @override
  IconData getMainIconData() => Icons.abc;

  @override
  String? getSortByFieldName() => "iD";
  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {};
  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};
  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
