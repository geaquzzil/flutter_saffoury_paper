import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_options.g.dart';

@JsonSerializable()
@reflector
class ReportOptions extends ViewAbstract<ReportOptions> {
  String? reportHeader;
  String? reportFooter;
  ReportOptions() : super();

  @override
  ReportOptions getSelfNewInstance() {
    return ReportOptions();
  }

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["reportHeader", "reportFooter"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "reportHeader": Icons.title,
        "reportFooter": Icons.format_underlined_outlined
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "reportHeader": AppLocalizations.of(context)!.reportHeader,
        "reportFooter": AppLocalizations.of(context)!.report_footer
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.reportOption;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.document_scanner;

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
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"reportHeader": TextInputType.text, "reportFooter": TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ReportOptions fromJsonViewAbstract(Map<String, dynamic> json) =>
      ReportOptions.fromJson(json);

  factory ReportOptions.fromJson(Map<String, dynamic> data) =>
      _$ReportOptionsFromJson(data);

  Map<String, dynamic> toJson() => _$ReportOptionsToJson(this);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "reportHeader": "",
        "reportFooter": "",
      };

  // @override
  // Map<String, Type> getMirrorFieldsTypeMap() =>
  //     {"reportHeader": String, "reportFooter": String};

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
}
