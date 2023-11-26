import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

@reflector
class Blocking extends ViewAbstractStandAloneCustomView<Blocking> {
  BlockMood blockMood;
  Customer customer;
  bool block;
  Blocking(this.customer, this.blockMood, this.block) : super();

  @override
  Blocking getSelfNewInstance() {
    //TODO
    return Blocking(Customer(), BlockMood.CUSTOMER, true);
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"blockMood": BlockMood.ALL, "customer": Customer(), "block": false};
  @override
  Map<String, IconData> getFieldIconDataMap() => {"block": Icons.block};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"block": AppLocalizations.of(context)!.block};

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["customer", "blockMood", "block"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${AppLocalizations.of(context)!.block} ${customer.getMainHeaderTextOnly(context)}";

  @override
  IconData getMainIconData() => Icons.block;

  @override
  String? getTableNameApi() => "action_block";
  @override
  String? getCustomAction() => "action_block";

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  Blocking fromJsonViewAbstract(Map<String, dynamic> json) => Blocking(
      Customer.fromJson(json['customer']),
      $enumDecodeNullable(_$BlockMood, json['blockMood']) ?? BlockMood.NONE,
      json['block'] as bool);

  String getTableName() {
    switch (blockMood) {
      case BlockMood.NONE:
      case BlockMood.ALL:
        return blockMood.toString();
      // break;
      case BlockMood.CUSTOMER:
        return "customers";
      // break;
      case BlockMood.EMPLOYEE:
        return "employees";
      //break;
    }
    return "";
  }

  @override
  Map<String, String> get getCustomMap => {
        "iD": customer.iD.toString(),
        "tableName": getTableName(),
        "blockValue": block ? "0" : "1"
      };

  @override
  ResponseType getCustomStandAloneResponseType() {
    // TODO: implement getCustomStandAloneResponseType
    throw UnimplementedError();
  }

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    // TODO: implement getCustomStandAloneWidget
    throw UnimplementedError();
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) => null;
}

const _$BlockMood = {
  BlockMood.ALL: 'ALL',
  BlockMood.NONE: 'NONE',
  BlockMood.CUSTOMER: 'CUSTOMER',
  BlockMood.EMPLOYEE: 'EMPLOYEE',
};

enum BlockMood implements ViewAbstractEnum<BlockMood> {
  ALL,
  NONE,
  CUSTOMER,
  EMPLOYEE,
  ;

  @override
  IconData getMainIconData() {
    return Icons.block;
  }

  @override
  String getMainLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.blockMood;
  }

  @override
  String getFieldLabelString(BuildContext context, BlockMood field) {
    switch (field) {
      case NONE:
        return AppLocalizations.of(context)!.none;
      case ALL:
        return AppLocalizations.of(context)!.allClintes;

      case CUSTOMER:
        return AppLocalizations.of(context)!.customer;

      case EMPLOYEE:
        return AppLocalizations.of(context)!.employee;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, BlockMood field) {
    switch (field) {
      case NONE:
        return Icons.disabled_by_default;
      case ALL:
        return Icons.all_inbox;
      case CUSTOMER:
        return Icons.account_circle;

      case EMPLOYEE:
        return Icons.engineering;
    }
  }

  @override
  List<BlockMood> getValues() {
    return BlockMood.values;
  }
}
