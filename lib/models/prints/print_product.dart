import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintProduct extends PrintLocalSetting<PrintProduct> {
  bool printProductAsLabel = false;
  int test = 0;
  PrintProduct({dynamic printObject});

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"printProductAsLabel": false, "test": 0});

  @override
  List<String> getMainFields() =>
      super.getMainFields()..addAll(["printProductAsLabel"]);

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "printProductAsLabel": AppLocalizations.of(context)!.date,
        "test": "This is a test"
      };

  @override
  InputType getInputType(String field) {
    if (field == "printProductAsLabel") {
      return InputType.CHECKBOX;
    } else if (field == "test") {
      return InputType.CHECKBOX;
    } else {
      return InputType.EDIT_TEXT;
    }
  }

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
  PrintProduct fromJsonViewAbstract(Map<String, dynamic> json) =>
      fromJsonViewAbstract(json);

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }
}
