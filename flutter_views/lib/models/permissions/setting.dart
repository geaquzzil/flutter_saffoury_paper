// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
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
  Setting() : super() {
    date = "".toDateTimeNowString();
  }
  String getPriceAndCurrency(BuildContext context, double value) {
    return getPriceFromSetting(value)
        .toCurrencyFormat(symbol: " ${getPriceCurrencyFromSetting(context)} ");
  }

  double getPriceSYPEquality(double value) {
    return value * EXCHANGE_RATE.toNonNullable();
  }

  double getPriceFromSetting(double value) {
    switch (currency) {
      case CurrencySetting.DOLLAR:
        return value;
      case CurrencySetting.SYP:
        return value * EXCHANGE_RATE.toNonNullable();
      case CurrencySetting.DOLLAR_THREE_ZERO:
        return value * 1000;
      default:
        return value * 1000;
    }
  }

  String getPriceCurrencyFromSetting(BuildContext context) {
    switch (currency) {
      case CurrencySetting.DOLLAR:
        return r"$";
        return AppLocalizations.of(context)!.dollarSymbol;
      case CurrencySetting.SYP:
        return "SYP";
        return AppLocalizations.of(context)!.syp;
      case CurrencySetting.DOLLAR_THREE_ZERO:
        return r"$";
        return AppLocalizations.of(context)!.sypDots;
      default:
        return AppLocalizations.of(context)!.sypDots;
    }
  }

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
  List<String> getMainFields({BuildContext? context}) {
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
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Setting getSelfNewInstance() {
    return Setting();
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

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() {
    // TODO: implement getMirrorFieldsMapNewInstance
    throw UnimplementedError();
  }

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
     return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}

enum CurrencySetting { DOLLAR, DOLLAR_THREE_ZERO, SYP }
