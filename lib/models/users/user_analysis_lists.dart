// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/balance_due.dart';
import 'package:flutter_saffoury_paper/models/dashboards/customer_dashboard.dart';
import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
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
import 'package:flutter_saffoury_paper/models/prints/print_customer_dashboard_setting.dart';
import 'package:flutter_saffoury_paper/models/prints/print_dashboard_setting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';

class UserLists<T> extends AuthUser<T> {
  List<Credits>? credits;
  List<GrowthRate>? creditsAnalysis;

  List<Debits>? debits;
  List<GrowthRate>? debitsAnalysis;

  List<Spendings>? spendings;
  List<GrowthRate>? spendingsAnalysis;

  List<Incomes>? incomes;
  List<GrowthRate>? incomesAnalysis;

  List<CutRequest>? cut_requests;
  List<GrowthRate>? cut_requestsAnalysis;
  int? cut_requests_count;

  List<Order>? orders;
  List<GrowthRate>? ordersAnalysis;
  int? orders_count;

  List<Purchases>? purchases;
  List<GrowthRate>? purchasesAnalysis;
  int? purchases_count;

  List<OrderRefund>? orders_refunds;
  List<GrowthRate>? orders_refundsAnalysis;
  int? orders_refunds_count;

  List<PurchasesRefund>? purchases_refunds;
  List<GrowthRate>? purchases_refundsAnalysis;
  int? purchases_refunds_count;

  List<CustomerRequestSize>? customers_request_sizes;
  List<GrowthRate>? customers_request_sizesAnalysis;
  int? customers_request_sizes_count;

  List<ReservationInvoice>? reservation_invoice;
  List<GrowthRate>? reservation_invoiceAnalysis;
  int? reservation_invoice_count;

  List<ProductInput>? products_inputs; //employee only
  List<GrowthRate>? products_inputsAnalysis;
  int? products_inputs_count;

  List<ProductOutput>? products_outputs; //employee only
  List<GrowthRate>? products_outputsAnalysis;
  int? products_outputs_count;

  List<Transfers>? transfers; //employee only
  List<GrowthRate>? transfersAnalysis;
  int? transfers_count;

  List<CargoTransporter>? cargo_transporters; //employee only
  List<GrowthRate>? cargo_transportersAnalysis;
  int? cargo_transporters_count;

