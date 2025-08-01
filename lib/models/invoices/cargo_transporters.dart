import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/cities/governorates.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cargo_transporters.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CargoTransporter extends ViewAbstract<CargoTransporter> {
  // int? GovernorateID;

  String? name;
  int? phone;
  double? maxWeight;
  @JsonKey(fromJson: intFromString)
  String? carNumber;
  Governorate? governorates;

  CargoTransporter() : super();

  @override
  CargoTransporter getSelfNewInstance() {
    return CargoTransporter();
  }

  @override
  String getForeignKeyName() {
    return "CargoTransID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "name": "",
        "phone": 0,
        "maxWeight": 0.0.toDouble(),
        "carNumber": "",
        "governorates": Governorate()
      };
  @override
  List<String> getMainFields({BuildContext? context}) =>
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
  FormFieldControllerType getInputType(String field) {
    if (field == "governorates") {
      return FormFieldControllerType.VIEW_ABSTRACT_AS_ONE_FIELD;
    }
    return super.getInputType(field);
  }

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


  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    if (action == ServerActions.list) {
      return RequestOptions().addSortBy("name", SortByType.ASC);
    }
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
