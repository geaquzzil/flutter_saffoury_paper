import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
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

  List<CutRequest>? cut_requests;
  int? cut_requests_count;

  List<Order>? orders;
  int? orders_count;

  List<Purchases>? purchases;
  int? purchases_count;

  List<OrderRefund>? orders_refunds;
  int? orders_refunds_count;

  List<PurchasesRefund>? purchases_refunds;
  int? purchases_refunds_count;

  List<CustomerRequestSize>? customers_request_sizes;
  int? customers_request_sizes_count;

  List<ReservationInvoice>? reservation_invoice;
  int? reservation_invoice_count;

  List<ProductInput>? products_inputs; //employee only
  int? products_inputs_count;

  List<ProductOutput>? products_outputs; //employee only
  int? products_outputs_count;

  List<Transfers>? transfers; //employee only
  int? transfers_count;

  List<CargoTransporter>? cargo_transporters; //employee only
  int? cargo_transporters_count;

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
          "cut_requests": List<CutRequest>.empty(),
          "cut_requests_count": 0,
          "orders": List<Order>.empty(),
          "orders_count": 0,
          "purchases": List<Purchases>.empty(),
          "purchases_count": 0,
          "orders_refunds": List<OrderRefund>.empty(),
          "orders_refunds_count": 0,
          "purchases_refunds_count": 0,
          "purchases_refunds": List<PurchasesRefund>.empty(),
          "customers_request_sizes": List<CustomerRequestSize>.empty(),
          "customers_request_sizes_count": 0,
          "reservation_invoice": List<ReservationInvoice>.empty(),
          "reservation_invoice_count": 0,
          "products_inputs": List<ProductInput>.empty(),
          "products_inputs_count": 0,
          "products_outputs": List<ProductOutput>.empty(),
          "products_outputs_count": 0,
          "transfers": List<Transfers>.empty(),
          "transfers_count": 0,
          "cargo_transporters": List<CargoTransporter>.empty(),
          "cargo_transporters_count": 0
        });
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
