import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
part 'warehouse.g.dart';

@JsonSerializable()
@reflector
class Warehouse extends BaseWithNameString<Warehouse> {
  Warehouse() : super();
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.warehouse;
  }

  @override
  IconData getMainIconData() => Icons.warehouse;
  @override
  String? getTableNameApi() => "warehouse";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 100};

  

   @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
  @override
  Warehouse fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
