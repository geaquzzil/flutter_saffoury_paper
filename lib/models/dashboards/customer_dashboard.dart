import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:flutter_saffoury_paper/models/users/balances/customer_terms.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_custom_auto_rest_custom_view_horizontal.dart';
import 'package:flutter_view_controller/printing_generator/pdf_dashboard_api.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/src/widgets/widget.dart' as pdf;

import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
import '../users/customers.dart';

part 'customer_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerDashboard extends UserLists<CustomerDashboard>
    with ModifiableInterface<PrintCustomerDashboardSetting>
    implements
        DashableInterface,
        PrintableDashboardInterface<PrintCustomerDashboardSetting> {
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
  RequestOptions? getRequestOption({required ServerActions action}) {
    return RequestOptions()
        .addSearchByField(
            "date", jsonEncode(dateObject?.toJson() ?? DateObject().toJson()))
        .addSearchByField("withAnalysis", true);
  }
  l

  @override
  Map<String, String> get getCustomMap => {
        "<iD>": iD.toString(),
        "date": jsonEncode(dateObject?.toJson() ?? DateObject().toJson()),
        "withAnalysis": "true"
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
      BuildContext context, int crossAxisCount,
      {GlobalKey<BasePageStateWithApi>? globalKey, TabControllerHelper? tab}) {
    return [
      DashableGridHelper(
          sectionsListToTabbar: getListOfTabbarFunds(),
          headerListToAdd: [Credits(), Debits(), Spendings(), Incomes()],
          title: AppLocalizations.of(context)!.overview,
          widgets: [
            ...getFundWidgets(context, crossAxisCount, checkForEmpty: false),
            // ...getInvoicesWidgets(context)
          ]),
      DashableGridHelper(
          title: AppLocalizations.of(context)!.invoice,
          headerListToAdd: [
            Order(),
            Purchases(),
            CutRequest(),
            Transfers(),
            ProductInput(),
            ProductOutput(),
            ReservationInvoice()
          ],
          widgets: [
            ...getInvoicesWidgets(context, crossAxisCount)
          ]),
    ];
  }

  @override
  bool getPrintableSupportsLabelPrinting() => false;
  @override
  getDashboardSectionsSecoundPane(BuildContext context, int crossAxisCount,
      {GlobalKey<BasePageStateWithApi>? globalKey,
      TabControllerHelper? tab,
      TabControllerHelper? tabSecondPane}) {
    if (tabSecondPane != null && tabSecondPane.extras != null) {
      return [
        // LineChartItem(list: , xValueMapper: xValueMapper, yValueMapper: yValueMapper)
        getSliverListFromExtrasTabbar(context, tabSecondPane)
      ];
    }

    return [
      DashableGridHelper(title: AppLocalizations.of(context)!.total, widgets: [
        getWidget(
          StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1.5,
              child: MultiLineChartItem<GrowthRate, DateTime>(
                title: "T",
                list: [...getAnalysisChartFunds(), ...getAnalysisChart()],
                titles: [
                  ...getAnalysisChartFundsTitle(context),
                  ...getAnalysisChartTitle(context)
                ],
                dataLabelMapper: (item, idx) => item.total.toCurrencyFormat(),
                xValueMapper: (item, value, indexInsideList) => DateTime(
                    value.year ?? 2022, value.month ?? 1, value.day ?? 1),
                yValueMapper: (item, n, indexInsideList) => n.total,
              )),
          type: WidgetDashboardType.CHART,
        ),
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
                color: Colors.blue,
                icon: Icons.credit_card,
                title: AppLocalizations.of(context)!.totalFormat(
                    AppLocalizations.of(context)!.credits.toLowerCase()),
                description: creditsAnalysis.getTotalTextFromSetting(context)
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
                color: Colors.red,
                icon: Icons.arrow_back,
                title: AppLocalizations.of(context)!.totalFormat(
                    AppLocalizations.of(context)!.debits.toLowerCase()),
                description: debitsAnalysis.getTotalTextFromSetting(context)
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),

        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: .75,
            child: ChartCardItemCustom(
                color: Colors.orange,
                icon: Icons.arrow_back,
                title: AppLocalizations.of(context)!.balance_due,
                description: balance.toCurrencyFormatFromSetting(context)
                // footer: incomes?.length.toString(),
                // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: ListHorizontalCustomViewCustomApiAutoRestWidget(
                onResponse: (g) {
                  List<GrowthRate> growthList = List.castFrom(g);
                  return ChartCardItemCustom(
                    // color: Colors.orange,
                    icon: Icons.donut_small_sharp,
                    title: AppLocalizations.of(context)!.profit_analysis,
                    listGrowthRate: growthList,

                    description: growthList.getTotalTextFromSetting(context),
                    // footer: incomes?.length.toString(),
                    footerRightWidget:
                        incomesAnalysis.getGrowthRateText(context),
                  );
                },
                autoRest: AutoRestCustom<GrowthRate>(
                    responseType: ResponseType.LIST,
                    customMap: {
                      "iD": "${customers!.iD}",
                      "date": jsonEncode(
                          dateObject?.toJson() ?? DateObject().toJson()),
                    },
                    action: "list_customers_profit",
                    key: "list_customers_profit${customers!.iD}",
                    responseObjcect: GrowthRate())))),
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ListHorizontalCustomViewCustomApiAutoRestWidget(
                onResponse: (g) {
                  List<CustomerTerms> growthList = List.castFrom(g);
                  return ChartCardItemCustom(
                    icon: Icons.broken_image,
                    title: AppLocalizations.of(context)!.termsAndConitions,
                    description: AppLocalizations.of(context)!
                        .totalFormat(growthList.length),
                  );
                },
                autoRest: AutoRestCustom<CustomerTerms>(
                    responseType: ResponseType.LIST,
                    customMap: {
                      "iD": "${customers!.iD}",
                    },
                    action: "list_customers_terms",
                    key: "list_customers_terms${customers!.iD}",
                    responseObjcect: CustomerTerms())))),
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCount,
            mainAxisCellCount: 3,
            child: BaseViewNewPage(viewAbstract: customers!)))
        // ...getInvoicesWidgets(context)
      ]),
    ];
  }

  @override
  void setDate(DateObject? date) {
    dateObject = date;
    balance = null;
  }

  @override
  bool canGetObjectWithoutApiChecker(ServerActions action) {
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
      GlobalKey<BasePageStateWithApi>? globalKey,
      TabControllerHelper? tab}) {
    debugPrint("getDashboardShouldWaitBefore $iD");
    firstPane = firstPane ?? false;
    if (iD == -1) {
      return [
        if (firstPane)
          SliverFillRemaining(
            child: BaseEditWidget(
              currentScreenSize: findCurrentScreenSize(context),
              viewAbstract: CustomerDashboardSelector(), isTheFirst: true,
              onValidate: (v) {
                if (v == null) return;

                CustomerDashboardSelector cds = v as CustomerDashboardSelector;
                debugPrint(
                    "refresh customerr ${cds.customer?.iD} date ${cds.date} ");
                iD = cds.customer!.iD;
                dateObject = DateObject(from: cds.date!, to: cds.date!);
                globalKey?.currentState?.refresh(extras: this, tab: tab);
              },
              // onFabClickedConfirm: (v) {},
            ),
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
      GlobalKey<BasePageStateWithApi>? globalKey,
      TabControllerHelper? tab}) {
    if (iD == -1 || firstPane == false) {
      return null;
    }
    return DashboardHeader(
      date: dateObject ?? DateObject(),
      current_screen_size: findCurrentScreenSize(context),
      onSelectedDate: (d) {
        if (d == null) return;
        dateObject = d;
        balance = null;
        globalKey?.currentState?.refresh(extras: this, tab: tab);
        // getExtras().setDate(d);
        // refresh(extras: extras);
      },
    );
    return HeaderText(
        fontSize: 15,
        useRespnosiveLayout: false,
        text: "Search results: “${customers?.name}",
        description: Html(
          data:
              "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
        ));

    return null;
  }

  @override
  List<TabControllerHelper>? getDashboardTabbarSectionSecoundPaneList(
          BuildContext context) =>
      getTabBarSecondPane(context);

  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.customerBalance;

  // @override
  // PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
  //         BuildContext context) =>
  //     this;

  @override
  IconData getModifibleIconData() => Icons.dashboard;

  @override
  PrintCustomerDashboardSetting getModifibleSettingObject(
      BuildContext context) {
    return PrintCustomerDashboardSetting();
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableDashboardAccountInfoInBottom(
          BuildContext context, PrintCustomerDashboardSetting? pca) {
    return [
      if (customers != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: "${AppLocalizations.of(context)!.iD}: ",
          description: customers?.iD.toString() ?? "",
          // icon: Icons.numbers
        ),
      if (customers != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: "${AppLocalizations.of(context)!.name}: ",
          description: customers?.name ?? "",
          // icon: Icons.account_circle_rounded
        ),
    ];
  }

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetBottom(
          BuildContext context,
          PrintCustomerDashboardSetting? pca,
          PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
                  PrintLocalSetting>
              generator) =>
      null;

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetTop(
          BuildContext context,
          PrintCustomerDashboardSetting? pca,
          PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
                  PrintLocalSetting>
              generator) =>
      null;

  @override
  DashboardContentItem? getPrintableDashboardFirstRowContentItem(
      BuildContext context,
      PrintCustomerDashboardSetting? pca,
      PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
              PrintLocalSetting>
          generator) {
    // TODO: implement previous balance
    if (pca?.includePreviousBalance == true) {
      return DashboardContentItem(
          shouldAddToBalance: true,
          showDebitAndCredit: false,
          date: dateObject?.from,
          description: AppLocalizations.of(context)!.previousBalance,
          credit: previousBalance.toNonNullable() > 0 ? 0 : previousBalance,
          debit: previousBalance.toNonNullable() > 0 ? previousBalance : 0);
    }
    return null;
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableDashboardFooterTotal(
          BuildContext context, PrintCustomerDashboardSetting? pca) =>
      [];

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>>
      getPrintableDashboardHeaderInfo(
          BuildContext context, PrintCustomerDashboardSetting? pca) {
    List<InvoiceHeaderTitleAndDescriptionInfo>? first =
        getInvoicDesFirstRow(context, pca);
    List<InvoiceHeaderTitleAndDescriptionInfo>? sec =
        getInvoiceDesSecRow(context, pca);
    List<InvoiceHeaderTitleAndDescriptionInfo>? therd =
        getInvoiceDesTherdRow(context, pca);

    return [
      if (first != null) first,
      if (sec != null) sec,
      if (therd != null) therd
    ];
  }

  @override
  List<String> getPrintableDashboardRowContentConverter(
      BuildContext context,
      PrintCustomerDashboardSetting? pca,
      PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
              PrintLocalSetting>
          generator,
      DashboardContentItem dynamicList) {
    // TODO: implement getPrintableDashboardRowContentConverter
    throw UnimplementedError();
  }

  @override
  List<String> getPrintableDashboardTableHeaders(
      BuildContext context,
      PrintCustomerDashboardSetting? pca,
      PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
              PrintLocalSetting>
          generator) {
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

  @override
  List<InvoiceTotalTitleAndDescriptionInfo>
      getPrintableDashboardTotalDescripton(
          BuildContext context, PrintCustomerDashboardSetting? pca) {
    // TODO: implement getPrintableDashboardTotalDescripton
    throw UnimplementedError();
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
          BuildContext context, PrintLocalSetting? dashboardSetting) =>
      null;

  @override
  String getPrintableInvoiceTitle(
          BuildContext context, PrintCustomerDashboardSetting? pca) =>
      AppLocalizations.of(context)!.accountStatement;
  @override
  String getPrintableSecondaryColor(PrintCustomerDashboardSetting? pca) =>
      Colors.orangeAccent.toHex();
  @override
  String getPrintablePrimaryColor(PrintCustomerDashboardSetting? pca) =>
      Colors.orangeAccent.toHex();

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(
      iD: customers?.iD ?? -1,
      extra: dateObject?.toJson().toString(),
      action: getCustomAction() ?? "",
    );
    return q.getQrCode();
  }

  @override
  String getPrintableQrCodeID() => "";

  @override
  List<PrintableMaster<PrintLocalSetting>>
      getPrintableRecieptMasterDashboardLists(
          BuildContext context, PrintCustomerDashboardSetting? pca) {
    return [];
  }

  @override
  pdf.Widget? getPrintableWatermark(d.PdfPageFormat? format) => null;
}

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerDashboardSelector
    extends ViewAbstract<CustomerDashboardSelector> {
  Customer? customer;
  String? date;

  CustomerDashboardSelector() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "date": "",
        "customer": Customer(),
      };

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
  FormFieldControllerType getInputType(String field) {
    if (field == "customer") {
      return FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API;
    }
    return super.getInputType(field);
  }

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
  List<String> getMainFields({BuildContext? context}) => ["customer", "date"];

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
  SortFieldValue? getSortByInitialType() => null;

  @override
  String? getTableNameApi() => null;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};
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
