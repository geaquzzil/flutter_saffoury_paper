import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/order_refund.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

class User<T> extends AuthUser {
  String? name; //var 100
  String? email; //var 50
  String? token; // text
  int? activated; //tinyint
  String? date; //date
  String? city; // varchar 20
  String? address; // text
  String? profile; //text
  String? comments; //text

  List<Order>? orders;
  int? orders_count;

  List<Purchases>? purchases;
  int? purchases_count;

  List<OrderRefund>? orders_refunds;
  int? orders_refunds_count;

  User() : super();
  @override
  List<String> getMainFields() {
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
      {"email": true, "city": true, "address": true};
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "name": 100,
        "phone": 10,
        "password": 10,
        "email": 50,
        "city": 20,
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "name": getMainIconData(),
        "phone": Icons.phone,
        "date": Icons.date_range,
        "password": Icons.password,
        "email": Icons.email,
        "city": Icons.location_city,
        "address": Icons.map,
        "comments": Icons.comment
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) => name ?? "not found";

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"name": true};

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
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"name": true, "phone": true, "password": true};

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
}
