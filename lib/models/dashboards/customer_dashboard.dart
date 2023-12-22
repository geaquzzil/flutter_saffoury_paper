import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
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
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../funds/credits.dart';
import '../funds/debits.dart';

import '../funds/incomes.dart';
import '../funds/spendings.dart';
import '../users/customers.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
part 'customer_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerDashboard extends UserLists<CustomerDashboard>
    implements DashableInterface {
  Customer? customers;
  double? previousBalance;
  //balance from to date
  double? balance;
  double? totalCredits;
  double? totalDebits;
  double? totalOrders;
  double? totalPurchases;
  DateObject? dateObject;

  CustomerDashboard() : super();
  CustomerDashboard.init(int iD, {this.dateObject}) {
    this.iD = iD;
  }
  @override
  CustomerDashboard getSelfNewInstance() {
    return CustomerDashboard();
  }

  @override
  IconData getMainIconData() {
    return Icons.balance;
  }

  @override
  String? getCustomAction() => "view_customer_statement";

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  @override
  Map<String, String> get getCustomMap => {
        "<iD>": iD.toString(),
        "date": jsonEncode(dateObject?.toJson() ?? DateObject().toJson()),
      };

  factory CustomerDashboard.fromJson(Map<String, dynamic> data) =>
      _$CustomerDashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$CustomerDashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();
  @override
  CustomerDashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerDashboard.fromJson(json);

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
      BuildContext context, int crossAxisCount) {
    return [];
  }

  @override
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
      BuildContext context, int crossAxisCount) {
    return [];
  }

  @override
  void setDate(DateObject? date) {
    this.dateObject = date;
    balance = null;
  }

  @override
  bool isRequiredObjectsListChecker() {
    return balance != null;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};
  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  List<String> getMainFields({BuildContext? context}) => [];

  @override
  getDashboardShouldWaitBeforeRequest(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi>? globalKey,
      TabControllerHelper? tab}) {
    debugPrint("getDashboardShouldWaitBefore $iD");
    firstPane = firstPane ?? false;
    if (iD == -1) {
      return [
        if (firstPane)
          SliverFillRemaining(
            child: Center(child: Text("SOSOSOSO")),
          )
        else
          SliverFillRemaining(
            child: Center(
              child: EmptyWidget(
                  lottiUrl:
                      "https://lottie.host/901033cb-134b-423b-a08a-42be30e6a1e4/BT8QbFb23s.json",
                  title: AppLocalizations.of(context)!.pleaseSelect,
                  subtitle: AppLocalizations.of(context)!.no_content),
            ),
          )
      ];
    } else {
      return null;
    }
  }

  @override
  Widget? getDashboardAppbar(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi<StatefulWidget>>? globalKey,
      TabControllerHelper? tab}) {
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerDashboardSelector
    extends ViewAbstract<CustomerDashboardSelector> {
  Customer? customer;
  String? date;
  CustomerDashboardSelector() : super();

  @override
  CustomerDashboardSelector fromJsonViewAbstract(Map<String, dynamic> json) {
    return CustomerDashboardSelector.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  factory CustomerDashboardSelector.fromJson(Map<String, dynamic> data) =>
      _$CustomerDashboardSelectorFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$CustomerDashboardSelectorToJson(this);

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "date": AppLocalizations.of(context)!.date,
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) => ["date"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customer;

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return customer?.name ?? "-";
  }

  @override
  IconData getMainIconData() {
    return Icons.account_circle_sharp;
  }

  @override
  CustomerDashboardSelector getSelfNewInstance() => CustomerDashboardSelector();

  @override
  String? getSortByFieldName() => null;

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => null;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"customer": true};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"date": TextInputType.datetime};

  @override
  Map<String, bool> isFieldCanBeNullableMap() =>
      {"date": false, "customer": false};

  @override
  Map<String, bool> isFieldRequiredMap() => {"date": true, "customer": true};
}
