import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

import '../view_abstract_inputs_validaters.dart';

abstract class PrintLocalSetting<T> extends ViewAbstract<T> {
  PrinterOptions? printerOptions;
  ReportOptions? reportOptions;
  bool? hideQrCode = false;
  String? primaryColor;
  String? secondaryColor;
  bool? hasMultiplePageFormats = true;

  bool? hideTermsOfService = false;
  bool? hideAdditionalNotes = false;

  bool? hideHeaderLogo = false;

  String? currentGroupNameFromList;
  int? currentGroupNameIndex;

  List? currentGroupList;

  PrintLocalSetting() : super();

  SortByType? getPrintableHasSortBy();

  String? getPrintableSortByName(BuildContext context);

  String? getPrintableGroupByName();

  T onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF);

  @override
  Map<String, IconData> getFieldIconDataMap() {
    return {
      "primaryColor": Icons.color_lens,
      "secondaryColor": Icons.color_lens
    };
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "reportOptions": ReportOptions(),
        "hideQrCode": false,
        "sortByType": SortByType.DESC,
        "hideTermsOfService": false,
        "hideAdditionalNotes": false,
        "hideHeaderLogo": true,
      };
  @override
  List<String> getMainFields({BuildContext? context}) => [
        // "printerOptions",
        "reportOptions",
        "primaryColor",
        "secondaryColor",
        "hideQrCode",
        // "hideAdditionalNotes",
        // "hideTermsOfService",
      ];

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "hideQrCode": AppLocalizations.of(context)!.hideQrCode,
        "primaryColor": AppLocalizations.of(context)!.primaryColor,
        "secondaryColor": AppLocalizations.of(context)!.secondaryColor,
        "hideTermsOfService": AppLocalizations.of(context)!.hideCompanyTerms,
        "hideAdditionalNotes": AppLocalizations.of(context)!.hideCompanyNotes,
        "hideHeaderLogo": AppLocalizations.of(context)!
            .hideFormat(AppLocalizations.of(context)!.companyLogo.toLowerCase())
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
  FormFieldControllerType getInputType(String field) {
    if (field == "primaryColor") {
      return FormFieldControllerType.COLOR_PICKER;
    }
    if (field == "secondaryColor") {
      return FormFieldControllerType.COLOR_PICKER;
    }
    return FormFieldControllerType.CHECKBOX;
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
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  String? getTableNameApi() => null;

  T copyWithEnableAll() {
    T t = getSelfNewInstance();
    getMirrorFieldsMapNewInstance().entries.forEach(
      (e) {
        Type? fieldType = getMirrorFieldType(e.key);
        if (fieldType == bool) {
          (t as ViewAbstract).setFieldValue(e.key, false);
        }
      },
    );
    return t;
  }
}
