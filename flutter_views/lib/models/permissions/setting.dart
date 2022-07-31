
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'setting.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Setting extends ViewAbstract<Setting> {
  int? ENABLE_APP;
  int? DISABLE_NOTIFICATIONS;
  int? ENABLE_MULTI_EDIT;
  int? EXCHANGE_RATE;
  int? OLD_EXCHANGE_RATE;
  int? BUY_EXCHANGE_RATE;
  int? BUY_EXCHANGE_RATE_OLD;
  String? date;
  CurrencySetting? currency;
  Setting() : super();

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields() {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  String? getSortByFieldName() {
    // TODO: implement getSortByFieldName
    throw UnimplementedError();
  }

  @override
  SortByType getSortByType() {
    // TODO: implement getSortByType
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }

   factory Setting.fromJson(Map<String, dynamic> data) =>
      _$SettingFromJson(data);

  Map<String, dynamic> toJson() => _$SettingToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Setting fromJsonViewAbstract(Map<String, dynamic> json) =>
      Setting.fromJson(json);
}

enum CurrencySetting { DOLLAR, DOLLAR_THREE_ZERO, SYP }
