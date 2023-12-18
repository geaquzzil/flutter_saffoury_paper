import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
import 'package:flutter_saffoury_paper/models/funds/debits.dart';
import 'package:flutter_saffoury_paper/models/funds/incomes.dart';
import 'package:flutter_saffoury_paper/models/funds/spendings.dart';
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
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../invoices/invoice_master.dart';

part 'sales_analysis_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class SalesAnalysisDashboard extends UserLists<SalesAnalysisDashboard>
    implements DashableInterface {
  DateObject? date;

  List<Product>? bestSellingSize;

  List<Product>? bestSellingGSM;

  List<Product>? bestSellingTYPE;

  List<Product>? bestProfitableType;

  List<GrowthRate>? totalSalesQuantity;
  List<GrowthRate>? totalSalesQuantityAnalysis;

  List<GrowthRate>? totalReturnsQuantity;
  List<GrowthRate>? totalReturnsQuantityAnalysis;

  List<GrowthRate>? totalNetSalesQuantity;
  List<GrowthRate>? totalNetSalesQuantityAnalysis;

  List<GrowthRate>? wastesQuantity;
  List<GrowthRate>? wastesQuantityAnalysis;

  List<GrowthRate>? profits;
  List<GrowthRate>? profitsAnalysis;

  List<AccountNamesBalance>? incomesDue;
  List<AccountNamesBalance>? spendingsDue;

  List<GrowthRate>? wastes;
  List<GrowthRate>? wastesAnalysis;
  List<GrowthRate>? netProfit;

  SalesAnalysisDashboard();

  @override
  String? getTableNameApi() => "list_sales";

  SalesAnalysisDashboard.init({DateObject? dateObject}) {
    date = dateObject;
  }
  @override
  SalesAnalysisDashboard getSelfNewInstance() {
    return SalesAnalysisDashboard();
  }

  @override
  IconData getMainIconData() {
    return Icons.ssid_chart_sharp;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;
  @override
  Map<String, String> get getCustomMap => {
        "date": jsonEncode(date?.toJson() ?? DateObject().toJson()),
      };

  // @override
  // Future<SalesAnalysisDashboard?> callApi() async {
  //   // debugPrint("DashboardPage callApi  ${jsonEncode(dashboard)}");
  //   await Future.delayed(Duration(seconds: 2));
  //   return fromJsonViewAbstract(jsonDecode(jsonEncode(dashboard)));
  // }

  factory SalesAnalysisDashboard.fromJson(Map<String, dynamic> data) =>
      _$SalesAnalysisDashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$SalesAnalysisDashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  SalesAnalysisDashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      SalesAnalysisDashboard.fromJson(json);

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
      BuildContext context, int crossAxisCount) {
    // TODO: implement getDashboardSectionsFirstPane
    return [];
  }

  @override
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
      BuildContext context, int crossAxisCount) {
    return [];
  }

  @override
  bool isRequiredObjectsListChecker() {
    return profits != null;
  }

  @override
  void setDate(DateObject? date) {
    this.date = date;
    profits = null;
  }
}

class AccountNamesBalance {
  String? name;
  double? sum;

  AccountNamesBalance();

  factory AccountNamesBalance.fromJson(Map<String, dynamic> data) =>
      AccountNamesBalance()
        ..name = data['name'] as String?
        ..sum = InvoiceMaster.convertToDouble(data['sum']);

  Map<String, dynamic> toJson() => {};
}
