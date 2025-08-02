import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:json_annotation/json_annotation.dart';

class User<T> extends UserLists<T> {
  String? name; //var 100
  String? email; //var 50
  int? activated; //tinyint
  String? date; //date
  String? city; // varchar 20
  String? address; // text
  String? profile; //text
  @JsonKey(fromJson: convertToStringFromString)
  String? comments; //text

  @override
  IconData? getMainDrawerGroupIconData() => Icons.manage_accounts_sharp;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()..addAll({
        "name": "",
        "email": "",
        "activated": 0,
        "date": "",
        "city": "",
        "address": "",
        "profile": "",
        "comments": "",
      });
  User() : super() {
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
      "comments",
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
    "comments": AppLocalizations.of(context)!.comments,
    "balance": AppLocalizations.of(context)!.balance,
    "totalCredits": AppLocalizations.of(context)!.credits,
    "totalDebits": AppLocalizations.of(context)!.debits,
    "totalOrders": AppLocalizations.of(context)!.orders,
    "totalPurchases": AppLocalizations.of(context)!.purchases,
    "termsDate": AppLocalizations.of(context)!.termsDate,
  };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {
    "email": true,
    "city": true,
    "address": true,
  };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
    "name": 100,
    "phone": 10,
    "password": 10,
    "email": 50,
    "city": 20,
  };

  @override
  List<String>? getCustomAction() {
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
    "comments": Icons.comment,
  };

  @override
  String getMainHeaderTextOnly(BuildContext context) => name ?? "";
  @override
  FutureOr<List>? getTextInputValidatorIsUnique(
    BuildContext context,
    String field,
    String? currentText,
  ) {
    if (getParent == null) {
      if (field == 'email') {
        return searchByFieldName(
          context: context,
          field: 'email',
          searchQuery: currentText ?? "",
        );
      } else if (field == 'phone') {
        return searchByFieldName(
          context: context,
          field: 'phone',
          searchQuery: currentText ?? "",
        );
      } else if (field == 'name') {
        return searchByFieldName(
          context: context,
          field: 'name',
          searchQuery: currentText ?? "",
        );
      }
    }
    return super.getTextInputValidatorIsUnique(context, field, currentText);
  }

  @override
  Map<String, dynamic>? copyWithFormValues({Map<String, dynamic>? values}) {
    return {'name': values?['text']};
  }

  @override
  FormFieldControllerType getInputType(String field) {
    if ("name" == field) {
      return FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE;
    }
    return super.getInputType(field);
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
    "name": true,
  };

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
    "name": TextInputType.text,
    "phone": TextInputType.phone,
    "date": TextInputType.datetime,
    "password": TextInputType.visiblePassword,
    "email": TextInputType.emailAddress,
    "address": TextInputType.streetAddress,
    "city": TextInputType.text,
    "comments": TextInputType.multiline,
    "balance": TextInputType.number,
    "totalCredits": TextInputType.number,
    "totalDebits": TextInputType.number,
    "totalOrders": TextInputType.number,
    "totalPurchases": TextInputType.number,
    "termsDate": TextInputType.datetime,
  };

  @override
  Map<String, bool> isFieldRequiredMap() => {
    "name": true,
    "phone": true,
    "password": true,
  };

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addSortBy("name", SortByType.ASC);
  }

  double getTotalAnalsis(List<GrowthRate>? growthRateList) {
    if (growthRateList?.length == 1) {
      return growthRateList![0].total!;
    }
    return GrowthRate.getTotal(growthRateList);
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.users;
}
