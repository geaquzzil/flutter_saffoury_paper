import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class PrintCommandAbstract<T> extends ViewAbstract<T> {
  String? requestIDs;
  String? actionMessage;
  String? imgLinkAndroidQRCode;
  PrinterOptions? printerOptions;
  ReportOptions? reportOptions;

  @JsonKey(ignore: true)
  dynamic printObject;

  String fieldSortBy = "";
  String fieldSortByAscDesc = "";
  String fieldSortByMaster = "";

  SortByType sortByType = SortByType.DESC;

  PrintCommandAbstract(this.printObject, {this.imgLinkAndroidQRCode})
      : super() {
    if (printObject == null) {
      debugPrint("PrintCommandAbstract No printObject found");
      return;
    }
    debugPrint("PrintCommandAbstract ${this.printObject}");
    ViewAbstract currentViewAbstract;

    if (printObject is List) {
      List list = printObject as List;
      currentViewAbstract = list[0] as ViewAbstract;
      List<String> ids =
          list.map((e) => (e as ViewAbstract).getIDString()).toList();
      requestIDs = jsonEncode(ids);
    } else {
      currentViewAbstract = printObject;
      List<String> ids = [currentViewAbstract.getIDString()];
      requestIDs = jsonEncode(ids);
    }
    actionMessage = currentViewAbstract.getTableNameApi() ?? "";
    printerOptions = PrinterOptions();
  }
  @override
  void onDropdownChanged(BuildContext context, String field, value) {
    if (field == "sortByType") {
      SortByType v = value as SortByType;
      fieldSortByAscDesc = v.toString();
    }
  }

  @override
  List<String> getMainFields() => ["printerOptions", "reportOptions"];

  bool isList() {
    return printObject is List;
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"reportOptions": true};
  @override
  Map<String, bool> isFieldRequiredMap() => {};
  @override
  IconData getMainIconData() => Icons.print;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      "${AppLocalizations.of(context)!.print} ${printObject?.getMainHeaderTextOnly(context)}";

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String? getSortByFieldName() => null;

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => null;
}
