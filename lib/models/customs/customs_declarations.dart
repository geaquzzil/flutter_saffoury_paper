import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations_images.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'customs_declarations.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomsDeclaration extends ViewAbstract<CustomsDeclaration> {
  int? EmployeeID;

  String? number; //varchar 200
  String? date;

  String? fromCountry; //59
  String? fromName; //50
  String? comments;

  List<CustomerDeclarationImages>? customs_declarations_images;
  int? customs_declarations_images_count;
  Employee? employees;

  CustomsDeclaration() : super();

  @override
  List<String> getMainFields() =>
      ["number", "date", "fromCountry", "fromName", "comments"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "number": Icons.onetwothree,
        "date": Icons.date_range,
        "fromCountry": Icons.domain,
        "fromName": Icons.account_circle,
        "comments": Icons.notes
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "number": AppLocalizations.of(context)!.customsNumber,
        "date": AppLocalizations.of(context)!.date,
        "fromCountry": AppLocalizations.of(context)!.country,
        "fromName": AppLocalizations.of(context)!.name,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customs_clearnces;

  @override
  String getMainHeaderTextOnly(BuildContext context) => "$number : $comments";

  @override
  IconData getMainIconData() => Icons.document_scanner;

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "customs_declarations";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() =>
      {"fromCountry": true, "fromName": true};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
        "number": true,
      };

  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"number": 200, "fromCountry": 50, "fromName": 50};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "number": TextInputType.number,
        "date": TextInputType.datetime,
        "fromCountry": TextInputType.text,
        "fromName": TextInputType.text,
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"number": true};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  CustomsDeclaration fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
