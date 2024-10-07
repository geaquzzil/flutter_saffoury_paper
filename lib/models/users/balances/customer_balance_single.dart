import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:pdf/widgets.dart' as pdf;

import '../../prints/print_customer_balances.dart';
import '../customers.dart';
import 'customer_terms.dart';

class CustomerBalanceSingle extends Customer
    implements PrintableInvoiceInterfaceDetails<PrintCustomerBalances> {
  // double totalBalance;
  List<EqualityValue>? lastCredit;
  // String fullAddress;
  List<CustomerTerms>? customerTerms;
  // bool requireTerms;

  CustomerBalanceSingle();

  @override
  CustomerBalanceSingle getSelfNewInstance() {
    return CustomerBalanceSingle();
  }

  @override
  CustomerBalanceSingle fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerBalanceSingle.fromJson(json);

  @override
  IconData getMainIconData() => Icons.balance;

  @override
  String? getTableNameApi() => null;

  @override
  String? getCustomAction() => "list_customers_balances";

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};
  double getTotalCredits() {
    return totalCredits.toNonNullable() + totalPurchases.toNonNullable();
  }

  double getTotalDebits() {
    return totalDebits.toNonNullable() + totalOrders.toNonNullable();
  }

  // @override
  // Widget getCardLeading(BuildContext context) {
  //   // TODO: implement getCardLeading
  //   return SizedBox(
  //       width: 60,
  //       height: 60,
  //       child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  // }

  @override
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
          BuildContext context, PrintCustomerBalances? pca) =>
      {
        AppLocalizations.of(context)!.description: name ?? "",
        AppLocalizations.of(context)!.addressInfo: address ?? "",
        AppLocalizations.of(context)!.phone_number: phone ?? "",
        AppLocalizations.of(context)!.credits:
            getTotalCredits().toStringAsFixed(2),
        AppLocalizations.of(context)!.debits:
            getTotalDebits().toStringAsFixed(2),
        AppLocalizations.of(context)!.total: balance?.toStringAsFixed(2) ?? "0",
      };

  factory CustomerBalanceSingle.fromJson(Map<String, dynamic> json) =>
      CustomerBalanceSingle()
        ..iD = json['iD'] as int
        ..login = json['login'] as bool?
        ..permission = json['permission'] as bool?
        ..response = json['response'] as int?
        ..phone = json['phone'] as String?
        ..name = json['name'] as String?
        ..email = json['email'] as String?
        ..token = json['token'] as String?
        ..activated = json['activated'] as int?
        ..date = json['date'] as String?
        ..city = json['city'] as String?
        ..address = json['address'] as String?
        ..profile = json['profile'] as String?
        ..comments = json['comments'] as String?
        ..cash = json['cash'] as int?
        ..totalCredits = (json['totalCredits'] as num?)?.toDouble()
        ..totalDebits = (json['totalDebits'] as num?)?.toDouble()
        ..totalOrders = (json['totalOrders'] as num?)?.toDouble()
        ..totalPurchases = (json['totalPurchases'] as num?)?.toDouble()
        ..balance = (json['balance'] as num?)?.toDouble()
        ..lastCredit = (json['orders_details'] as List<dynamic>?)
            ?.map((e) => EqualityValue.fromJson(e as Map<String, dynamic>))
            .toList()
        ..customerTerms = (json['customerTerms'] as List<dynamic>?)
            ?.map((e) => CustomerTerms.fromJson(e as Map<String, dynamic>))
            .toList();

  @override
  Map<String, dynamic> toJson() => {};

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting) {
    return null;
  }

  @override
  pdf.Widget getPrintableDetailPageIfLabel(
      BuildContext context,
      PrintCustomerBalances? pca,
      PrintableInvoiceInterface<PrintLocalSetting> parent) {
    // TODO: implement getPrintableDetailPageIfLabel
    throw UnimplementedError();
  }
}

class EqualityValue {
  int? CustomerID;
  String? date;
  double? value;

  EqualityValue();
  factory EqualityValue.fromJson(Map<String, dynamic> data) => EqualityValue()
    ..CustomerID = data['CustomerID'] as int?
    ..date = data['date'] as String?
    ..value = convertToDouble(data['value']);

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());

  Map<String, dynamic> toJson() => {};
}
