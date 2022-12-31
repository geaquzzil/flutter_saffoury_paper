import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../view_abstract_inputs_validaters.dart';

abstract class PrintLocalSetting<T> extends ViewAbstract<T> {
  PrinterOptions? printerOptions;
  ReportOptions? reportOptions;
  bool? hideQrCode = false;
  String? primaryColor;
  String? secondaryColor;
  bool hasMultiplePageFormats = true;

  bool? hideTermsOfService = false;
  bool? hideAdditionalNotes = false;

  PrintLocalSetting() : super();

  SortByType? getPrintableHasSortBy();

  String? getPrintableSortByName();

  T onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "printOptions": PrinterOptions(),
        "reportOptions": ReportOptions(),
        "hideQrCode": false,
        "sortByType": SortByType.DESC,
        "hideTermsOfService": false,
        "hideAdditionalNotes": false,
      };
  @override
  List<String> getMainFields({BuildContext? context}) => [
        "printerOptions",
        "reportOptions",
        "hideQrCode",
        "primaryColor",
        "secondaryColor",
        "hideAdditionalNotes",
        "hideTermsOfService",
      ];

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "hideQrCode": AppLocalizations.of(context)!.hideQrCode,
        "primaryColor": AppLocalizations.of(context)!.primaryColor,
        "secondaryColor": AppLocalizations.of(context)!.secondaryColor,
        "hideTermsOfService": AppLocalizations.of(context)!.hideCompanyTerms,
        "hideAdditionalNotes": AppLocalizations.of(context)!.hideCompanyNotes,
      };
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideTermsOfService") {
      return AppLocalizations.of(context)!.hideCompanyTermsDes;
    } else if (field == "hideAdditionalNotes") {
      return AppLocalizations.of(context)!.hideCompanyNotesDes;
    }
    return "";
  }

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "primaryColor") {
      return ViewAbstractControllerInputType.COLOR_PICKER;
    }
    if (field == "secondaryColor") {
      return ViewAbstractControllerInputType.COLOR_PICKER;
    }
    return ViewAbstractControllerInputType.CHECKBOX;
  }

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
