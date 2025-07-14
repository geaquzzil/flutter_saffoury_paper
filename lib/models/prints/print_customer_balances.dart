import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintCustomerBalances extends PrintLocalSetting<PrintCustomerBalances> {
  PrintCustomerBalances() : super();

  @override
  PrintCustomerBalances getSelfNewInstance() {
    return PrintCustomerBalances();
  }

  @override
  PrintCustomerBalances fromJsonViewAbstract(Map<String, dynamic> json) => this;


  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "";

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
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  PrintCustomerBalances onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    // TODO: implement onSavedModiablePrintableLoaded
    throw UnimplementedError();
  }

  @override
  String? getPrintableSortByName(BuildContext context) => null;

  @override
  String? getPrintableGroupByName() => null;

  @override
  SortByType? getPrintableHasSortBy() => null;
}
