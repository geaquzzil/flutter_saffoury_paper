import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'manufactures.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Manufacture extends BaseWithNameString<Manufacture> {
  Manufacture() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.manufacture;
  }

  @override
  IconData getMainIconData() => Icons.location_city;
  @override
  String? getTableNameApi() => "manufactures";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  factory Manufacture.fromJson(Map<String, dynamic> data) =>
      _$ManufactureFromJson(data);

  Map<String, dynamic> toJson() => _$ManufactureToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Manufacture fromJsonViewAbstract(Map<String, dynamic> json) =>
      Manufacture.fromJson(json);
}
