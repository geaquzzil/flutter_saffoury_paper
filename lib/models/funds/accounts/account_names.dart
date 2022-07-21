import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'account_names.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class AccountName extends BaseWithNameString<AccountName> {
  // int? TypeID;
  AccountNameType? account_names_types;
  AccountName() : super();

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"account_names_types": true};

  @override
  List<String> getMainFields() => ["name", "account_names_types"];

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

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  AccountName fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

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
  Map<String, IconData> getFieldIconDataMap() =>
      {"type": getMainIconData(), "typeAr": getMainIconData()};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "type": AppLocalizations.of(context)!.name,
        "typeAr": AppLocalizations.of(context)!.nameInArabic
      };

  @override
  List<String> getMainFields() => ["type", "typeAr"];

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
  String? getSortByFieldName() => "type";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "account_names_types";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

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

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  AccountNameType fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;
}
