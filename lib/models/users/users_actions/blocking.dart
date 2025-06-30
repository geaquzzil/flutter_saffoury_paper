// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:json_annotation/json_annotation.dart';

@reflector
class Blocking extends ViewAbstractStandAloneCustomViewApi<Blocking> {
  BlockMood blockMood;
  User user;
  Blocking(this.user, this.blockMood, {super.iD}) : super();

  @override
  Blocking getSelfNewInstance() {
    return Blocking(Customer(), BlockMood.BLOCK);
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"blockMood": BlockMood.BLOCK, "user": User(), "block": false};
  @override
  Map<String, IconData> getFieldIconDataMap() => {"block": Icons.block};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"block": AppLocalizations.of(context)!.block};

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["user", "blockMood", "block"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${AppLocalizations.of(context)!.block} ${user.getMainHeaderTextOnly(context)}";

  @override
  IconData getMainIconData() => Icons.block;

  @override
  String? getCustomAction() {
    String tableName = user.getTableNameApi()!;
    return "block/$tableName/";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  Blocking fromJsonViewAbstract(Map<String, dynamic> json) => Blocking(
      Customer.fromJson(json['user']),
      $enumDecodeNullable(_$BlockMood, json['blockMood']) ?? BlockMood.NONE,
      json['block'] as bool);

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

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return null;
  }
}

const _$BlockMood = {
  BlockMood.BLOCK: 'BLOCK',
  BlockMood.UNBLOCK: 'UNBLOCK',
};

enum BlockMood implements ViewAbstractEnum<BlockMood> {
  BLOCK,
  UNBLOCK,
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
      case BLOCK:
        return AppLocalizations.of(context)!.block;
      case UNBLOCK:
        return AppLocalizations.of(context)!.unBlock;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, BlockMood field) {
    switch (field) {
      case BLOCK:
        return Icons.block;
      case UNBLOCK:
        return Icons.disabled_by_default_outlined;
    }
  }

  @override
  List<BlockMood> getValues() {
    return BlockMood.values;
  }
}