  @JsonKey(includeToJson: false, includeFromJson: false)
  Map<String?, double> balances = {};

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context, action: action);
    balances.clear();
  }

  void addBalance(double value, String? currnecyName) {
    if (balances.containsKey(currnecyName)) {
      balances[currnecyName] = balances[currnecyName].toNonNullable() + value;
    } else {
      balances[currnecyName] = value;
    }
  }

  void minusBalance(double value, String currnecyName) {
    if (balances.containsKey(currnecyName)) {
      balances[currnecyName] = balances[currnecyName].toNonNullable() - value;
    } else {
      balances[currnecyName] = value;
    }
  }

  String getBalance() {
    List<String> result = List.empty(growable: true);
    balances.forEach((key, value) {
      result.add(balances[key].toCurrencyFormat(symbol: key ?? ""));
    });
    return result.join("\n");
  }

  UserLists() : super();
  @override
  UserLists getSelfNewInstance() {
    return UserLists();
  }

  @override
  String? getTableNameApi() {
    return null;
  }

  String? getAbstractColor(PrintDashboardSetting? pca) {
    if (this is Dashboard) {
      return (this as Dashboard).getPrintablePrimaryColor(pca);
    } else if (this is CustomerDashboard) {
      return (this as CustomerDashboard).getMainColor()?.toHex();
    }
    return null;
  }

  String getAPreviousBalance(BuildContext context, PrintDashboardSetting? pca) {
    if (this is Dashboard) {
      return (this as Dashboard).getTotalPreviousBalance(
        cashBoxID: pca?.currency?.iD,
      );
    } else {
      //todo previous balance on customer
      return (this as CustomerDashboard).previousBalance.toCurrencyFormat();
    }
  }

  DateObject? getDate() {
    if (this is CustomerDashboard) {
      return (this as CustomerDashboard).dateObject;
    } else if (this is Dashboard) {
      return (this as Dashboard).dateObject;
    }
    return null;
  }

  bool checkList(List? list) {
    if (list == null) return false;
    if (list.isEmpty) return false;
    return true;
  }

  bool checkForEmptyList(List? list, bool checkForEmpty) {
    if (!checkForEmpty) return true;
    return checkList(list);
  }

  List<InvoiceHeaderTitleAndDescriptionInfo>? getInvoiceDesSecRow(
    BuildContext context,
    PrintLocalSetting? pca,
  ) {
    DateObject? date = getDate();
    if (date == null) return null;
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.from,
        description: date.from,
        // icon: Icons.date_range
      ),
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.to,
        description: date.to,
        // icon: Icons.date_range
      ),
    ];
  }

  bool includePreviousBalance(PrintLocalSetting? pca) {
    if (pca == null) return true;
    if (pca is PrintDashboardSetting) {
      return pca.includePreviousBalance ?? true;
    } else if (pca is PrintCustomerDashboardSetting) {
      return pca.includePreviousBalance ?? true;
    }
    return true;
  }

  /// this hide by default
  bool hideCurrencySetting(PrintLocalSetting? pca) {
    if (pca == null) return true;
    if (pca is PrintDashboardSetting) {
      return pca.hideCurrency ?? true;
    } else if (pca is PrintCustomerDashboardSetting) {
      return pca.hideCurrency ?? true;
    }
    return true;
  }

  String getCurrencySettingName(BuildContext context, PrintLocalSetting? pca) {
    if (pca == null) return AppLocalizations.of(context)!.all;
    if (pca is PrintDashboardSetting) {
      return pca.currency?.name ?? AppLocalizations.of(context)!.all;
    } else if (pca is PrintCustomerDashboardSetting) {
      return pca.currency?.name ?? AppLocalizations.of(context)!.all;
    }
    return AppLocalizations.of(context)!.all;
  }

  List<InvoiceHeaderTitleAndDescriptionInfo>? getInvoiceDesTherdRow(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) {
    return [
      if (hideCurrencySetting(pca))
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.currency,
          description: getCurrencySettingName(context, pca),
          // hexColor: getAbstractColor(pca)
          // icon: Icons.tag
        ),
      if (pca?.includePreviousBalance == true)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.previousBalance,
          description: getAPreviousBalance(context, pca),
          hexColor: getAbstractColor(pca),
          // icon: Icons.tag
        ),

      // InvoiceHeaderTitleAndDescriptionInfo(
      //     title: AppLocalizations.of(context)!.balance,
      //     description: customers?.balance?.toCurrencyFormat() ?? "",
      //     hexColor: getPrintablePrimaryColor(pca)
      //     // icon: Icons.balance
      //     ),
      // if (!isPricelessInvoice())
      //   if ((pca?.hideInvoicePaymentMethod == false))
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //         title: AppLocalizations.of(context)!.paymentMethod,
      //         description: "payment on advanced",
      //         hexColor: getPrintablePrimaryColor(pca)
      //         // icon: Icons.credit_card
      //         ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo>? getInvoicDesFirstRow(
    BuildContext context,
    PrintLocalSetting? pca,
  ) {
    if (this is! CustomerDashboard) return null;
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.mr,
        description: (this as CustomerDashboard).customers?.name ?? "TODO",
        // icon: Icons.account_circle_rounded
      ),
      if ((this as CustomerDashboard).customers?.address != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.iD,
          description:
              (this as CustomerDashboard).customers?.getIDFormat(context) ?? "",
          // icon: Icons.map
        ),
      if ((this as CustomerDashboard).customers?.phone != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.phone_number,
          description:
              (this as CustomerDashboard).customers?.phone?.toString() ?? "",
          // icon: Icons.phone
        ),
    ];
  }

  WidgetGridHelper getWidget(
    StaggeredGridTile gride, {
    WidgetDashboardType type = WidgetDashboardType.NORMAL,
  }) {
    return WidgetGridHelper(widget: gride, widgetDashboardType: type);
  }

  String combineStrings(List<List<GrowthRate?>?> list) {
    return "";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()..addAll({
        "cut_requests": List<CutRequest>.empty(),
        "cut_requstesAnalysis": List<GrowthRate>.empty(),
        "cut_requests_count": 0,
        "orders": List<Order>.empty(),
        "ordersAnalysis": List<GrowthRate>.empty(),
        "orders_count": 0,
        "purchases": List<Purchases>.empty(),
        "purchasesAnalysis": List<GrowthRate>.empty(),
        "purchases_count": 0,
        "orders_refunds": List<OrderRefund>.empty(),
        "orders_refundsAnalysis": List<GrowthRate>.empty(),
        "orders_refunds_count": 0,
        "purchases_refunds_count": 0,
        "purchases_refunds": List<PurchasesRefund>.empty(),
        "purchases_refundsAnalysis": List<GrowthRate>.empty(),
        "customers_request_sizes": List<CustomerRequestSize>.empty(),
        "customers_request_sizesAnalysis": List<GrowthRate>.empty(),
        "customers_request_sizes_count": 0,
        "reservation_invoice": List<ReservationInvoice>.empty(),
        "reservation_invoiceAnalysis": List<GrowthRate>.empty(),
        "reservation_invoice_count": 0,
        "products_inputs": List<ProductInput>.empty(),
        "products_inputsAnalysis": List<GrowthRate>.empty(),
        "products_inputs_count": 0,
        "products_outputs": List<ProductOutput>.empty(),
        "products_outputsAnalysis": List<GrowthRate>.empty(),
        "products_outputs_count": 0,
        "transfers": List<Transfers>.empty(),
        "transfersAnalysis": List<GrowthRate>.empty(),
        "transfers_count": 0,
        "cargo_transporters": List<CargoTransporter>.empty(),
        "cargo_transportersAnalysis": List<GrowthRate>.empty(),
        "cargo_transporters_count": 0,
      });

  int getTabBarIndex(BuildContext context, List list) {
    if (getTabBarSecondPane(context) == null) return -1;
    return getTabBarSecondPane(
      context,
    )!.indexWhere((element) => element.extras.runtimeType == list.runtimeType);
  }

  List<TabControllerHelper>? getTabBarSecondPane(BuildContext context) {
    List<TabControllerHelper> l = [
      TabControllerHelper(AppLocalizations.of(context)!.overview),
      if (credits?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.credits,
          extras: credits,
        ),
      if (debits?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.debits,
          extras: debits,
        ),
      if (spendings?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.spendings,
          extras: spendings,
        ),
      if (incomes?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.incomes,
          extras: incomes,
        ),
      if (orders?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.orders,
          extras: orders,
        ),
      if (purchases?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.purchases,
          extras: purchases,
        ),
      if (products_inputs?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.productsInput,
          extras: products_inputs,
        ),
      if (products_outputs?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.productsOutput,
          extras: products_outputs,
        ),
      if (transfers?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.transfers,
          extras: transfers,
        ),
      if (reservation_invoice?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.reservationInvoice,
          extras: reservation_invoice,
        ),
      if (cut_requests?.isNotEmpty ?? false)
        TabControllerHelper(
          AppLocalizations.of(context)!.cutRequest,
          extras: cut_requests,
        ),
    ];
    if (l.isEmpty) return null;
    return l;
  }

  SliverList getSliverListFromExtrasTabbar(
    BuildContext context,
    TabControllerHelper tabSecondPane,
  ) {
    return SliverList.builder(
      itemCount: (tabSecondPane.extras as List).length,
      itemBuilder: (c, index) {
        return ListCardItemWeb<ViewAbstract>(
          onTap: () {
            tabSecondPane.extras[index].viewPage(context);
          },
          object: tabSecondPane.extras[index],
        );
      },
    );
  }

  List<ViewAbstract> getAnalysisChartFundsTitle(BuildContext context) {
    return [
      if (creditsAnalysis != null) Credits(),
      if (debitsAnalysis != null) Debits(),
      if (spendingsAnalysis != null) Spendings(),
      if (incomesAnalysis != null) Incomes(),
    ];
  }

  List<List<ViewAbstract>> getListOfTabbarFunds() {
    return [
      if (credits?.isNotEmpty ?? false) credits!,
      if (debits?.isNotEmpty ?? false) debits!,
      if (spendings?.isNotEmpty ?? false) spendings!,
      if (incomes?.isNotEmpty ?? false) incomes!,
    ];
  }

  List<List<GrowthRate>> getAnalysisChartFunds() {
    return [
      if (creditsAnalysis != null) creditsAnalysis ?? [],
      if (debitsAnalysis != null) debitsAnalysis ?? [],
      if (spendingsAnalysis != null) spendingsAnalysis ?? [],
      if (incomesAnalysis != null) incomesAnalysis ?? [],
    ];
  }

  List<List<GrowthRate>> getAnalysisChart() {
    return [
      if (ordersAnalysis != null) ordersAnalysis ?? [],
      if (purchasesAnalysis != null) purchasesAnalysis ?? [],
      if (products_inputsAnalysis != null) products_inputsAnalysis ?? [],
      if (products_outputsAnalysis != null) products_outputsAnalysis ?? [],
      if (transfersAnalysis != null) transfersAnalysis ?? [],
      if (reservation_invoiceAnalysis != null)
        reservation_invoiceAnalysis ?? [],
      if (cut_requestsAnalysis != null) cut_requestsAnalysis ?? [],
    ];
  }

  List<ViewAbstract> getAnalysisChartTitle(BuildContext context) {
    return [
      if (ordersAnalysis != null) Order(),
      if (purchasesAnalysis != null) Purchases(),
      if (products_inputsAnalysis != null) ProductInput(),
      if (products_outputsAnalysis != null) ProductOutput(),
      if (transfersAnalysis != null) Transfers(),
      if (reservation_invoiceAnalysis != null) ReservationInvoice(),
      if (cut_requestsAnalysis != null) CutRequest(),
    ];
  }

  Map<String, double> getMapMinus(
    Map<String, double> first,
    Map<String, double> second,
  ) {
    Map<String, double> map = {};
    Map<String, double> mapPlus1 = {}..addAll(first);
    Map<String, double> mapPlus2 = {}..addAll(second);

    mapPlus1.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! - value;
      } else {
        map[key] = value;
      }
    });
    mapPlus2.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! - value;
      } else {
        map[key] = value;
      }
    });
    return map;
  }

  Map<String, double> getMapPlus(
    List<BalanceDue>? first,
    List<BalanceDue>? second, {
    int? cashBoxID,
  }) {
    Map<String, double> map = {};
    Map<String, double> mapPlus1 = {}
      ..addAll(first.getTotalGrouped(CashboxID: cashBoxID));
    Map<String, double> mapPlus2 = {}
      ..addAll(second.getTotalGrouped(CashboxID: cashBoxID));

    mapPlus1.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! + value;
      } else {
        map[key] = value;
      }
    });
    mapPlus2.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! + value;
      } else {
        map[key] = value;
      }
    });
    return map;
  }

  bool isCustomerDashboard() {
    return this is CustomerDashboard;
  }

  List<WidgetGridHelper> getFundWidgets(
    BuildContext context,
    int crossAxisCount, {
    bool checkForEmpty = false,
    SecoundPaneHelperWithParentValueNotifier? basePage,
  }) {
    bool isMezouj = crossAxisCount % 2 == 0;
    debugPrint(
      "isMezouj: $isMezouj   crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4} ",
    );
    int crossCountFund = crossAxisCount ~/ 4;
    int crossAxisCountMod = crossAxisCount % 4;
    int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;

    debugPrint(
      "isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod}",
    );
    return [
      if (checkForEmptyList(credits, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                basePage: basePage,
           
              list: credits,
              listGrowthRate: creditsAnalysis,
              icon: Icons.arrow_back_sharp,
              title: AppLocalizations.of(context)!.credits,
              description: credits.getTotalValueString(context),
              footer: credits?.length.toString(),
              footerRightWidget: creditsAnalysis.getGrowthRateText(context),
            ),
          ),
        ),
      if (checkForEmptyList(debits, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              basePage: basePage,
           
              color: Debits().getMainColor(),
              icon: Icons.arrow_forward_rounded,
              title: AppLocalizations.of(context)!.debits,
              listGrowthRate: debitsAnalysis,
              description: debits.getTotalValueString(context),
              footer: debits?.length.toString(),
              footerRightWidget: debitsAnalysis.getGrowthRateText(
                context,
                reverseTheme: true,
              ),
            ),
          ),
        ),
      if (checkForEmptyList(spendings, checkForEmpty) && !isCustomerDashboard())
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              basePage: basePage,
           
              color: Spendings().getMainColor(),
              icon: Icons.arrow_forward_rounded,
              title: AppLocalizations.of(context)!.spendings,
              description: spendings.getTotalValueString(context),
              listGrowthRate: spendingsAnalysis,
              footer: spendings?.length.toString(),
              footerRightWidget: spendingsAnalysis.getGrowthRateText(
                context,
                reverseTheme: true,
              ),
            ),
          ),
        ),
      if (checkForEmptyList(incomes, checkForEmpty) && !isCustomerDashboard())
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc + crossAxisCountMod,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                 basePage: basePage,
           
              icon: Icons.arrow_back_sharp,
              listGrowthRate: incomesAnalysis,
              title: AppLocalizations.of(context)!.incomes,
              description: incomes.getTotalValueString(context),
              footer: incomes?.length.toString(),
              footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            ),
          ),
        ),
      //todo set this for dashboard only
      if (checkList(credits))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCount,
            mainAxisCellCount: 2,
            child: Card(
              child: ViewableTableViewAbstractWidget(
                usePag: false,
                buildActions: true,
                viewAbstract: [
                  ...credits ?? [],
                  ...debits ?? [],
                  ...spendings ?? [],
                  ...incomes ?? [],
                ],
              ),
            ),
          ),
        ),
    ];
  }

  List<WidgetGridHelper> getInvoicesWidgets(
    BuildContext context,
    int crossAxisCount, {
    bool checkForEmpty = false,
    SecoundPaneHelperWithParentValueNotifier? basePage,
  }) {
    bool isMezouj = crossAxisCount % 2 == 0;

    int crossCountFund = crossAxisCount ~/ 4;
    int crossAxisCountMod = crossAxisCount % 4;
    int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;
    debugPrint(
      "isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod}",
    );
    return [
      if (checkForEmptyList(orders, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc + crossAxisCountMod,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                basePage: basePage,
           
              // color: Colors.green.withOpacity(0.2),
              icon: Order().getMainIconData(),
              listGrowthRate: ordersAnalysis,
              title: AppLocalizations.of(context)!.orders,
              description: ordersAnalysis.getTotalText(
                symple: AppLocalizations.of(context)!.quantity,
              ),
              footer: orders?.length.toString(),
              footerRightWidget: ordersAnalysis.getGrowthRateText(context),
            ),
          ),
        ),
      if (checkForEmptyList(purchases, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                 basePage: basePage,
           
              listGrowthRate: purchasesAnalysis,
              icon: Purchases().getMainIconData(),
              title: AppLocalizations.of(context)!.purchases,
              description: purchasesAnalysis.getTotalText(
                symple: AppLocalizations.of(context)!.quantity,
              ),
              footer: purchases?.length.toString(),
              footerRightWidget: purchasesAnalysis.getGrowthRateText(context),
            ),
          ),
        ),
      if (checkForEmptyList(cut_requests, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                basePage: basePage,
           
              icon: CutRequest().getMainIconData(),
              listGrowthRate: cut_requestsAnalysis,
              title: CutRequest().getMainHeaderLabelTextOnly(context),
              description: "TEST",
              footer: cut_requests?.length.toString(),
              footerRightWidget: cut_requestsAnalysis.getGrowthRateText(
                context,
              ),
            ),
          ),
        ),
      if (checkForEmptyList(transfers, checkForEmpty) && !isCustomerDashboard())
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                basePage: basePage,
           
              icon: Transfers().getMainIconData(),
              title: Transfers().getMainHeaderLabelTextOnly(context),
              listGrowthRate: transfersAnalysis,
              description: transfersAnalysis.getTotalText(
                symple: AppLocalizations.of(context)!.quantity,
              ),
              footer: transfers?.length.toString(),
              footerRightWidget: transfersAnalysis.getGrowthRateText(context),
            ),
          ),
        ),
      if (checkForEmptyList(products_inputs, checkForEmpty) &&
          !isCustomerDashboard())
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              // onTap: () {
              //   int idx = getTabBarIndex(context, products_inputs ?? []);
              //   if (idx == -1) return;
              //   //TODO
              //   // globalKey?.currentState?.changeTabIndexSecondPane(idx);
              // },
                 basePage: basePage,
           
              icon: ProductInput().getMainIconData(),
              title: ProductInput().getMainHeaderLabelTextOnly(context),
              description: products_inputsAnalysis.getTotalText(
                symple: AppLocalizations.of(context)!.quantity,
              ),
              footer: products_inputs?.length.toString(),
              footerRightWidget: products_inputsAnalysis.getGrowthRateText(
                context,
              ),
            ),
          ),
        ),
      if (checkForEmptyList(products_outputs, checkForEmpty) &&
          !isCustomerDashboard())
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
                 basePage: basePage,
           
              icon: ProductOutput().getMainIconData(),
              title: ProductOutput().getMainHeaderLabelTextOnly(context),
              description: products_outputs
                  .getTotalQuantityGroupedFormattedText(context),
              footer: products_outputs?.length.toString(),
              footerRightWidget: products_outputsAnalysis.getGrowthRateText(
                context,
              ),
            ),
          ),
        ),
      if (checkForEmptyList(reservation_invoice, checkForEmpty))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              // onTap: () {
              //   int idx = getTabBarIndex(context, reservation_invoice ?? []);
              //   if (idx == -1) return;
              //   //TODO
              //   //globalKey?.currentState?.changeTabIndexSecondPane(idx);
              // },
                 basePage: basePage,
           
              icon: ReservationInvoice().getMainIconData(),
              title: ReservationInvoice().getMainHeaderLabelTextOnly(context),
              description: reservation_invoice
                  .getTotalQuantityGroupedFormattedText(context),
              footer: reservation_invoice?.length.toString(),
              footerRightWidget: reservation_invoiceAnalysis.getGrowthRateText(
                context,
              ),
            ),
          ),
        ),
      //todo this only on dashboard
      if (checkList(orders))
        getWidget(
          StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCount,
            mainAxisCellCount: 2,
            child: Card(
              child: ViewableTableViewAbstractWidget(
                viewAbstract: orders!,
                usePag: true,
                buildActions: true,
              ),
            ),
          ),
        ),
    ];
  }
}
