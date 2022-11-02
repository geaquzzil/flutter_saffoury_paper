import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
@reflector
class PrintCustomerBalances extends PrintLocalSetting<PrintCustomerBalances> {
  @override
  PrintCustomerBalances fromJsonViewAbstract(Map<String, dynamic> json) => this;

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
}
