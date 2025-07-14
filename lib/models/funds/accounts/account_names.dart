import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_names.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class AccountName extends BaseWithNameString<AccountName> {
  // int? TypeID;
  AccountNameType? account_names_types;
  AccountName() : super();
  @override
  AccountName getSelfNewInstance() {
    return AccountName();
  }

  @override
  String getForeignKeyName() {
    return "NameID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "account_names_types": AccountNameType(),
        });

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"account_names_types": true};

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["name", "account_names_types"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.account_name;
  }

  @override
  IconData getMainIconData() => Icons.document_scanner_sharp;
  @override
  String? getTableNameApi() => "account_names";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

  factory AccountName.fromJson(Map<String, dynamic> data) =>
      _$AccountNameFromJson(data);

  Map<String, dynamic> toJson() => _$AccountNameToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  AccountName fromJsonViewAbstract(Map<String, dynamic> json) =>
      AccountName.fromJson(json);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;
}

@JsonSerializable(explicitToJson: true)
@reflector
class AccountNameType extends ViewAbstract<AccountNameType> {
  String? type;
  String? typeAr;

  List<AccountName>? account_names;
  int? account_names_count;

  AccountNameType() : super();
  @override
  AccountNameType getSelfNewInstance() {
    return AccountNameType();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "type": "",
        "typeAr": "",
        "account_names": List<AccountName>.empty(),
        "account_names_count": 0
      };

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"type": getMainIconData(), "typeAr": getMainIconData()};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "type": AppLocalizations.of(context)!.name,
        "typeAr": AppLocalizations.of(context)!.nameInArabic
      };

  @override
  List<String> getMainFields({BuildContext? context}) => ["type", "typeAr"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.accountType;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      type ?? "not found for TYPE";

  @override
  IconData getMainIconData() => Icons.type_specimen;

  @override
  String? getTableNameApi() => "account_names_types";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};
  @override
  FormFieldControllerType getInputType(String field) {
    if ("type" == field) {
      return FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE;
    }
    return super.getInputType(field);
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"type": true};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"type": 255, "typeAr": 255};
  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"type": TextInputType.text, "typeAr": TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"type": true};
  factory AccountNameType.fromJson(Map<String, dynamic> data) =>
      _$AccountNameTypeFromJson(data);

  Map<String, dynamic> toJson() => _$AccountNameTypeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  AccountNameType fromJsonViewAbstract(Map<String, dynamic> json) =>
      AccountNameType.fromJson(json);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;

  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return RequestOptions().addSortBy("type", SortByType.DESC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
