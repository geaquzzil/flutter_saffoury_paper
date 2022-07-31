import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/cities/governorates.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'cargo_transporters.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CargoTransporter extends ViewAbstract<CargoTransporter> {
  // int? GovernorateID;

  String? name;
  String? phone;
  double? maxWeight;
  String? carNumber;
  Governorate? governorates;

  CargoTransporter() : super();
  @override
  List<String> getMainFields() =>
      ["name", "phone", "maxWeight", "carNumber", "governorates"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "name": getMainIconData(),
        "phone": Icons.phone,
        "maxWeight": Icons.scale,
        "carNumber": Icons.onetwothree,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "name": AppLocalizations.of(context)!.name,
        "phone": AppLocalizations.of(context)!.phone_number,
        "maxWeight": AppLocalizations.of(context)!.quantity,
        "carNumber": AppLocalizations.of(context)!.carNumber
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.transfers;
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.cargoTransporters;

  @override
  String getMainHeaderTextOnly(BuildContext context) => "$name: $carNumber";

  @override
  IconData getMainIconData() => Icons.local_shipping;

  @override
  String? getSortByFieldName() => "name";

  @override
  SortByType getSortByType() => SortByType.ASC;

  @override
  String? getTableNameApi() => "cargo_transporters";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "name": 32,
        "phone": 10,
        "maxWeight": 5,
        "carNumber": 10,
      };
  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"maxWeight": 500};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "name": TextInputType.text,
        "phone": TextInputType.phone,
        "maxWeight": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        "carNumber": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"governorates": false};

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "name": true,
        "phone": true,
        "maxWeight": true,
        "carNumber": true,
      };

  factory CargoTransporter.fromJson(Map<String, dynamic> data) =>
      _$CargoTransporterFromJson(data);

  Map<String, dynamic> toJson() => _$CargoTransporterToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CargoTransporter fromJsonViewAbstract(Map<String, dynamic> json) =>
      CargoTransporter.fromJson(json);
}
