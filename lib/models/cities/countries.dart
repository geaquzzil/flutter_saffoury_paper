import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'countries.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Country extends BaseWithNameString<Country> {
  Country() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance();
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.country;
  }

  @override
  IconData getMainIconData() => Icons.location_city;
  @override
  String? getTableNameApi() => "countries";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

  factory Country.fromJson(Map<String, dynamic> data) =>
      _$CountryFromJson(data);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Country fromJsonViewAbstract(Map<String, dynamic> json) =>
      Country.fromJson(json);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;
}
