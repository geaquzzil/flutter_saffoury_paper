import 'dart:convert';

import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class PrintCommand<T extends PrintCommand> extends ViewAbstract<T> {
  late String requestIDs;
  late String actionMessage;
  String? imgLinkAndroidQRCode;
  late PrinterOptions printerOptions;
  ReportOptions? reportOptions;

  @JsonKey(ignore: true)
  dynamic printObject;

  String fieldSortBy = "";
  String fieldSortByAscDesc = "";
  String fieldSortByMaster = "";

  SortByType sortByType = SortByType.DESC;
  List<String> 

  PrintCommand(this.printObject, {this.imgLinkAndroidQRCode}) : super() {
    ViewAbstract currentViewAbstract;
    if (printObject is List) {
      List list = printObject as List;
      currentViewAbstract = list[0] as ViewAbstract;
      List<String> ids =
          list.map((e) => (e as ViewAbstract).getIDString()).toList();
      requestIDs = jsonEncode(ids);
    } else {
      currentViewAbstract = printObject;
      List<String> ids = [(printObject as ViewAbstract).getIDString()];
      requestIDs = jsonEncode(ids);
    }
    actionMessage = currentViewAbstract.getTableNameApi() ?? "";
  }
  @override
  void onDropdownChanged(BuildContext context, String field, value) {
    if (field == "sortByType") {
      SortByType v = value as SortByType;
      fieldSortByAscDesc = v.toString();
    }
  }

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
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields() {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  String? getSortByFieldName() {
    // TODO: implement getSortByFieldName
    throw UnimplementedError();
  }

  @override
  SortByType getSortByType() {
    // TODO: implement getSortByType
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

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
