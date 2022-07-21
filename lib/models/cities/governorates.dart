import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'governorates.g.dart';

@JsonSerializable()
@reflector
class Governorate extends BaseWithNameString<Governorate> {
  String? name;
  Governorate() : super();

   @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.country;
  }

  @override
  IconData getMainIconData() => Icons.map;
  @override
  String? getTableNameApi() => "governorates";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 15};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Governorate fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
