import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/excelable_reader_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../models/v_mirrors.dart';
import '../../models/view_abstract_base.dart';

@reflector
class FileReaderObject extends ViewAbstract<FileReaderObject> {
  ViewAbstract viewAbstract;
  late ExcelableReaderInterace obj;
  String? selectedSheet;

  late List<String> fileSheets;
  List<String> fileColumns = [];
  String filePath;
  late Excel excel;

  Map<String, String> selectedFields = {};

  Map<GroupItem, List<String>> generatedGroupItems = {};
  Map<String, dynamic> generatedMirrorNewInstance = {};
  Map<String, IconData> generatedFieldsIconMap = {};
  Map<String, String> generatedFieldsLabels = {};

  Map<String, List> generatedFieldsAutoCompleteCustom = {};
  Map<String, bool> generatedRequiredFields = {};
  List<String> generatedMainFields = [];

  FileReaderObject({required this.viewAbstract, required this.filePath})
      : super() {
    assert(viewAbstract is ExcelableReaderInterace);
    var bytes = File(filePath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
    fileSheets = excel.tables.keys.toList();
    obj = viewAbstract as ExcelableReaderInterace;
  }
  void init(BuildContext context) {
    List<String> listOfFields = viewAbstract.getMainFields(context: context);
    refreshDropdownList(context);
    for (var element in listOfFields) {
      if (obj
              .getExcelableRemovedFields()
              .firstWhereOrNull((p0) => p0 == element) !=
          null) continue;
      if (viewAbstract.isViewAbstract(element)) {
        ViewAbstract view = viewAbstract.getMirrorNewInstance(element);
        String? tableName = view.getTableNameApi();
        if (tableName != null) {
          generatedFieldsLabels[tableName] =
              view.getMainHeaderLabelTextOnly(context);
        }
        generatedMirrorNewInstance.addAll(view.getMirrorFieldsMapNewInstance());
        generatedFieldsIconMap.addAll(view.getFieldIconDataMap());
        generatedFieldsLabels.addAll(view.getFieldLabelMap(context));

        bool canBeNull = (viewAbstract.isFieldCanBeNullable(context, element));
        if (canBeNull == false) {
          generatedRequiredFields.addAll(view.isFieldRequiredMap());
        }
        int lengthOfChilds = view.getMainFields(context: context).length;

        bool hasViewAbstract = view
                .getMainFields(context: context)
                .firstWhereOrNull((p0) => view.isViewAbstract(p0)) !=
            null;

        if (!hasViewAbstract && lengthOfChilds > 1) {
          generatedGroupItems[GroupItem(
                      view.getMainHeaderLabelFileImporter(context),
                      view.getMainIconData())] =
                  view.getMainFields(context: context)
              // .map((e) => element + "_" + e)
              // .toList()
              ;
          // generatedMainFields.addAll(
          //     view.getMainFields(context: context).map((e) => e).toList());

          // allFields.add(value)
        } else {
          // generatedRequiredFields[element] =
          //     (viewAbstract.isFieldCanBeNullableMap()[element]) == false ??
          //         false;

          bool canBeNull =
              (viewAbstract.isFieldCanBeNullable(context, element));
          generatedRequiredFields[element] = canBeNull == false;

          generatedMainFields.add(element);
        }

        //check that no other view abstract or else
      } else {
        generatedRequiredFields[element] =
            viewAbstract.isFieldRequired(element);
        generatedMainFields.add(element);
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
  Map<GroupItem, List<String>> getMainFieldsGroups(BuildContext context) =>
      generatedGroupItems;
  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {"selectedSheet": ""}
    ..addAll(viewAbstract.getMirrorFieldsMapNewInstance());

  @override
  Map<String, IconData> getFieldIconDataMap() {
    return {"selectedSheet": Icons.document_scanner}
      ..addAll(generatedFieldsIconMap);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    return {"selectedSheet": AppLocalizations.of(context)!.sheets}
      ..addAll(generatedFieldsLabels);
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ["selectedSheet", ...generatedMainFields];
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
  FileReaderObject getSelfNewInstance() {
    return FileReaderObject(viewAbstract: viewAbstract, filePath: filePath);
  }

  bool checkHasViewAbstract(BuildContext context, ViewAbstract view) {
    debugPrint("checkHasViewAbstract");
    return view
            .getMainFields(context: context)
            .firstWhereOrNull((p0) => view.isViewAbstract(p0)) !=
        null;
  }

  void refreshDropdownList(BuildContext context) {
    List<String> listOfFields = viewAbstract.getMainFields(context: context);

    if (generatedFieldsAutoCompleteCustom.isEmpty) {
      generatedFieldsAutoCompleteCustom = {};

      for (var element in listOfFields) {
        if (viewAbstract.isViewAbstract(element)) {
          ViewAbstract view = viewAbstract.getMirrorNewInstance(element);
          view.getMainFields().forEach((element) {
            generatedFieldsAutoCompleteCustom[element] = fileColumns;
          });
          int lengthOfChilds = view.getMainFields(context: context).length;
          bool hasViewAbstract = checkHasViewAbstract(context, view);
          if (!hasViewAbstract && lengthOfChilds > 1) {
          } else {
            generatedFieldsAutoCompleteCustom[element] = fileColumns;
          }

          //check that no other view abstract or else
        } else {
          generatedFieldsAutoCompleteCustom[element] = fileColumns;
        }
      }
    } else {
      for (var element in generatedFieldsAutoCompleteCustom.entries) {
        generatedFieldsAutoCompleteCustom[element.key] = fileColumns;
      }
    }
  }

  @override
  FileReaderObject? onAfterValidate(BuildContext context) {
    debugPrint("onAfterValidate fileColumns $fileColumns");
    if (fileColumns.isEmpty) return null;

    return super.onAfterValidate(context);
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onDropdownChanged(context, field, value);
    if (field == "selectedSheet") {
      debugPrint("onDropdownChanged selectedSheet $value");
      selectedSheet = value.toString();
      var f = excel.tables[value.toString()]?.rows;
      if (f != null && f.isNotEmpty) {
        fileColumns = f[0].map((e) => e!.value.toString()).toList();
      } else {
        fileColumns = [];
      }
      notifyOtherControllers(context: context, formKey: formKey);
    } else {
      selectedFields[field] = value.toString();
      debugPrint("selectedFields $selectedFields");
    }
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    debugPrint("getTextInputIsAutoCompleteCustomListMap");
    Map<String, List> list = {};
    list["selectedSheet"] = fileSheets;
    refreshDropdownList(context);
    list.addAll(generatedFieldsAutoCompleteCustom);
    return list;
  }

  ViewAbstract getObjectFromRow(BuildContext context, List<Data?> list) {
    ViewAbstract view = viewAbstract.getSelfNewInstance();
    debugPrint(
        "getDataFromExcelTable getObjectFromRow started with type ${view.runtimeType}");
    Map<String, dynamic> generatedJsonData = {};

    selectedFields.forEach((key, value) {
      int index = fileColumns.indexOf(value);
      Data? data = list[index];
      dynamic dataValue = data?.value;
      debugPrint(
          "getDataFromExcelTable getObjectFromRow selectedKey=>$key rowName:$value index:$index  data:$dataValue type ${dataValue.runtimeType}");

      if (dataValue is TextCellValue) {
        bool res = dataValue.value.isEmpty ||
            dataValue.value == "null" ||
            dataValue.value == "";
        debugPrint(
            "getDataFromExcelTable key : $key dataValue is TextCellValue   dataValue isEmpty =>$res ");
        dataValue = res ? null : dataValue.value;
      }
      // checking if the main viewAbstract has main field
      String? field = view.getMainFields().firstWhereOrNull((p0) => p0 == key);
      debugPrint("getDataFromExcelTable founded field $field");

      if (field == null) {
        debugPrint(
            "getDataFromExcelTable getObjectFromRow field == null searching for main viewAbstract in the subViewAbstract");
        var obj = view
            .getMainFields()
            .where((element) => view.isViewAbstract(element) == true)
            .map((e) => view.getMirrorNewInstance(e))
            .cast<ViewAbstract>();

        for (var element in obj) {
          debugPrint(
              "getDataFromExcelTable getObjectFromRow field == null searching for main object from => ${element.runtimeType} for field =>  $key");

          String? field =
              element.getMainFields().firstWhereOrNull((p0) => p0 == key);
          if (field != null) {
            debugPrint(
                "getDataFromExcelTable getObjectFromRow field == null founded main object is => ${element.runtimeType} for field =>  $key");

            var allFieldsThatFromSameObj = element
                .getMainFields()
                .where((element) =>
                    selectedFields.keys.firstWhereOrNull((k) => k == element) !=
                    null)
                .toList();

            debugPrint(
                "getDataFromExcelTable getObjectFromRow founded main object is => ${element.runtimeType} for field =>  $key and all the fields that from same object are => $allFieldsThatFromSameObj");

            Map<String, dynamic> fieldsValues = {};
            for (var element in allFieldsThatFromSameObj) {
              var s = selectedFields.entries
                  .firstWhereOrNull((p0) => p0.key == element);
              if (s != null) {
                int index = fileColumns.indexOf(s.value);
                Data? data = list[index];
                dynamic dataValue = data?.value;
                fieldsValues[element] = dataValue;
              }
            }

            debugPrint(
                "getDataFromExcelTable getObjectFromRow founded main object is => ${element.runtimeType} for field =>  $key and all the fields values is  => $fieldsValues");

            if (fieldsValues.entries.length == 1) {
              generatedJsonData[element.getTableNameApi()!] =
                  ((element.getSelfNewInstanceFileImporter(
                              context: context,
                              field: fieldsValues.keys.toList().first,
                              value: fieldsValues.values.toList().first)
                          as ViewAbstract?)
                      ?.toJsonViewAbstract());
            } else {
              generatedJsonData[element.getTableNameApi()!] =
                  ((element.getSelfNewInstanceFileImporter(
                          context: context,
                          value: fieldsValues) as ViewAbstract?)
                      ?.toJsonViewAbstract());
            }
          }
        }

        //then its from subViewAbstract;
      } else {
        if (view.isViewAbstract(field)) {
          generatedJsonData[field] = dataValue == null
              ? null
              : (((view.getMirrorNewInstance(field) as ViewAbstract)
                      .getSelfNewInstanceFileImporter(
                          context: context,
                          field: field,
                          value: dataValue) as ViewAbstract?)
                  ?.toJsonViewAbstract());
          debugPrint(
              "getDataFromExcelTable getObjectFromRow adding generatedJsonDataisViewAbstract => label:$field value :${view.castFieldValue(field, dataValue)}  type: ${view.getMirrorFieldType(field)}");
          debugPrint(
              "getDataFromExcelTable getObjectFromRow adding generatedJsonDataisViewAbstract => label ${view.getTableNameApi()} value :${generatedJsonData[view.getTableNameApi()!]}");
        } else {
          debugPrint(
              "getDataFromExcelTable getObjectFromRow adding generatedJsonData => label:$field value :${view.castFieldValue(field, dataValue)}  type: ${view.getMirrorFieldType(field)}");

          generatedJsonData[field] =
              dataValue == null ? null : view.castFieldValue(field, dataValue);
        }
      }

      // view.getMainFields().forEach((element) {
      //   if (view.isViewAbstract(element)) {
      //     ViewAbstract subViewAbstract = view.getMirrorNewInstance(element);
      //     bool hasViewAbstract = checkHasViewAbstract(context, view);
      //     if (!hasViewAbstract) {
      //     } else {
      //     }
      //   } else {

      //     generatedJsonData[]
      //   }
      // });
    });
    debugPrint(
        "getDataFromExcelTable getObjectFromRow finished with json $generatedJsonData");

    return (view.fromJsonViewAbstract(generatedJsonData) as ViewAbstract)
        .copyWithSetNewFileReader();
  }

  @override
  dynamic getFieldValue(String field, {BuildContext? context}) {
    // var value =
    //     selectedFields.entries.firstWhereOrNull((p0) => p0.key == field);
    // // debugPrint(
    // //     "getFieldValue from file_reader_objcet field => $field selectedFields=> $selectedFields value => ${value?.value}");
    // if (value != null) return value.value;
    String fieldName = generatedFieldsLabels[field] ?? field;
    String? findedInTable = fileColumns.firstWhereOrNull((f) =>
        f.toLowerCase().contains(fieldName.toLowerCase()) ||
        f.toLowerCase().startsWith(fieldName.toLowerCase()));
    debugPrint(
        "getFieldValue from file_reader_objcet field => $field fieldName=>$fieldName   finedeInTable => $findedInTable  => generatedFieldsLabels => $generatedFieldsLabels");
    if (findedInTable != null) {
      return findedInTable;
    }

    return super.getFieldValue(field, context: context);
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
    return "viewAbstract: $viewAbstract , selectedSheet : $selectedSheet , fileColumns: $fileColumns, excel: $excel selectedFields: $selectedFields";
  }

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"selectedSheet": true}..addAll(generatedRequiredFields);

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  FileReaderObject fromJsonViewAbstract(Map<String, dynamic> json) =>
      FileReaderObject(viewAbstract: viewAbstract, filePath: filePath);
}
