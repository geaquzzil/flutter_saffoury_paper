import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations_images.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'customs_declarations.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomsDeclaration extends ViewAbstract<CustomsDeclaration> {
  // int? EmployeeID;

  String? number; //varchar 200
  String? date;

  String? fromCountry; //59
  String? fromName; //50
  String? comments;

  List<CustomsDeclarationImages>? customs_declarations_images;
  int? customs_declarations_images_count;
  Employee? employees;

  CustomsDeclaration() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {

    "number":"",
    "date":"",
    "fromCountry": "",
    "fromName":"",
    "comments": "",
    "customs_declarations_images": List<CustomsDeclarationImages>.empty(),
    "customs_declarations_images_count":0,
    "employees":Employee(),
  };
  @override
  List<String> getMainFields() =>
      ["employees", "number", "date", "fromCountry", "fromName", "comments"];

  @override
  List<String>? requireObjectsList() => ["customs_declarations_images"];

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

  factory CustomsDeclaration.fromJson(Map<String, dynamic> data) =>
      _$CustomsDeclarationFromJson(data);

  Map<String, dynamic> toJson() => _$CustomsDeclarationToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CustomsDeclaration fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomsDeclaration.fromJson(json);
}
