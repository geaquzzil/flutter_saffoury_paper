import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'permission_level_abstract.dart';
import 'setting.dart';
part 'customer_billing.g.dart';

@reflector
@JsonSerializable(explicitToJson: true)
class BillingCustomer extends AuthUser<BillingCustomer> {
  String? name; //var 100
  String? email; //var 50
  String? token; // text
  int? activated; //tinyint
  String? date; //date
  String? city; // varchar 20
  String? address; // text
  String? profile; //text
  String? comments; //text

  @override
  IconData? getMainDrawerGroupIconData() => Icons.manage_accounts_sharp;

  @override
  Map<String, dynamic> getMirrorFieldsNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "name": "",
          "email": "",
          "token": "",
          "activated": 0,
          "date": "",
          "city": "",
          "address": "",
          "profile": "",
          "comments": "",
        });

  BillingCustomer() : super() {
    date = "".toDateTimeNowString();
  }
  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "name",
      "phone",
      "password",
      "date",
      "email",
      "city",
      "address",
      "comments"
    ];
  }

  @override
  String getFieldToReduceSize() {
    return "name";
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "name": getMainHeaderLabelTextOnly(context),
        "phone": AppLocalizations.of(context)!.phone_number,
        "password": AppLocalizations.of(context)!.password,
        "date": AppLocalizations.of(context)!.date,
        "email": AppLocalizations.of(context)!.email,
        "city": AppLocalizations.of(context)!.city,
        "address": AppLocalizations.of(context)!.address1,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() =>
      {"city": true, "address": true};
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "name": 100,
        "phone": 10,
        "password": 10,
        "email": 50,
        "city": 20,
      };

  @override
  String? getCustomAction() {
    return null;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "name": getMainIconData(),
        "phone": Icons.phone,
        "date": Icons.date_range,
        "password": Icons.password,
        "email": Icons.email,
        "city": Icons.location_city,
        "address": Icons.map,
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) => name ?? "not found";

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "name": TextInputType.name,
        "phone": TextInputType.phone,
        "date": TextInputType.datetime,
        "password": TextInputType.visiblePassword,
        "email": TextInputType.emailAddress,
        "address": TextInputType.streetAddress,
        "city": TextInputType.text,
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "name": true,
        "phone": true,
        "password": true,
        "address": true,
        "city": true,
        "email": true
      };

  @override
  String getSortByFieldName() {
    return "name";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
  }

  @override
  BillingCustomer getSelfNewInstance() {
    return BillingCustomer();
  }

  @override
  String getForeignKeyName() {
    return "CustomerID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "cash": 0,
        });

  @override
  IconData getMainIconData() {
    return Icons.account_circle;
  }

  @override
  String? getTableNameApi() {
    return "customers";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  factory BillingCustomer.fromJson(Map<String, dynamic> data) =>
      _$BillingCustomerFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$BillingCustomerToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  BillingCustomer fromJsonViewAbstract(Map<String, dynamic> json) =>
      BillingCustomer.fromJson(json);
}
