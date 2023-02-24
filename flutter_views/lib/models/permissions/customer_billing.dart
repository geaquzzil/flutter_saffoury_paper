import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'permission_level_abstract.dart';
import 'setting.dart';
part 'customer_billing.g.dart';
@reflector
@JsonSerializable(explicitToJson: true)
class BillingCustomer extends AuthUser<BillingCustomer> {
  BillingCustomer() : super();
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
