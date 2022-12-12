import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

@reflector
class FileExporterObject extends ViewAbstract<FileExporterObject> {
  ViewAbstract viewAbstract;
  String? fileName;
  late Excel excel;
  late List<String> exportOptions;
  late List<String> exportOptionsViewAbstrct;

  Map<String, dynamic> generatedMirrorNewInstance = {};
  Map<String, IconData> generatedFieldsIconMap = {};
  Map<String, String> generatedFieldsLabels = {};

  Map<String, String> selectedFields = {};

  Map<String, List> generatedFieldsAutoCompleteCustom = {};
  Map<String, bool> generatedRequiredFields = {};
  List<String> generatedMainFields = [];

  FileExporterObject({required this.viewAbstract}) : super() {
    assert(viewAbstract is ExcelableReaderInterace);

    excel = Excel.createExcel();
  }
  void init(BuildContext context) {
    exportOptions = [
      AppLocalizations.of(context)!.enable,
      AppLocalizations.of(context)!.disable,
    ];
    exportOptionsViewAbstrct = [
      AppLocalizations.of(context)!.enable,
      AppLocalizations.of(context)!.disable,
      "Export all with Options"
    ];
    fileName =
        "${"".toDateTimeNowString()}-${viewAbstract.getMainHeaderLabelTextOnly(context)}";

    List<String> listOfFields = viewAbstract.getMainFields(context: context);

    generatedFieldsLabels.addAll(viewAbstract.getFieldLabelMap(context));

    generatedFieldsIconMap.addAll(viewAbstract.getFieldIconDataMap());

    generatedMirrorNewInstance
        .addAll(viewAbstract.getMirrorFieldsMapNewInstance());

    generatedMainFields.addAll(viewAbstract.getMainFields());
    generatedRequiredFields.addAll(viewAbstract.isFieldCanBeNullableMap());
    refreshDropdownList(context);
    for (var element in listOfFields) {
      if (viewAbstract.isViewAbstract(element)) {
        bool canBeNull = (viewAbstract.isFieldCanBeNullable(context, element));
        generatedRequiredFields[element] = canBeNull == false;
      }
    }
    debugPrint(
        "FileReaderObject generated generatedRequiredFields $generatedRequiredFields");
  }

  @override
  String getTag(String field) {
    return super.getTag(field);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"fileName": ""}..addAll(generatedMirrorNewInstance);

  @override
  Map<String, IconData> getFieldIconDataMap() {
    return {"fileName": Icons.document_scanner}..addAll(generatedFieldsIconMap);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    return {"fileName": AppLocalizations.of(context)!.sheets}
      ..addAll(generatedFieldsLabels);
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ["fileName", ...generatedMainFields];
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      viewAbstract.getMainHeaderLabelTextOnly(context);

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      viewAbstract.getMainHeaderTextOnly(context);

  @override
  IconData getMainIconData() => viewAbstract.getMainIconData();

  @override
  FileExporterObject getSelfNewInstance() {
    return FileExporterObject(viewAbstract: viewAbstract);
  }

  bool checkHasViewAbstract(BuildContext context, ViewAbstract view) {
    return view
            .getMainFields(context: context)
            .firstWhereOrNull((p0) => view.isViewAbstract(p0)) !=
        null;
  }

  @override
  dynamic getFieldValue(String field, {BuildContext? context}) {
    var value =
        selectedFields.entries.firstWhereOrNull((p0) => p0.key == field);
    if (value != null) return value.value;
    if (field == "fileName") return super.getFieldValue(field);
    return "Enable";
  }

  void refreshDropdownList(BuildContext context) {
    List<String> listOfFields = viewAbstract.getMainFields(context: context);
    generatedFieldsAutoCompleteCustom = {};

    for (var element in listOfFields) {
      if (viewAbstract.isViewAbstract(element)) {
        generatedFieldsAutoCompleteCustom[element] = exportOptionsViewAbstrct;
      } else {
        generatedFieldsAutoCompleteCustom[element] = exportOptions;
      }
    }
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onDropdownChanged(context, field, value);
    selectedFields[field] = value.toString();
    debugPrint("selectedFields $selectedFields");
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    Map<String, List> list = {};
    refreshDropdownList(context);
    list.addAll(generatedFieldsAutoCompleteCustom);
    return list;
  }

  Future<void> generateExcel(BuildContext context) async {}

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
  String toString() {
    return "viewAbstract: $viewAbstract , selectedFields: $selectedFields";
  }

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"fileName": true}..addAll(generatedRequiredFields);

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  FileExporterObject fromJsonViewAbstract(Map<String, dynamic> json) =>
      FileExporterObject(viewAbstract: viewAbstract);
}
