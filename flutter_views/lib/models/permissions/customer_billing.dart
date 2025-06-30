import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

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
  String? birthday;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String year = "1900";
  @JsonKey(includeFromJson: false, includeToJson: false)
  String month = "1";
  @JsonKey(includeFromJson: false, includeToJson: false)
  String day = "1";

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> daysInMonth = [];
  @override
  IconData? getMainDrawerGroupIconData() => Icons.manage_accounts_sharp;

  BillingCustomer() : super(setPassword: false) {
    date = "".toDateTimeNowString();
    daysInMonth = List.generate(
      DateTime(int.parse(year), int.parse(month)).daysIn(),
      (index) => "$index",
    );
  }
  @override
  List<String> getMainFields({BuildContext? context}) {
    return [
      "name",
      "phone",
      "password",
      // "birthday",
      "email",
      "city",
      "address",
      // "comments"
    ];
  }

  @override
  Map<int, List<String>> getMainFieldsHorizontalGroups(BuildContext context) =>
      {
        0: ["year", "month", "day"]
      };

  @override
  String getFieldToReduceSize() {
    return "name";
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "name": AppLocalizations.of(context)!.name,
        "phone": AppLocalizations.of(context)!.phone_number,
        "password": AppLocalizations.of(context)!.password,
        "birthday": AppLocalizations.of(context)!.date,
        "email": AppLocalizations.of(context)!.email,
        "city": AppLocalizations.of(context)!.city,
        "address": AppLocalizations.of(context)!.address1,
        "comments": AppLocalizations.of(context)!.comments,
        "day": AppLocalizations.of(context)!.day,
        "month": AppLocalizations.of(context)!.month,
        "year": AppLocalizations.of(context)!.year
      };

//todo ON VALDATION NOT APPLIED TO FIELD WITH AUTO COMPLETE
  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};
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
        "birthday": Icons.date_range,
        "password": Icons.password,
        "email": Icons.email,
        "city": Icons.location_city,
        "address": Icons.map,
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) => name ?? "";

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};
  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
      BuildContext context) {
    List<String> list = List.empty(growable: true);
    for (int i = 1900; i <= DateTime.now().year; i++) {
      list.add("$i");
    }
    return {
      "year": list.reversed.toList(),
      "month": List.generate(11, (index) => "${index + 1}"),
      "day": daysInMonth
    };
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onDropdownChanged(context, field, value);
    if (field == "month") {
      month = value.toString();
      daysInMonth = List.generate(
        DateTime(int.parse(year), int.parse(month)).daysIn(),
        (index) => "$index",
      );
      //  generatedFieldsAutoCompleteCustom[field] = fileColumns;
      notifyOtherControllers(context: context, formKey: formKey);
    } else {
      setFieldValue(field, value);
    }
    birthday = DateTime(int.tryParse(year) ?? 0, int.tryParse(month) ?? 0,
            int.tryParse(day) ?? 0)
        .toDateTimeStringOnlyDate();
    debugPrint("birthday now is $birthday");
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "name": TextInputType.name,
        "phone": TextInputType.phone,
        "birthday": TextInputType.datetime,
        "password": TextInputType.visiblePassword,
        "email": TextInputType.emailAddress,
        "address": TextInputType.streetAddress,
        "city": TextInputType.text,
        "comments": TextInputType.multiline
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {
        "name": true,
        "phone": true,
        "password": true,
        "address": true,
        "city": true,
        "email": true,
        "month": true,
        "year": true,
        "day": true,
      };


  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
   return RequestOptions().addSortBy("name", SortByType.ASC);
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
          "name": "",
          "email": "",
          "token": "",
          "month": "1",
          "year": "1900",
          "day": "1",
          "activated": 0,
          "birthday": "",
          "city": "",
          "address": "",
          "profile": "",
          "comments": "",
          "cash": 0
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
