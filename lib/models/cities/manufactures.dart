import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manufactures.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Manufacture extends BaseWithNameString<Manufacture> {
  Manufacture() : super();
  @override
  Manufacture getSelfNewInstance() {
    return Manufacture();
  }

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
