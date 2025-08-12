import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/print_dashboard_setting.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/printing_generator/pdf_dashboard_api.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/widgets.dart' as pdf;

import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/priceless_invoices/reservation_invoice.dart';
import '../users/balances/customer_terms.dart';
import 'balance_due.dart';

part 'dashboard.g.dart';

//TODO on publish do not forget that the iD gives error messages because the response of dashboard iD not found
@JsonSerializable(explicitToJson: true)
@reflector
class Dashboard extends UserLists<Dashboard>
    with ModifiableInterface<PrintDashboardSetting>
    implements
        DashableInterface,
        PrintableDashboardInterface<PrintDashboardSetting> {
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

  DateObject? dateObject;

  List<CustomerTerms>? modifiedNotPayedCustomers;

  List<CustomerTerms>? modifiedCustomerToPayNext;

  List<ReservationInvoice>? overdue_reservation_invoice;

  List<ReservationInvoice>? pending_reservation_invoice;
  List<CutRequest>? pending_cut_requests;

  Dashboard() : super() {
    dateObject = DateObject();
    balances = {};
  }

  Dashboard.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    dateObject = dateObject;
    balances = {};
  }

  @override
  Dashboard getSelfNewInstance() {
    return Dashboard();
  }

  @override
  IconData getMainIconData() {
    return Icons.dashboard_sharp;
  }

  @override
  String? getTableNameApi() => "dashboard";

  @override
  List<String>? getCustomAction() {
    return null;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    debugPrint("getRequestOption date: $dateObject");
    var op = RequestOptions()
        .addDate(dateObject ?? DateObject())
        // .addDate(DateObject(from: "2022-10-02", to: "2022-10-03"))
        .setDisablePaging();
    return op;
    return setInterval() ? op.addSearchByField("interval", "daily") : op;
  }

  @override
  bool getPrintableSupportsLabelPrinting() => false;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> data) =>
      _$DashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Dashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      Dashboard.fromJson(json);

  String getTotalPreviousBalance({int? cashBoxID}) {
    var incomes = getMapPlus(
      previouscreditsDue,
      previousincomesDue,
      cashBoxID: cashBoxID,
    );
    var spendings = getMapPlus(
      previousdebitsDue,
      previousspendingsDue,
      cashBoxID: cashBoxID,
    );

    debugPrint("getTotalPreviousBalance getTotoC $incomes $spendings");

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalDueBalance({int? cashBoxID}) {
    var incomes = getMapPlus(creditsDue, incomesDue, cashBoxID: cashBoxID);
    var spendings = getMapPlus(debitsDue, spendingsDue, cashBoxID: cashBoxID);

    debugPrint("getTotalPreviousBalance getTotoC b $incomes $spendings");

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalTodayBalance({int? cashBoxID}) {
    var incomes = getMapPlus(
      creditsBalanceToday,
      incomesBalanceToday,
      cashBoxID: cashBoxID,
    );
    var spendings = getMapPlus(
      debitsBalanceToday,
      spendingsBalanceToday,
      cashBoxID: cashBoxID,
    );

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  @override
  bool shouldGetFromApiViewCall(dynamic lastObject) {
    debugPrint("shouldGetFromApiViewCall $dateObject");
    debugPrint("shouldGetFromApiViewCall lastObject ${lastObject?.dateObject}");
    if (lastObject == null) {
      return true;
    }
    if (lastObject is Dashboard) {
       debugPrint("shouldGetFromApiViewCall is dashboard");
      if (lastObject.dateObject == dateObject) {
          debugPrint("shouldGetFromApiViewCall is lastObject.dateObject == dateObject");
        return false;
      }
    }
    return true;
  }

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
    BuildContext context, {
    SecoundPaneHelperWithParentValueNotifier? basePage,
    TabControllerHelper? tab,
  }) => [
    DashableGridHelper(
      sectionsListToTabbar: getListOfTabbarFunds(),
      headerListToAdd: [Credits(), Debits(), Spendings(), Incomes()],
      title: AppLocalizations.of(context)!.overview,
      widgets: [
        ...getFundWidgets(context, basePage: basePage),
        // ...getInvoicesWidgets(context)
      ],
    ),
    DashableGridHelper(
      title: AppLocalizations.of(context)!.invoice,
      headerListToAdd: [
        Order(),
        Purchases(),
        CutRequest(),
        Transfers(),
        ProductInput(),
        ProductOutput(),
        ReservationInvoice(),
      ],
      widgets: [...getInvoicesWidgets(context, basePage: basePage)],
    ),
    DashableGridHelper(
      title: AppLocalizations.of(
        context,
      )!.pendingFormat(AppLocalizations.of(context)!.orders.toLowerCase()),
      headerListToAdd: [Order()],
      widgets: [
        getWidget(
          (
            fullCrossAxisCount,
            crossCountFundCalc,
            crossAxisCountMod,
            heightMainAxisCellCount,
          ) => StaggeredGridTile.count(
            crossAxisCellCount: fullCrossAxisCount,
            mainAxisCellCount: 1.2,
            child: SliverApiMixinViewAbstractWidget(
              isSliver: false,
              cardType: CardItemType.grid,
              scrollDirection: Axis.horizontal,

              toListObject: Order().setRequestOption(
                option: RequestOptions().addSearchByField("status", "PENDING"),
              ),
            ),
          ),
        ),
      ],
    ),
    if (checkList(pending_cut_requests))
      DashableGridHelper(
        title: AppLocalizations.of(context)!.pendingCutRequest,
        widgets: [
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: fullCrossAxisCount,
              mainAxisCellCount: 1.2,
              child: SliverApiMixinStaticList<CutRequest>(
                isSliver: true,
                // titleString: "Pending",
                list: pending_cut_requests?.cast() ?? [],
                // listItembuilder: (v) =>
                //     ListItemProductTypeCategory(productType: v as ProductType),
                // autoRest: AutoRest<CutRequest>(
                //     obj: CutRequest()
                //       ..setCustomMap({"<cut_status>": "PENDING"}),
                //     key: "CutRequest<Pending>"),
              ),
            ),
          ),

          //                  return LineChartItem<ChangesRecordGroup, String>(
          //   title: "${AppLocalizations.of(context)!.total}: ${totalGrouped?.length} ",
          //   list: totalGrouped ?? [],
          //   xValueMapper: (item, value) => "${item.groupBy}",
          //   yValueMapper: (item, n) => item.count,
          // );
          // getWidget(
          //     StaggeredGridTile.count(
          //         crossAxisCellCount: 2,
          //         mainAxisCellCount: 1.5,
          //         child: LineChartItem<GrowthRate, String>(
          //           list: cut_requestsAnalysis ?? [],
          //           // title:
          //           //     CutRequest().getMainHeaderLabelTextOnly(context),
          //           dataLabelMapper: (item, idx) => item.total
          //               .toCurrencyFormat(
          //                   symbol: AppLocalizations.of(context)!.kg),
          //           xValueMapper: (item, value) {
          //             // debugPrint("ChartItem $item");
          //             return DateFormat.MMM().format(DateTime(
          //                 item.year!, item.month!, item.day ?? 1));
          //           },
          //           yValueMapper: (item, n) => item.total,
          //         )),
          //     type: WidgetDashboardType.CHART),
        ],
      ),
    if (checkList(pending_reservation_invoice))
      DashableGridHelper(
        title: AppLocalizations.of(context)!.pendingReservationInvoices,
        widgets: [
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: fullCrossAxisCount,
              mainAxisCellCount: 1.2,
              child: SliverApiMixinStaticList<ReservationInvoice>(
                isSliver: true,
                list: pending_reservation_invoice?.cast() ?? [],
              ),
            ),
          ),
        ],
      ),
    // ...getInvoicesWidgets(context)
    if (checkList(overdue_reservation_invoice))
      DashableGridHelper(
        title: AppLocalizations.of(context)!.overDueFormat(
          AppLocalizations.of(context)!.reservationInvoice.toLowerCase(),
        ),
        widgets: [
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: crossCountFundCalc,
              mainAxisCellCount: 1.2,
              child: SliverApiMixinStaticList<ReservationInvoice>(
                isSliver: true,
                // titleString: "Pending",
                list: overdue_reservation_invoice?.cast() ?? [],
                // listItembuilder: (v) =>
                //     ListItemProductTypeCategory(productType: v as ProductType),
                // autoRest: AutoRest<CutRequest>(
                //     obj: CutRequest()
                //       ..setCustomMap({"<cut_status>": "PENDING"}),
                //     key: "CutRequest<Pending>"),
              ),
            ),
          ),
        ],
      ),
  ];

  @override
  getDashboardSectionsSecoundPane(
    BuildContext context, {
    SecoundPaneHelperWithParentValueNotifier? basePage,
    TabControllerHelper? tab,
    TabControllerHelper? tabSecondPane,
  }) {
    // return [];
    if (tabSecondPane != null && tabSecondPane.extras != null) {
      return [
        // LineChartItem(list: , xValueMapper: xValueMapper, yValueMapper: yValueMapper)
        getSliverListFromExtrasTabbar(context, tabSecondPane),
      ];
    }
    return [
      DashableGridHelper(
        title: AppLocalizations.of(context)!.chart,
        wrapWithCard: false,
        widgets: [
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1.5,
              child: MultiLineChartItem<GrowthRate, DateTime>(
                title: "T",
                list: getAnalysisChartFunds(),
                titles: getAnalysisChartFundsTitle(context),
                dataLabelMapper: (item, idx) => item.total.toCurrencyFormat(),
                xValueMapper: (item, value, indexInsideList) => DateTime(
                  value.year ?? 2022,
                  value.month ?? 1,
                  value.day ?? 1,
                ),
                yValueMapper: (item, n, indexInsideList) => n.total,
              ),
            ),
            type: WidgetDashboardType.CHART,
          ),
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: .75,
              child: ChartCardItemCustom(
                color: Colors.blue,
                icon: Icons.today,
                title: AppLocalizations.of(context)!.this_day,
                description: getTotalTodayBalance(),
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              ),
            ),
          ),
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: .75,
              child: ChartCardItemCustom(
                icon: Icons.balance,
                color: Colors.orange,
                title: AppLocalizations.of(context)!.previousBalance,
                description: getTotalPreviousBalance(),
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              ),
            ),
          ),
          getWidget(
            (
              fullCrossAxisCount,
              crossCountFundCalc,
              crossAxisCountMod,
              heightMainAxisCellCount,
            ) => StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: .75,
              child: ChartCardItemCustom(
                icon: Icons.account_balance,
                title: AppLocalizations.of(context)!.balance_due,
                description: getTotalDueBalance(),
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
              ),
            ),
          ),

          // getWidget(
          //   StaggeredGridTile.count(
          //     crossAxisCellCount: 2,
          //     mainAxisCellCount: 2,
          //     child: SizedBox(
          //       height: MediaQuery.of(context).size.height -
          //           MediaQuery.of(context).size.height * .2,
          //       child: ListHorizontalCustomViewApiAutoRestWidget(
          //           onResponseAddWidget: ((response) {
          //             ChangesRecords i = response as ChangesRecords;
          //             return Column(
          //               children: [
          //                 // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
          //                 //     titleString: "TEST1 ",
          //                 //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
          //                 OutlinedCard(
          //                     child: ListTile(
          //                   title: Text(AppLocalizations.of(context)!.total),
          //                   subtitle: Text(i.total.toCurrencyFormat()),
          //                   leading: const Icon(Icons.monitor_weight),
          //                   trailing: const Text("SYP"),
          //                 )),
          //                 OutlinedCard(
          //                     child: ListTile(
          //                   title: Text(AppLocalizations.of(context)!.total),
          //                   subtitle: Text(i.total.toCurrencyFormat()),
          //                   leading: const Icon(Icons.monitor_weight),
          //                   trailing: const Text("SYP"),
          //                 )),
          //                 OutlinedCard(
          //                     child: ListTile(
          //                   title: Text(AppLocalizations.of(context)!.total),
          //                   subtitle: Text(i.total.toCurrencyFormat()),
          //                   leading: const Icon(Icons.monitor_weight),
          //                   trailing: const Text("SYP"),
          //                 )),
          //                 OutlinedCard(
          //                     child: ListTile(
          //                   title: Text(AppLocalizations.of(context)!.total),
          //                   subtitle: Text(i.total.toCurrencyFormat()),
          //                   leading: const Icon(Icons.monitor_weight),
          //                   trailing: const Text("SYP"),
          //                 )),
          //                 StorageInfoCardCustom(
          //                     title: AppLocalizations.of(context)!.total,
          //                     description: i.total.toCurrencyFormat(),
          //                     trailing: const Text("SYP"),
          //                     svgSrc: Icons.monitor_weight),
          //                 StorageInfoCardCustom(
          //                     title: AppLocalizations.of(context)!.balance,
          //                     description: "0",
          //                     trailing: const Text("trailing"),
          //                     svgSrc: Icons.balance),
          //               ],
          //             );
          //           }),
          //           autoRest: ChangesRecords.init(Spendings(), "NameID",
          //               fieldToSumBy: "value", pieChartEnabled: true)),
          //     ),
          //   ),
          //   type: WidgetDashboardType.CHART,
          // ),

          // getWidget(
          //   StaggeredGridTile.count(
          //       crossAxisCellCount: 1,
          //       mainAxisCellCount: 1.5,
          //       child: CirculeChartItem<GrowthRate, DateTime>(
          //         title: "T",
          //         list: getAnalysisChartFunds(),
          //         // titles: getAnalysisChartFundsTitle(context),
          //         // dataLabelMapper: (item, idx) =>
          //         //     item.total.toCurrencyFormat(),
          //         xValueMapper: (item, value, indexInsideList) => DateTime(
          //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
          //         yValueMapper: (item, n, indexInsideList) => n.total,
          //       )),
          //   type: WidgetDashboardType.CHART,
          // ),
          // getWidget(
          //   StaggeredGridTile.count(
          //       crossAxisCellCount: 2,
          //       mainAxisCellCount: 1.5,
          //       child: MultiLineChartItem<GrowthRate, DateTime>(
          //         title: "T",
          //         list: getAnalysisChartFunds(),
          //         titles: getAnalysisChartFundsTitle(context),
          //         dataLabelMapper: (item, idx) =>
          //             item.total.toCurrencyFormat(),
          //         xValueMapper: (item, value, indexInsideList) => DateTime(
          //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
          //         yValueMapper: (item, n, indexInsideList) => n.total,
          //       )),
          //   type: WidgetDashboardType.CHART,
          // ),
          // getWidget(
          //   StaggeredGridTile.count(
          //       crossAxisCellCount: 2,
          //       mainAxisCellCount: 1.5,
          //       child: MultiLineChartItem<GrowthRate, DateTime>(
          //         title: "T",
          //         list: getAnalysisChart(),
          //         titles: getAnalysisChartTitle(context),
          //         dataLabelMapper: (item, idx) =>
          //             item.total.toCurrencyFormat(),
          //         xValueMapper: (item, value, indexInsideList) => DateTime(
          //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
          //         yValueMapper: (item, n, indexInsideList) => n.total,
          //       )),
          // ),
          // ...getInvoicesWidgets(context)
        ],
      ),
      if (checkList(customerToPayNext))
        DashableGridHelper(
          title: AppLocalizations.of(context)!.customer,
          widgets: [
            getWidget(
              (
                fullCrossAxisCount,
                crossCountFundCalc,
                crossAxisCountMod,
                heightMainAxisCellCount,
              ) => StaggeredGridTile.count(
                crossAxisCellCount: fullCrossAxisCount,
                mainAxisCellCount: 2,
                child: Card(
                  child: ViewableTableViewAbstractWidget(
                    usePag: true,
                    buildActions: false,
                    viewAbstract: [...customerToPayNext ?? [], ...debits ?? []],
                  ),
                ),
              ),
            ),
          ],
        ),
      if (checkList(notPayedCustomers))
        DashableGridHelper(
          title: AppLocalizations.of(context)!.customer,
          widgets: [
            getWidget(
              (
                fullCrossAxisCount,
                crossCountFundCalc,
                crossAxisCountMod,
                heightMainAxisCellCount,
              ) => StaggeredGridTile.count(
                crossAxisCellCount: fullCrossAxisCount,
                mainAxisCellCount: 2,
                child: Card(
                  child: ViewableTableViewAbstractWidget(
                    usePag: true,
                    viewAbstract: [...notPayedCustomers!],
                  ),
                ),
              ),
            ),
          ],
        ),
    ];
  }

  @override
  List<TabControllerHelper>? getDashboardTabbarSectionSecoundPaneList(
    BuildContext context,
    SecoundPaneHelperWithParentValueNotifier? basePage,
  ) => getTabBarSecondPane(context);

  @override
  void setDate(DateObject? date) {
    dateObject = date;
    debitsDue = null;
  }

  bool setInterval() {
    if (dateObject != null) {
      DateTime from = dateObject!.from.toDateTimeOnlyDate();
      DateTime to = dateObject!.to.toDateTimeOnlyDate();
      int days = from.difference(to).inDays;
      return days <= 30;
    }
    return false;
  }

  @override
  Widget? getDashboardAppbar(
    BuildContext context, {
    bool? firstPane,
    SecoundPaneHelperWithParentValueNotifier? basePage,
    TabControllerHelper? tab,
  }) {
    if (firstPane == false) {
      return basePage?.secPaneNotifier?.value?.title == null
          ? null
          : Text(basePage?.secPaneNotifier?.value?.title ?? "");
    }
    return DashboardHeader(
      object: this,
      date: dateObject ?? DateObject(),
      current_screen_size: findCurrentScreenSize(context),
      onPressePrint: () {
        printPage(context, secPaneNotifer: basePage);
      },
      onSelectedDate: (d) {
        if (d == null) return;
        dateObject = d;
        debitsDue = null;
        basePage?.refresh(extras: this, tab: tab);
        // getExtras().setDate(d);
        // refresh(extras: extras);
      },
    );
  }

  @override
  getDashboardShouldWaitBeforeRequest(
    BuildContext context, {
    bool? firstPane,
    SecoundPaneHelperWithParentValueNotifier? basePage,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
  getPrintableDashboardAccountInfoInBottom(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) {
    // TODO: implement getPrintableDashboardAccountInfoInBottom
    return [];
  }

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetBottom(
    BuildContext context,
    PrintDashboardSetting? pca,
    PdfDashnoardApi<
      PrintableDashboardInterface<PrintLocalSetting>,
      PrintLocalSetting
    >
    generator,
  ) => null;

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetTop(
    BuildContext context,
    PrintDashboardSetting? pca,
    PdfDashnoardApi<
      PrintableDashboardInterface<PrintLocalSetting>,
      PrintLocalSetting
    >
    generator,
  ) => null;

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableDashboardFooterTotal(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) => [];

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>>
  getPrintableDashboardHeaderInfo(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) {
    List<InvoiceHeaderTitleAndDescriptionInfo>? first = getInvoicDesFirstRow(
      context,
      pca,
    );
    List<InvoiceHeaderTitleAndDescriptionInfo>? sec = getInvoiceDesSecRow(
      context,
      pca,
    );
    List<InvoiceHeaderTitleAndDescriptionInfo>? therd = getInvoiceDesTherdRow(
      context,
      pca,
    );

    return [
      if (first != null) first,
      if (sec != null) sec,
      if (therd != null) therd,
    ];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo>
  getPrintableDashboardTotalDescripton(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) => [];

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
    BuildContext context,
    PrintLocalSetting? dashboardSetting,
  ) => null;

  @override
  String getPrintableInvoiceTitle(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) {
    if (pca?.dashboardPrintType == PrintDashboardType.MONEY_FUND_ONLY) {
      return AppLocalizations.of(context)!.money_fund;
    } else if (pca?.dashboardPrintType ==
        PrintDashboardType.DAILY_INVOICE_ONLY) {
      return "Daily invoice";
    } else {
      return getMainHeaderTextOnly(context);
    }
  }

  Color getColorB(PrintDashboardSetting? pca) {
    if (pca?.dashboardPrintType == PrintDashboardType.ALL) {
      return Colors.orange;
    } else if (pca?.dashboardPrintType == PrintDashboardType.MONEY_FUND_ONLY) {
      return Colors.green;
    } else {
      return Colors.orangeAccent;
    }
  }

  @override
  String getPrintablePrimaryColor(PrintDashboardSetting? pca) {
    return getColorB(pca).toHex();
  }

  @override
  String getPrintableSecondaryColor(PrintDashboardSetting? pca) =>
      getColorB(pca).toHex();

  @override
  String getPrintableQrCode() => "";

  @override
  String getPrintableQrCodeID() => "";

  bool shouldViewInvoice(PrintDashboardSetting? pca) {
    return pca?.dashboardPrintType == PrintDashboardType.DAILY_INVOICE_ONLY ||
        pca?.dashboardPrintType == PrintDashboardType.ALL;
  }

  bool shouldViewMoney(PrintDashboardSetting? pca) {
    return pca?.dashboardPrintType == PrintDashboardType.MONEY_FUND_ONLY ||
        pca?.dashboardPrintType == PrintDashboardType.ALL;
  }

  List<PrintableMaster> getList(List? list, PrintDashboardSetting? pca) {
    if (list == null) return [];
    if (pca?.currency != null && list is List<MoneyFunds>) {
      debugPrint("List is MoneyFunds");
      return (list)
          .where((p) => p.equalities?.currency?.iD == pca!.currency!.iD)
          .toList();
    }
    return list.cast();
  }

  @override
  List<PrintableMaster<PrintLocalSetting>>
  getPrintableRecieptMasterDashboardLists(
    BuildContext context,
    PrintDashboardSetting? pca,
  ) => [
    if (shouldViewMoney(pca)) ...getList(credits, pca),
    if (shouldViewMoney(pca)) ...getList(debits, pca),
    if (shouldViewMoney(pca)) ...getList(incomes, pca),
    if (shouldViewMoney(pca)) ...getList(spendings, pca),

    if (shouldViewInvoice(pca)) ...orders?.cast() ?? [],
    if (shouldViewInvoice(pca)) ...purchases?.cast() ?? [],
    if (shouldViewInvoice(pca)) ...orders_refunds?.cast() ?? [],
    if (shouldViewInvoice(pca)) ...purchases_refunds?.cast() ?? [],
    if (shouldViewInvoice(pca)) ...cut_requests?.cast() ?? [],

    // if (debits?.isNotEmpty ?? false) debits!,
    // if (spendings?.isNotEmpty ?? false) spendings!,
    // if (incomes?.isNotEmpty ?? false) incomes!,
  ];

  @override
  pdf.Widget? getPrintableWatermark(d.PdfPageFormat? format) => null;

  @override
  List<String> getPrintableDashboardTableHeaders(
    BuildContext context,
    PrintDashboardSetting? pca,
    PdfDashnoardApi<
      PrintableDashboardInterface<PrintLocalSetting>,
      PrintLocalSetting
    >
    generator,
  ) {
    if (pca?.dashboardPrintType == PrintDashboardType.MONEY_FUND_ONLY) {
      return [
        AppLocalizations.of(context)!.date,
        AppLocalizations.of(context)!.description,
        if (pca?.hideCurrency == false) AppLocalizations.of(context)!.currency,
        AppLocalizations.of(context)!.credits,
        AppLocalizations.of(context)!.debits,
        AppLocalizations.of(context)!.balance,
      ].map((e) => e.toUpperCase()).toList();
    }
    return [
      AppLocalizations.of(context)!.date,
      AppLocalizations.of(context)!.description,
      AppLocalizations.of(context)!.quantityShortCut,
      AppLocalizations.of(context)!.unit,
      AppLocalizations.of(context)!.debits,
      AppLocalizations.of(context)!.credits,
      AppLocalizations.of(context)!.equality,
      AppLocalizations.of(context)!.balance,
    ].map((e) => e.toUpperCase()).toList();
  }

  int getPrintableDashboardCreditIndex(PrintDashboardSetting? pca, r) {
    if (pca?.hideCurrency == false) {
      return 3;
    } else {
      return 2;
    }
  }

  int getPrintableDashboardDebitIndex(PrintDashboardSetting? pca) {
    if (pca?.hideCurrency == false) {
      return 4;
    } else {
      return 3;
    }
  }

  @override
  String getModifiableMainGroupName(BuildContext context) => "";

  // @override
  // PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
  //         BuildContext context) =>
  //     this;

  @override
  IconData getModifibleIconData() => getMainIconData();

  @override
  PrintDashboardSetting getModifibleSettingObject(BuildContext context) {
    return PrintDashboardSetting();
  }

  @override
  String getModifibleTitleName(BuildContext context) => "sdad";

  @override
  DashboardContentItem? getPrintableDashboardFirstRowContentItem(
    BuildContext context,
    PrintDashboardSetting? pca,
    PdfDashnoardApi<
      PrintableDashboardInterface<PrintLocalSetting>,
      PrintLocalSetting
    >
    generator,
  ) {
    if (pca?.includePreviousBalance == true) {
      return DashboardContentItem(
        shouldAddToBalance: true,
        showDebitAndCredit: false,
        date: dateObject?.from,
        description: AppLocalizations.of(context)!.previousBalance,
      );
    }
    return null;
  }

  @override
  List<String> getPrintableDashboardRowContentConverter(
    BuildContext context,
    PrintDashboardSetting? pca,
    PdfDashnoardApi<
      PrintableDashboardInterface<PrintLocalSetting>,
      PrintLocalSetting
    >
    generator,
    DashboardContentItem dynamicList,
  ) {
    double? debitsDouble;
    double? creditsDouble;
    debitsDouble = dynamicList.debit;
    creditsDouble = dynamicList.credit;
    double? balancesGe =
        (creditsDouble.toNonNullable() - debitsDouble.toNonNullable());
    if (!dynamicList.showDebitAndCredit) {
      addBalance(balancesGe, "s");
      creditsDouble = null;
      debitsDouble = null;
    }
    if (dynamicList.shouldAddToBalance) {
      addBalance(balancesGe, dynamicList.currency);
    }
    if (pca?.dashboardPrintType == PrintDashboardType.MONEY_FUND_ONLY) {
      return [
        dynamicList.date ?? "-",
        dynamicList.description ?? "-",
        if (pca?.hideCurrency == false) dynamicList.currency ?? "-",
        creditsDouble == null ? " " : creditsDouble.toCurrencyFormat(),
        debitsDouble == null ? " " : debitsDouble.toCurrencyFormat(),
        getBalance(),
      ];
    }
    return [
      dynamicList.date ?? "-",
      dynamicList.description ?? "-",
      dynamicList.quantity ?? " ",
      dynamicList.unit ?? " ",
      debitsDouble == null ? " " : debitsDouble.toCurrencyFormat(),
      creditsDouble == null ? " " : creditsDouble.toCurrencyFormat(),
      " EQ",
      getBalance(),
    ].map((e) => e.toUpperCase()).toList();
  }
}
