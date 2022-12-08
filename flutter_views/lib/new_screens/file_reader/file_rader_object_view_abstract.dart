import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../models/v_mirrors.dart';

@reflector
class FileReaderObject extends ViewAbstract<FileReaderObject> {
  ViewAbstract viewAbstract;
  String? selectedSheet;

  late List<String> fileSheets;
  List<String> fileColumns = [];
  String filePath;
  late Excel excel;

  FileReaderObject({required this.viewAbstract, required this.filePath})
      : super() {
    var bytes = File(filePath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
    fileSheets = excel.tables.keys.toList();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {"selectedSheet": ""}
    ..addAll(viewAbstract.getMirrorFieldsMapNewInstance());

  @override
  Map<String, IconData> getFieldIconDataMap() {
    return {"selectedSheet": Icons.document_scanner}
      ..addAll(viewAbstract.getFieldIconDataMap());
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    return {"selectedSheet": AppLocalizations.of(context)!.sheets}
      ..addAll(viewAbstract.getFieldLabelMap(context));
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields() =>
      ["selectedSheet", ...viewAbstract.getMainFields()];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      viewAbstract.getMainHeaderLabelTextOnly(context);

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      viewAbstract.getMainHeaderTextOnly(context);

  @override
  IconData getMainIconData() => viewAbstract.getMainIconData();

  @override
  FileReaderObject getSelfNewInstance() {
    return FileReaderObject(viewAbstract: viewAbstract, filePath: filePath);
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onDropdownChanged(context, field, value);
    if (field == "selectedSheet") {
      selectedSheet = value.toString();
      var f = excel.tables[value.toString()]?.rows;
      if (f != null && f.isNotEmpty) {
        fileColumns = f[0].map((e) => e!.value.toString()).toList();
        debugPrint("fileColumns $fileColumns");
        debugPrint("formKey fields  ${formKey?.currentState?.fields}");
        // formKey?.currentState?.();
        formKey?.currentState?.fields.forEach((key, value) {
          debugPrint("formKey $key => $key");
          // value.activate();
          // value.initState();
          // value.build(context);
          (value.widget as FormBuilderDropdown).();
        });
        // formKey?.currentState?.fields["gsms"]?.setState(() {});
      }
    }
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    Map<String, List> list = {};

    list["selectedSheet"] = fileSheets;
    viewAbstract.getMainFields().forEach((element) {
      list[element] = fileColumns;
    });
    return list;
  }

  @override
  String? getSortByFieldName() => null;

  @override
  SortByType getSortByType() => SortByType.ASC;

  @override
  String? getTableNameApi() => null;

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
  bool isFieldRequired(String field) => true;
  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  FileReaderObject fromJsonViewAbstract(Map<String, dynamic> json) =>
      FileReaderObject(viewAbstract: viewAbstract, filePath: filePath);
}
