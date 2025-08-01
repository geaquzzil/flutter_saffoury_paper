// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/print_invoice.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/changes_records.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
// import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/widgets.dart' as pdf;
import 'package:provider/provider.dart';

import 'invoice_master_details.dart';
import 'orders.dart';

abstract class InvoiceMaster<T> extends ViewAbstract<T>
    with ModifiableInterface<PrintInvoice>
    implements
        PrintableInvoiceInterface<PrintInvoice>,
        ListableInterface<InvoiceMasterDetails>,
        WebCategoryGridableInterface<InvoiceMaster>,
        SharableInterface {
  // int? EmployeeID;
  // int? CargoTransID;
  // int? CustomerID;
  Terms? terms;
  int? TermsID;

  String? date;
  @JsonKey(fromJson: intFromString)
  String? billNo; //255
  String? comments;

  Employee? employees;
  Customer? customers;
  CargoTransporter? cargo_transporters;

  InvoiceStatus? status;
  @JsonKey(fromJson: convertToDouble)
  double? quantity;
  @JsonKey(fromJson: convertToDouble)
  double? extendedPrice;
  @JsonKey(fromJson: convertToDouble)
  double? refundQuantity;
  @JsonKey(fromJson: convertToDouble)
  double? extendedRefundPrice;
  @JsonKey(fromJson: convertToDouble)
  double? extendedDiscount;
  @JsonKey(fromJson: convertToDouble)
  double? extendedNetPrice;
  @JsonKey(fromJson: convertToDouble)
  double? extendedNetQuantity;
  InvoiceMaster() : super() {
    date = "".toDateTimeNowString();
    TermsID = -1;
  }

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
    if (action == ServerActions.edit && isNew()) {
      employees = context.read<AuthProvider<AuthUser>>().getUser as Employee?;
      status = InvoiceStatus.APPROVED;
    }
    terms = getTermsFromID(TermsID ?? -1);
  }

  @override
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
    BuildContext context,
  ) => {
    "TermsID": [
      AppLocalizations.of(context)!.pay1,
      AppLocalizations.of(context)!.pay2,
      AppLocalizations.of(context)!.pay3,
      AppLocalizations.of(context)!.pay4,
      AppLocalizations.of(context)!.pay5,
      AppLocalizations.of(context)!.pay6,
      AppLocalizations.of(context)!.pay7,
      AppLocalizations.of(context)!.pay8,
    ],
  };

  @override
  void onDropdownChanged(
    BuildContext context,
    String field,
    value, {
    GlobalKey<FormBuilderState>? formKey,
  }) {
    super.onDropdownChanged(context, field, value, formKey: formKey);

    if (field == "terms") {
      setTermsID(value as Terms);
    }
  }

  Terms getTermsFromID(int termID) {
    if (termID == -1) {
      return Terms.pay1;
    } else if (termID == -7) {
      return Terms.pay2;
    } else if (termID == 7) {
      return Terms.pay3;
    } else if (termID == 10) {
      return Terms.pay4;
    } else if (termID == 30) {
      return Terms.pay5;
    } else if (termID == -30) {
      return Terms.pay6;
    } else if (termID == 1) {
      return Terms.pay7;
    } else if (termID == 80) {
      return Terms.pay8;
    } else {
      return Terms.none;
    }
  }

  Terms getTermsFromString(BuildContext context, String value) {
    if (value == AppLocalizations.of(context)!.pay1) {
      return Terms.pay1;
    } else if (value == AppLocalizations.of(context)!.pay2) {
      return Terms.pay2;
    } else if (value == AppLocalizations.of(context)!.pay3) {
      return Terms.pay3;
    } else if (value == AppLocalizations.of(context)!.pay4) {
      return Terms.pay4;
    } else if (value == AppLocalizations.of(context)!.pay5) {
      return Terms.pay5;
    } else if (value == AppLocalizations.of(context)!.pay6) {
      return Terms.pay6;
    } else if (value == AppLocalizations.of(context)!.pay7) {
      return Terms.pay7;
    } else if (value == AppLocalizations.of(context)!.pay8) {
      return Terms.pay8;
    } else {
      return Terms.none;
    }
  }

  void setTermsID(Terms terms) {
    if (terms == Terms.pay1) {
      TermsID = -1;
    } else if (terms == Terms.pay1) {
      TermsID = -7;
    } else if (terms == Terms.pay1) {
      TermsID = 7;
    } else if (terms == Terms.pay1) {
      TermsID = 10;
    } else if (terms == Terms.pay1) {
      TermsID = 30;
    } else if (terms == Terms.pay1) {
      TermsID = -30;
    } else if (terms == Terms.pay1) {
      TermsID = 1;
    } else if (terms == Terms.pay1) {
      TermsID = 60;
    } else {
      TermsID = -1;
    }
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.receipt_long_rounded;
  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
    "employees": Employee(),
    "customers": Customer(),
    "cargo_transporters": CargoTransporter(),
    "date": "",
    "billNo": "",
    "status": InvoiceStatus.NONE,
    "terms": Terms.none,
    "comments": "",
  };
  @override
  List<String> getMainFields({BuildContext? context}) => [
    if (!isCustomerLessInvoice()) "customers",
    "cargo_transporters",
    "employees",
    "date",
    "billNo",
    if (isHasStatusInvocie()) "status",
    if (isTermsInvoice()) "terms",
    "comments",
  ];
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
    "date": AppLocalizations.of(context)!.date,
    "billNo": AppLocalizations.of(context)!.product_bill,
    "status": AppLocalizations.of(context)!.status,
    "comments": AppLocalizations.of(context)!.comments,
  };
  @override
  Map<String, IconData> getFieldIconDataMap() => {
    "date": Icons.date_range,
    "billNo": Icons.onetwothree,
    "status": Icons.credit_card,
    "comments": Icons.comment,
  };
  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
    "date": TextInputType.datetime,
    "billNo": TextInputType.text,
    "comments": TextInputType.multiline,
  };
  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${getIDFormat(context)} ${getMainHeaderLabelTextOnly(context)}";

  @override
  Widget? getMainSubtitleHeaderText(
    BuildContext context, {
    String? searchQuery,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Customer : ${customers?.name}"),
        Text("Total:${extendedNetPrice.toCurrencyFormat()}"),
        // Align(
        //     alignment: AlignmentDirectional.centerEnd,
        //     child: Text("Date: $date")),
      ],
    );
  }

  List<Product> getProductsFromDetailList() {
    var products = getDetailListFromMaster()
        .map(
          (e) => e.products!.copyWith({
            "inStock": List<Stocks>.from([
              e.getStockFromDetails(),
            ]).map((e) => e.toJson()).toList(),
          }),
        )
        .toList();
    return products;
  }

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
  Map<String, bool> isFieldRequiredMap() => {"warehouse": true};
  @override
  Map<String, bool> isFieldCanBeNullableMap() => {
    "cargo_transporters": true,
    "warehouse": false, // if there are warehouse then it cant be null
  };
  @override
  FormFieldControllerType getInputType(String field) {
    if (field == "warehouse") {
      return FormFieldControllerType.DROP_DOWN_API;
    }
    return FormFieldControllerType.EDIT_TEXT;
  }

  @override
  IconData getMainIconData() => Icons.receipt;
  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoices;

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintInvoice? pca) =>
      getMainHeaderLabelTextOnly(context).toUpperCase();
  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    return [
      getInvoicDesFirstRow(context, pca),
      getInvoiceDesSecRow(context, pca),
      getInvoiceDesTherdRow(context, pca),
    ];
  }

  double? getTotalDiscountFromList() {
    try {
      return getDetailListFromMaster()
          .map((e) => e.discount)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  @override
  bool getPrintableSupportsLabelPrinting() => true;

  double? getTotalPriceFromList() {
    try {
      return getDetailListFromMaster()
          .map((e) => e.price)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  double? getTotalQuantityFromList() {
    try {
      return getDetailListFromMaster()
          .map((e) => e.quantity)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  @override
  InvoiceMasterDetails getListableAddFromManual(BuildContext context) {
    return getDetailMasterNewInstance();
  }

  @override
  double? getListableTotalPrice(BuildContext context) {
    return getTotalPriceFromList();
  }

  @override
  bool isSupportAddFromManual() {
    return true;
  }

  @override
  bool isListableRequired(BuildContext context) {
    return true;
  }

  @override
  String? getListableTotalQuantity(BuildContext context) {
    return getDetailListFromMaster()
        .cast<InvoiceMasterDetails>()
        .getTotalQuantityGroupedFormattedText(context);
  }

  @override
  double? getListableTotalDiscount(BuildContext context) {
    return getTotalDiscountFromList();
  }

  @override
  Widget? getListableCustomHeader(BuildContext context) {
    return null;
  }

  @override
  List<Widget>? getCustomBottomWidget(
    BuildContext context, {
    ServerActions? action,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
  }) {
    double? totalPrice = getTotalPriceFromList();
    double? totalDiscount = getTotalDiscountFromList();
    double? totalQuantity = getTotalQuantityFromList();
    double? totalNetPrice = (totalPrice ?? 0) - (totalDiscount ?? 0);
    Widget child = Column(
      children: [
        getListTile(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: totalPrice?.toCurrencyFormatFromSetting(context) ?? "0",
        ),
        const Divider(),
        getListTile(
          title: AppLocalizations.of(context)!.discount.toUpperCase(),
          description:
              totalDiscount?.toCurrencyFormatFromSetting(context) ?? "0",
        ),
        const Divider(),
        getListTile(
          title: AppLocalizations.of(context)!.quantity.toUpperCase(),
          description: getDetailListFromMaster()
              .cast<InvoiceMasterDetails>()
              .getTotalQuantityGroupedFormattedText(context),
        ),
        const Divider(),
        getListTile(
          title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
          description: totalNetPrice.toCurrencyFormatFromSetting(context),
        ),
      ],
    );
    return [
      SliverToBoxAdapter(
        child: CardBackgroundWithTitle(
          leading: Icons.summarize,
          useHorizontalPadding: true,
          useVerticalPadding: false,
          title: AppLocalizations.of(context)!.no_summary,
          child: child,
        ),
      ),
    ];
    return [
      if (kIsWeb)
        SliverToBoxAdapter(
          child: CardBackgroundWithTitle(
            leading: Icons.summarize,
            useHorizontalPadding: true,
            useVerticalPadding: false,
            title: AppLocalizations.of(context)!.no_summary,
            child: child,
          ),
        )
      else
        SliverToBoxAdapter(
          child: ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(Icons.summarize),
            title: Text(AppLocalizations.of(context)!.no_summary),
            children: [child],
          ),
        ),
    ];
  }

  Widget getListTile({required String title, required String description}) {
    return ChartCardItemCustom(title: (title), description: (description));
  }

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
  getPrintableInvoiceAccountInfoInBottom(
    BuildContext context,
    PrintInvoice? pca,
  ) => [
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
    if ((pca?.hideCargoInfo == false))
      if (cargo_transporters != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: "${AppLocalizations.of(context)!.transfers}: ",
          description:
              "${cargo_transporters?.name.toString()}\n${cargo_transporters?.carNumber} ${cargo_transporters?.governorates?.name}",
          // icon: Icons.numbers
        ),
    if ((pca?.hideEmployeeName == false))
      if (employees != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: "${AppLocalizations.of(context)!.employee}: ",
          description: "${employees?.name.toString()}",
          // icon: Icons.numbers
        ),
  ];
  int getDetailListFromMasterItemsCount() {
    if (runtimeType == Order) {
      return (this as Order).orders_details_count ?? 0;
    } else if (runtimeType == Purchases) {
      return (this as Purchases).purchases_details_count ?? 0;
    } else if (runtimeType == OrderRefund) {
      return (this as OrderRefund).orders_refunds_order_details_count ?? 0;
    } else if (runtimeType == PurchasesRefund) {
      return (this as PurchasesRefund)
              .purchases_refunds_purchases_details_count ??
          0;
    } else if (runtimeType == ProductInput) {
      return (this as ProductInput).products_inputs_details_count ?? 0;
    } else if (runtimeType == ProductOutput) {
      return (this as ProductOutput).products_outputs_details_count ?? 0;
    } else if (runtimeType == ReservationInvoice) {
      return (this as ReservationInvoice).reservation_invoice_details_count ??
          0;
    } else if (runtimeType == Transfers) {
      return (this as Transfers).trasfers_details_count ?? 0;
    } else if (runtimeType == CustomerRequestSize) {
      return (this as CustomerRequestSize)
              .customers_request_sizes_details_count ??
          0;
    } else {
      return 0;
    }
  }

  List<InvoiceMasterDetails> getDetailListFromMaster() {
    if (runtimeType == Order) {
      return (this as Order).orders_details ?? [];
    } else if (runtimeType == Purchases) {
      return (this as Purchases).purchases_details ?? [];
    } else if (runtimeType == OrderRefund) {
      return (this as OrderRefund).orders_refunds_order_details ?? [];
    } else if (runtimeType == PurchasesRefund) {
      return (this as PurchasesRefund).purchases_refunds_purchases_details ??
          [];
    } else if (runtimeType == ProductInput) {
      return (this as ProductInput).products_inputs_details ?? [];
    } else if (runtimeType == ProductOutput) {
      return (this as ProductOutput).products_outputs_details ?? [];
    } else if (runtimeType == ReservationInvoice) {
      return (this as ReservationInvoice).reservation_invoice_details ?? [];
    } else if (runtimeType == Transfers) {
      return (this as Transfers).transfers_details ?? [];
    } else if (runtimeType == CustomerRequestSize) {
      return (this as CustomerRequestSize).customers_request_sizes_details ??
          [];
    } else {
      return [];
    }
  }

  List<InvoiceMasterDetails> getDetailListFromMasterSetNewOnList() {
    if (runtimeType == Order) {
      return (this as Order).orders_details ??= [];
    } else if (runtimeType == Purchases) {
      return (this as Purchases).purchases_details ??= [];
    } else if (runtimeType == OrderRefund) {
      return (this as OrderRefund).orders_refunds_order_details ??= [];
    } else if (runtimeType == PurchasesRefund) {
      return (this as PurchasesRefund).purchases_refunds_purchases_details ??=
          [];
    } else if (runtimeType == ProductInput) {
      return (this as ProductInput).products_inputs_details ??= [];
    } else if (runtimeType == ProductOutput) {
      return (this as ProductOutput).products_outputs_details ??= [];
    } else if (runtimeType == CustomerRequestSize) {
      return (this as CustomerRequestSize).customers_request_sizes_details ??=
          [];
    } else if (runtimeType == ReservationInvoice) {
      return (this as ReservationInvoice).reservation_invoice_details ??= [];
    } else if (runtimeType == Transfers) {
      return (this as Transfers).transfers_details ??= [];
    } else {
      return [];
    }
  }

  InvoiceMasterDetails getDetailMasterNewInstance() {
    if (runtimeType == Order) {
      return OrderDetails();
    } else if (runtimeType == Purchases) {
      return PurchasesDetails();
    } else if (runtimeType == OrderRefund) {
      return OrderRefundDetails();
    } else if (runtimeType == PurchasesRefund) {
      return PurchasesRefundDetails();
    } else if (runtimeType == ProductInput) {
      return ProductInputDetails();
    } else if (runtimeType == ProductOutput) {
      return ProductOutputDetails();
    } else if (runtimeType == CustomerRequestSize) {
      return CustomerRequestSizeDetails();
    } else if (runtimeType == ReservationInvoice) {
      return ReservationInvoiceDetails();
    } else if (runtimeType == Transfers) {
      return TransfersDetails();
    } else {
      return OrderDetails();
    }
  }

  @override
  String getPrintableQrCodeID() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss", 'en');

    String year = "${dateFormat.parse(date ?? "").year}";
    String invCode = "";

    if (runtimeType == Order) {
      invCode = "INV";
    } else if (runtimeType == Purchases) {
      invCode = "PURCH";
    } else if (runtimeType == OrderRefund) {
      invCode = "INV-R";
    } else if (runtimeType == PurchasesRefund) {
      invCode = "PURCH-R";
    } else if (runtimeType == ProductInput) {
      invCode = "PRI";
    } else if (runtimeType == ProductOutput) {
      invCode = "PRO";
    } else if (runtimeType == CustomerRequestSize) {
      invCode = "CUS-S";
    } else if (runtimeType == ReservationInvoice) {
      invCode = "RES";
    } else if (runtimeType == Transfers) {
      invCode = "TR";
    } else {
      invCode = "N";
    }
    return "$invCode-$iD-$year";
  }

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(iD: iD, action: getTableNameApi() ?? "");
    return q.getQrCode();
  }

  @override
  Color? getMainColor() {
    if (runtimeType == Order) {
      return Colors.green;
    } else if (runtimeType == Purchases) {
      return Colors.red;
    } else if (runtimeType == OrderRefund) {
      return Colors.red;
    } else if (runtimeType == PurchasesRefund) {
      return Colors.green;
    } else if (runtimeType == ProductInput) {
      return Colors.red;
    } else if (runtimeType == ProductOutput) {
      return Colors.green;
    } else if (runtimeType == ReservationInvoice) {
      return Colors.purple;
    } else if (runtimeType == CustomerRequestSize) {
      return Colors.orange;
    } else if (runtimeType == Transfers) {
      return Colors.orange;
    } else {
      return Colors.orange;
    }
  }

  bool isHasStatusInvocie() {
    return this is Order;
  }

  bool isTermsInvoice() {
    return this is Order || this is ReservationInvoice;
  }

  bool isCustomerLessInvoice() {
    return this is ProductOutput || this is ProductInput || this is Transfers;
  }

  bool isDebitsInvoice() {
    return this is Order || this is PurchasesRefund;
  }

  bool isCreditInvoice() {
    return this is Purchases || this is OrderRefund;
  }

  bool isRefundCreditInvoice() {
    return this is OrderRefund;
  }

  bool isRefundDebitInvoice() {
    return this is PurchasesRefund;
  }

  bool isPricelessInvoice() {
    bool result =
        this is CustomerRequestSize ||
        this is ProductInput ||
        this is ProductOutput ||
        this is ReservationInvoice ||
        this is Transfers;

    debugPrint("isPricelessInvoice for $runtimeType result =>$result");
    return result;
  }

  @override
  String getPrintablePrimaryColor(PrintInvoice? setting) {
    String value =
        setting?.primaryColor ??
        getMainColor()!.value.toRadixString(16).substring(2, 8);
    debugPrint("buildHeader $value");
    return value;
  }

  @override
  String getPrintableSecondaryColor(PrintInvoice? setting) {
    return setting?.secondaryColor ??
        getMainColor()!.darken(.1).value.toRadixString(16).substring(2, 8);
  }

  @override
  List<PrintableInvoiceInterfaceDetails> getPrintableInvoiceDetailsList() {
    return getDetailListFromMaster();
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesSecRow(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.iD,
        description: getPrintableQrCodeID(),
        // icon: Icons.numbers
      ),
      if (billNo != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.product_bill,
          description: billNo.toString(),
          // icon: Icons.date_range
        ),
      if ((pca?.hideInvoiceDate == false))
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.date,
          description: date.toString(),
          // icon: Icons.date_range
        ),
      if ((pca?.hideInvoiceDueDate == false))
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.termsDate,
          description: "TODODODODO ",
          // icon: Icons.date_range
        ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesTherdRow(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    return [
      if ((pca?.hideUnitPriceAndTotalPrice == false))
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.total_price,
          description: extendedNetPrice?.toCurrencyFormat() ?? "0",
          hexColor: getPrintablePrimaryColor(pca),
          // icon: Icons.tag
        ),
      if (!isPricelessInvoice())
        if ((pca?.hideCustomerBalance == false))
          InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.balance,
            description: customers?.balance?.toCurrencyFormat() ?? "",
            hexColor: getPrintablePrimaryColor(pca),
            // icon: Icons.balance
          ),
      if (!isPricelessInvoice())
        if ((pca?.hideInvoicePaymentMethod == false))
          InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.paymentMethod,
            description: "payment on advanced",
            hexColor: getPrintablePrimaryColor(pca),
            // icon: Icons.credit_card
          ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoicDesFirstRow(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    if (customers == null) return [];
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.mr,
        description: customers?.name ?? "TODO",
        // icon: Icons.account_circle_rounded
      ),
      if ((pca?.hideCustomerAddressInfo == false))
        if (customers?.address != null)
          InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.addressInfo,
            description: customers?.name ?? "",
            // icon: Icons.map
          ),
      if ((pca?.hideCustomerPhone == false))
        if (customers?.phone != null)
          InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.phone_number,
            description: customers?.phone.toString() ?? "",
            // icon: Icons.phone
          ),
    ];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    var converter = NumberToCharacterConverter('en');
    return [
      InvoiceTotalTitleAndDescriptionInfo(
        size: 10,
        title: AppLocalizations.of(context)!.total_quantity.toUpperCase(),
        description: quantity?.toCurrencyFormat() ?? "0",
        hexColor: Colors.grey.toHex(),
      ),
      InvoiceTotalTitleAndDescriptionInfo(
        size: 8,
        title: AppLocalizations.of(context)!.invoiceTotalInWords,
        hexColor: Colors.grey.toHex(leadingHashSign: false),
      ),
      InvoiceTotalTitleAndDescriptionInfo(
        // size: 12,
        title: converter.convertDouble(quantity ?? 0),
        // hexColor: Colors.grey.toHex()
      ),
    ];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
    BuildContext context,
    PrintInvoice? pca,
  ) {
    if ((pca?.hideUnitPriceAndTotalPrice == true)) {
      return [];
    }
    return [
      if (!isPricelessInvoice())
        InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: extendedPrice?.toCurrencyFormat() ?? "0",
        ),
      if (!isPricelessInvoice())
        InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.discount.toUpperCase(),
          description: extendedDiscount?.toCurrencyFormat() ?? "0",
        ),
      InvoiceTotalTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
        description: extendedNetPrice?.toCurrencyFormat() ?? "0",
        hexColor: getPrintablePrimaryColor(pca),
      ),
    ];
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  @override
  IconData getModifibleIconData() => Icons.print;

  @override
  PrintInvoice getModifibleSettingObject(BuildContext context) {
    return PrintInvoice()..invoice = this;
  }

  // @override
  // PrintableInvoiceInterface getModifiablePrintablePdfSetting(
  //     BuildContext context) {
  //   T o = getNewInstance();
  //   debugPrint("getModifiablePrintablePdfSetting ${o.runtimeType}");
  //   (o as InvoiceMaster).customers = Customer()..name = "Customer name";
  //   o.customers?.address = "Damascus - Syria";
  //   o.customers?.phone = "099999999";
  //   o.cargo_transporters = CargoTransporter();
  //   o.cargo_transporters?.governorates = Governorate()..name = "Damascus";
  //   o.cargo_transporters?.name = "Driver name";
  //   o.cargo_transporters?.carNumber = "Driver car number";
  //   o.employees = Employee()..name = "Employee name";
  //   List l = o.getDetailListFromMasterSetNewOnList();
  //   l.clear();
  //   l.add(o.getDetailMasterNewInstance());
  //   debugPrint("getModifiablePrintablePdfSetting $o");
  //   return o;
  // }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<InvoiceMasterDetails>? deletedList;

  @override
  List<InvoiceMasterDetails> getListableList() => getDetailListFromMaster();

  @override
  void onListableDelete(InvoiceMasterDetails item) {
    if (item.isEditing()) {
      deletedList ??= [];
      item.delete = true;
      deletedList?.add(item);
    }
    getDetailListFromMaster().remove(item);
    // if (item.isEditing()) {
    //   getDetailListFromMaster().remove(item);
    // } else {
    //   getDetailListFromMaster()
    //       .removeWhere((element) => item.products?.iD == element.products?.iD);
    // }
  }

  @override
  List<StaggeredGridTile> getHomeHorizotalList(BuildContext context) {
    num mainAxisCellCount = SizeConfig.getMainAxisCellCount(context);
    num mainAxisCellCountList = SizeConfig.getMainAxisCellCount(
      context,
      mainAxisType: MainAxisType.ListHorizontal,
    );
    return [
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: SliverApiMixinViewAbstractWidget(
          toListObject: ChangesRecords.init(this, "EmployeeID"),
        ),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: mainAxisCellCount,
        child: SliverApiMixinViewAbstractWidget(
          toListObject: ChartRecordAnalysis.init(this),
        ),
      ),
    ];
  }

  @override
  void onListableUpdate(InvoiceMasterDetails item) {
    try {
      // getDetailListFromMaster().((element) => false)
      InvoiceMasterDetails? d = getDetailListFromMaster().firstWhereOrNull(
        (element) => element.products?.iD == item.products?.iD,
      );
      d = item;
    } catch (e) {}
  }

  @override
  Product getListablePickObject() {
    return Product();
  }

  @override
  ViewAbstract? getListablePickObjectQrCode() {
    return getListablePickObject();
  }

  @override
  Widget? getCardTrailing(
    BuildContext context, {
    SecoundPaneHelperWithParentValueNotifier? secPaneHelper,
  }) {
    Widget? superWidget = super.getCardTrailing(
      context,
      secPaneHelper: secPaneHelper,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          //todo translate
          "items: ${getDetailListFromMasterItemsCount()}",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (superWidget != null) superWidget,
      ],
    );
  }

  @override
  bool hasPermissionFromParentSelectItem(
    BuildContext context,
    ViewAbstract viewAbstract,
  ) {
    if (viewAbstract is Product) {
      return viewAbstract.getQuantity() != 0;
    }
    return super.hasPermissionFromParentSelectItem(context, viewAbstract);
  }

  @override
  List<ViewAbstract> getListableInitialSelectedListPassedByPickedObject(
    BuildContext context,
  ) {
    return getProductsFromDetailList();
  }

  @override
  void onListableAddFromManual(
    BuildContext context,
    InvoiceMasterDetails addedObject,
  ) {
    getListableList().add(addedObject);
  }

  @override
  bool isListableIsImagable() {
    return false;
  }

  @override
  void onListableListAddedByQrCode(BuildContext context, ViewAbstract? view) {
    if (view == null) return;
    if (view is Product) {
      if (view.getQuantity() == 0) return;
      getDetailListFromMaster().add(
        getDetailMasterNewInstance()..setProduct(context, view),
      );
    }
  }

  //todo check current list for duplications
  ///list includes initial selected list
  @override
  void onListableSelectedListAdded(
    BuildContext context,
    List<ViewAbstract> list,
  ) {
    List<Product> products = list.cast();
    if (isNew()) {
      for (var element in products) {
        Product? isFounded = getProductsFromDetailList().firstWhereOrNull(
          (parent) => parent.isEquals(element),
        );
        if (isFounded != null) continue;
        debugPrint("onListableSelectedListAdded  added ${element.iD}");
        getDetailListFromMaster().add(
          getDetailMasterNewInstance()..setProduct(context, element),
        );
      }
      debugPrint(
        "onListableSelectedListAdded  getDetailListFromMaster length= >  ${getDetailListFromMaster().length}",
      );
    } else {}
  }




  @override
  Widget? getWebListTileItemSubtitle(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   getDateTextOnly() ?? "",
            //   style: Theme.of(context).textTheme.bodySmall,
            // ),
            Html(
              shrinkWrap: true,
              data:
                  "${AppLocalizations.of(context)!.itemCount}: <strong>${getDetailListFromMasterItemsCount()}</strong>",
            ),
            Html(
              shrinkWrap: true,
              data:
                  "${AppLocalizations.of(context)!.total_price}: <strong>${extendedNetPrice.toCurrencyFormatFromSetting(context)}</strong>",
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   getDateTextOnly() ?? "",
            //   style: Theme.of(context).textTheme.bodySmall,
            // ),
            Html(
              shrinkWrap: true,
              data:
                  "${AppLocalizations.of(context)!.total_quantity}: <strong>${getListableTotalQuantity(context)}</strong>",
            ),
            if (isHasStatusInvocie())
              Html(
                shrinkWrap: true,
                data:
                    "${AppLocalizations.of(context)!.status}: <strong>${status?.getFieldLabelString(context, status ?? InvoiceStatus.NONE)}</strong>",
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget? getWebListTileItemTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(
        //   getDateTextOnly() ?? "",
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        Html(
          shrinkWrap: true,
          data: "<strong>${getPrintableQrCodeID()}</strong>",
        ),
        Text(
          getDateTextOnlyFormat(context) ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  pdf.Widget? getPrintableWatermark(d.PdfPageFormat? format) => null;

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    return extendedNetPrice.toCurrencyFormatFromSetting(context);
  }

  @override
  InvoiceMaster getWebCategoryGridableInterface(BuildContext context) {
    return getNewInstance() as InvoiceMaster;
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return null;
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
    BuildContext context,
    PrintLocalSetting? dashboardSetting,
  ) {
    Currency c = Currency.init(context);
    return DashboardContentItem(
      currency: c.name,
      currencyId: c.iD,
      quantity: quantity.toCurrencyFormat(),
      credit: isPricelessInvoice()
          ? 0
          : isCreditInvoice()
          ? isRefundCreditInvoice()
                ? extendedRefundPrice
                : extendedPrice
          : 0,
      debit: isPricelessInvoice()
          ? 0
          : isDebitsInvoice()
          ? isRefundDebitInvoice()
                ? extendedRefundPrice
                : extendedPrice
          : 0,
      date: date,
      description: getMainHeaderTextOnly(context),
    );
  }

  @override
  String getContentSharable(BuildContext context, {ServerActions? action}) {
    PrintInvoice settings = getModifibleSettingObject(
      context,
    ).copyWithEnableAll();
    String content = getPrintableInvoiceTitle(context, settings);
    content = "$content\n\n";
    getInvoicDesFirstRow(context, settings).forEach((action) {
      content = "$content\n${action.title}: ${action.description}";
    });
    getInvoiceDesSecRow(context, settings).forEach((action) {
      content = "$content\n${action.title}: ${action.description}";
    });
    getInvoiceDesTherdRow(context, settings).forEach((action) {
      content = "$content\n${action.title}: ${action.description}";
    });
    content = "$content\n";

    String con = getPrintableInvoiceDetailsList().getString(
      context: context,
      setting: settings,
      newLineOnSubDetials: true,
      requireCommaOnSubDetails: false,
    );
    content = "$content \nDetiasl:\n$con";
    // getPrintableInvoiceDetailsList().forEach((action) {
    //   String d = action
    //       .getPrintableInvoiceTableHeaderAndContent(context, null)
    //       .toString();

    //   d = d
    //       .replaceAll("{", "")
    //       .replaceAll("}", "")
    //       .replaceAll("\n", " ")
    //       .replaceAll(",", "\n    ");
    //   content = "$content\n  - $d";
    // });
    // con = getPrintableInvoiceTotalDescripton(context, null).getString(context:context,setting:null);
    content = "$content \n\nTOTAL";
    getPrintableInvoiceTotalDescripton(context, settings).forEach((action) {
      content = "$content\n  - ${action.title}: ${action.description}";
    });
    // getPrintableSelfListTableHeaderAndContent(context, this, null)
    //     .entries
    //     .forEach((k) {
    //   content = "$content${k.key}: ${k.value}\n ";
    // });
    return content;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    if (action == ServerActions.list) {
      return RequestOptions()
          .addSortBy("date", SortByType.DESC)
          .addRequestObjcets(true);
    }
    return RequestOptions().addRequestObjcets(true).setDisablePaging();
  }
}

enum Terms implements ViewAbstractEnum<Terms> {
  @JsonValue("0")
  none,
  @JsonValue("-1")
  pay1,
  @JsonValue("-7")
  pay2,
  @JsonValue("7")
  pay3,
  @JsonValue("10")
  pay4,
  @JsonValue("30")
  pay5,
  @JsonValue("-30")
  pay6,
  @JsonValue("1")
  pay7,
  @JsonValue("80")
  pay8;

  @override
  IconData getMainIconData() => Icons.money;

  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.termsDate;
  @override
  String getFieldLabelString(BuildContext context, Terms field) {
    switch (field) {
      case Terms.none:
        return AppLocalizations.of(context)!.none;
      case Terms.pay1:
        return AppLocalizations.of(context)!.pay1;
      case Terms.pay2:
        return AppLocalizations.of(context)!.pay2;
      case Terms.pay3:
        return AppLocalizations.of(context)!.pay3;
      case Terms.pay4:
        return AppLocalizations.of(context)!.pay4;
      case Terms.pay5:
        return AppLocalizations.of(context)!.pay5;
      case Terms.pay6:
        return AppLocalizations.of(context)!.pay6;
      case Terms.pay7:
        return AppLocalizations.of(context)!.pay7;
      case Terms.pay8:
        return AppLocalizations.of(context)!.pay8;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, Terms field) {
    return Icons.date_range_outlined;
  }

  @override
  List<Terms> getValues() => Terms.values;
}

enum InvoiceStatus implements ViewAbstractEnum<InvoiceStatus> {
  NONE,
  PENDING,
  PROCESSING,
  CANCELED,
  APPROVED;

  @override
  IconData getMainIconData() => Icons.select_all_outlined;

  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;
  @override
  String getFieldLabelString(BuildContext context, InvoiceStatus field) {
    switch (field) {
      case InvoiceStatus.APPROVED:
        return AppLocalizations.of(context)!.approved;
      case InvoiceStatus.CANCELED:
        return AppLocalizations.of(context)!.canceled;
      case InvoiceStatus.NONE:
        return AppLocalizations.of(context)!.none;
      case InvoiceStatus.PENDING:
        return AppLocalizations.of(context)!.pending;
      case InvoiceStatus.PROCESSING:
        return AppLocalizations.of(context)!.processing;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, InvoiceStatus field) {
    switch (field) {
      case InvoiceStatus.APPROVED:
        return Icons.approval;
      case InvoiceStatus.CANCELED:
        return Icons.cancel;
      case InvoiceStatus.NONE:
        return Icons.disabled_by_default;
      case InvoiceStatus.PENDING:
        return Icons.pending;
      case InvoiceStatus.PROCESSING:
        return Icons.settings;
    }
  }

  @override
  List<InvoiceStatus> getValues() => InvoiceStatus.values;
}
