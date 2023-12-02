import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintCustomerGuid extends PrintLocalSetting<PrintCustomerGuid> {
  PrintCustomerGuid() : super();

  @override
  PrintCustomerGuid getSelfNewInstance() {
    return PrintCustomerGuid();
  }

  @override
  PrintCustomerGuid fromJsonViewAbstract(Map<String, dynamic> json) => this;

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

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
  String? getPrintableSortByName() => null;
  @override
  String? getPrintableGroupByName() => null;

  @override
  SortByType? getPrintableHasSortBy() => null;
  @override
  PrintCustomerGuid onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    // TODO: implement onSavedModiablePrintableLoaded
    throw UnimplementedError();
  }
}
