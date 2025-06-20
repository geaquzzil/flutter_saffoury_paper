import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorates.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Governorate extends BaseWithNameString<Governorate> {
  Governorate() : super();
  @override
  Governorate getSelfNewInstance() {
    return Governorate();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.country;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  IconData getMainIconData() => Icons.map;
  @override
  String? getTableNameApi() => "governorates";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 15};

  factory Governorate.fromJson(Map<String, dynamic> data) =>
      _$GovernorateFromJson(data);

  Map<String, dynamic> toJson() => _$GovernorateToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Governorate fromJsonViewAbstract(Map<String, dynamic> json) =>
      Governorate.fromJson(json);
}
