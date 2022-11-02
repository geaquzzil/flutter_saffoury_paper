import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import '../funds/money_funds.dart';
import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/priceless_invoices/reservation_invoice.dart';
import '../users/balances/customer_terms.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import '../users/user.dart';
import 'balance_due.dart';
part 'dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Dashboard extends UserLists<Dashboard> implements DashableInterface {
  List<BalanceDue>? debitsDue;
  List<BalanceDue>? creditsDue;
  List<BalanceDue>? incomesDue;
  List<BalanceDue>? spendingsDue;
  List<BalanceDue>? debitsBalanceToday;
  List<BalanceDue>? creditsBalanceToday;
  List<BalanceDue>? incomesBalanceToday;
  List<BalanceDue>? spendingsBalanceToday;
  List<BalanceDue>? previousdebitsDue;
  List<BalanceDue>? previouscreditsDue;
  List<BalanceDue>? previousincomesDue;
  List<BalanceDue>? previousspendingsDue;

  List<CustomerTerms>? notPayedCustomers;
  List<CustomerTerms>? customerToPayNext;

  DateObject? date;

  List<CustomerTerms>? modifiedNotPayedCustomers;

  List<CustomerTerms>? modifiedCustomerToPayNext;

  List<ReservationInvoice>? overdue_reservation_invoice;

  List<ReservationInvoice>? pending_reservation_invoice;
  List<CutRequest>? pending_cut_requests;

  Dashboard() : super();

  Dashboard.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    this.date = dateObject;
  }
  @override
  String? getCustomAction() => "list_dashboard";

  @override
  Map<String, String> get getCustomMap => {
        "date": jsonEncode(
            DateObject(from: "2022-11-02", to: "2022-11-02").toJson()),
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  @override
  List<ViewAbstract> getDashboardsItems(BuildContext context) {
    // TODO: implement getDashboardsItems
    throw UnimplementedError();
  }

  factory Dashboard.fromJson(Map<String, dynamic> data) =>
      _$DashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Dashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      Dashboard.fromJson(json);
}
