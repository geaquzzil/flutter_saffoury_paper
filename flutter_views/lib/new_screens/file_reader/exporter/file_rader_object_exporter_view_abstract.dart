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
import 'package:path/path.dart';

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

  FileExporterObject({required this.viewAbstract}) : super();
  void init(BuildContext context) {
    if (fileName != null) return;
    exportOptions = [
      AppLocalizations.of(context)!.enable,
      AppLocalizations.of(context)!.disable,
    ];
    exportOptionsViewAbstrct = [
      AppLocalizations.of(context)!.enable,
      AppLocalizations.of(context)!.disable,
      AppLocalizations.of(context)!.details,
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
    return generatedFieldsAutoCompleteCustom;
  }

  bool isRequiredFieldToGenerate(BuildContext context, String field) {
    var e = selectedFields.entries.firstWhereOrNull((p0) => p0.key == field);
    if (e == null) return true;
    return e.value != AppLocalizations.of(context)!.disable;
  }

  bool isRequiredFieldDetails(BuildContext context, String field) {
    // debugPrint('generateExcel isRequiredFieldDetails checking => $field ');
    bool isViewAbstract = viewAbstract.isViewAbstract(field);
    if (isViewAbstract) {
      var e = selectedFields.entries.firstWhereOrNull((p0) => p0.key == field);
      debugPrint('generateExcel isRequiredFieldDetails=> $e ');
      if (e == null) return false;
      bool res = e.value == AppLocalizations.of(context)!.details;
      debugPrint(
          'generateExcel isRequiredFieldDetails=> field => $field  => res => $res ');
      return res;
    }
    return false;
  }

  Future<void> generateExcel(BuildContext context) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    excel = Excel.createExcel();

    Sheet sh = excel[excel.getDefaultSheet()!];

    CellStyle cellStyle = CellStyle(
      bold: true,
      italic: true,
      fontSize: 10,
      // verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Arial),
      rotation: 0,
    );
    List<String> fields = viewAbstract
        .getMainFields()
        .where((element) =>
            getFieldValue(element) != null &&
            isRequiredFieldToGenerate(context, element) &&
            !isRequiredFieldDetails(context, element))
        .toList();

    debugPrint('generateExcel Generating  fields => $fields');

    for (int i = 0; i < fields.length; i++) {
      {
        var cell =
            sh.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i));
        cell.value = viewAbstract.getFieldLabel(context, fields[i]);
        cell.cellStyle = cellStyle;
      }
    }
    for (int i = 0; i < fields.length; i++) {
      {
        sh.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: i)).value =
            viewAbstract.getFieldValueCheckType(context, fields[i]);
      }
    }
    int startCount = fields.length;
    viewAbstract
        .getMainFields()
        .where((element) =>
            getFieldValue(element) != null &&
            isRequiredFieldDetails(context, element))
        .forEach((element) {
      ViewAbstract subViewAbstract = viewAbstract.getFieldValue(element);
      fields = subViewAbstract.getMainFields();
      debugPrint(
          'generateExcel Generating  subViewAbstract  => ${subViewAbstract.runtimeType}  fields=> $fields  => startingCount=>$startCount');
      for (int i = 0; i < fields.length; i++) {
        {
          debugPrint(
              'generateExcel Generating  subViewAbstract  => ${subViewAbstract.runtimeType}  columnIndex: $i => value => ${subViewAbstract.getFieldLabel(context, fields[i])}');
          var cell = sh.cell(CellIndex.indexByColumnRow(
              rowIndex: 0, columnIndex: startCount + i));
          cell.value =
              "${subViewAbstract.getMainHeaderLabelTextOnly(context)}:${subViewAbstract.getFieldLabel(context, fields[i])}";

          cell.cellStyle = cellStyle;
        }
      }
      for (int i = 0; i < fields.length; i++) {
        {
          sh
                  .cell(CellIndex.indexByColumnRow(
                      rowIndex: 1, columnIndex: startCount + i))
                  .value =
              subViewAbstract.getFieldValueCheckType(context, fields[i]);
        }
      }
      startCount = startCount + fields.length;
    });

    // ViewAbstract subViewAbstract =
    //         viewAbstract.getMirrorNewInstanceViewAbstract(fields[i]);
    //     List<String> subFields = subViewAbstract.getMainFields();
    //     for (int j = 0; j < subFields.length - 1; j++) {
    //       sh
    //           .cell(CellIndex.indexByColumnRow(
    //               rowIndex: 0, columnIndex: fields.length + j))
    //           .value = subViewAbstract.getFieldLabel(context, fields[j]);
    //     }
    debugPrint('generateExcel Generating executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    var fileBytes = excel.encode();

    debugPrint('generateExcel Encoding executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    if (fileBytes != null) {
      File(join("/Users/kawal/Desktop/r2.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    debugPrint('generateExcel Downloaded executed in ${stopwatch.elapsed}');
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
