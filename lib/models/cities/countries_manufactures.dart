import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/cities/manufactures.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'countries.dart';

part 'countries_manufactures.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CountryManufacture extends ViewAbstract<CountryManufacture> {
  // int? CountryID;
  // int? ManufacturerID;
  Country? countries;

  Manufacture? manufactures;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "countries": Country(),
        "manufactures": Manufacture(),
      };

  CountryManufacture() : super();
  @override
  String getForeignKeyName() {
    return "Country_Manufacture_CompanyID";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ["countries", "manufactures"];
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.manufacture;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "${countries?.getMainHeaderLabelTextOnly(context)}:${manufactures?.getMainHeaderTextOnly(context)}";
  }

  @override
  IconData getMainIconData() => Icons.maps_home_work_rounded;

  @override
  String? getTableNameApi() => "countries_manufactures";

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
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() =>
      {"countries": false, "manufactures": false};

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"countries": true, "manufactures": true};

  factory CountryManufacture.fromJson(Map<String, dynamic> data) =>
      _$CountryManufactureFromJson(data);

  Map<String, dynamic> toJson() => _$CountryManufactureToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CountryManufacture fromJsonViewAbstract(Map<String, dynamic> json) =>
      CountryManufacture.fromJson(json);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  CountryManufacture getSelfNewInstance() {
    return CountryManufacture();
  }

  @override
  bool shouldWrapWithExpansionCardWhenChild() {
    return false;
  }

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
