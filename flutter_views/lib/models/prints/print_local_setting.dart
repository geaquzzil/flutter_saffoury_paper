
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

abstract class PrintLocalSetting<T> extends ViewAbstract<T> {
  PrinterOptions? printerOptions;
  ReportOptions? reportOptions;
  String? primaryColor;
  String? secondaryColor;
  PrintLocalSetting() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "printOptions": PrinterOptions(),
        "reportOptions": ReportOptions(),
        "sortByType": SortByType.DESC
      };
  @override
  List<String> getMainFields() => ["printerOptions", "reportOptions"];

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"reportOptions": true};
  @override
  Map<String, bool> isFieldRequiredMap() => {};
  @override
  IconData getMainIconData() => Icons.print;

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
