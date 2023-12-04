import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
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
import '../users/balances/customer_terms.dart';
import 'balance_due.dart';
import 'dashboard.dart';
import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
part 'money_fund_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class MoneyFundDashbaord extends Dashboard {
  // List<MoneyFunds>? allCredits;

  // List<MoneyFunds>? allDebits;

  MoneyFundDashbaord() : super();


  @override
  String? getCustomAction() => "list_fund";


   factory MoneyFundDashbaord.fromJson(Map<String, dynamic> data) =>
      _$MoneyFundDashbaordFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$MoneyFundDashbaordToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  MoneyFundDashbaord fromJsonViewAbstract(Map<String, dynamic> json) =>
      MoneyFundDashbaord.fromJson(json);
}
