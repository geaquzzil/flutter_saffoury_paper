import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:provider/provider.dart';

import '../prints/print_invoice.dart';

abstract class InvoiceMasterDetails<T> extends ViewAbstract<T>
    implements PrintableInvoiceInterfaceDetails<PrintInvoice> {
  // int? ProductID;
  // int? WarehouseID;

  Product? products;
  Warehouse? warehouse;

  double? quantity;
  double? unitPrice;
  double? discount;
  double? price;

  String? comments;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Warehouse? backupWarehouse;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? backupQuantity;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? backupProductID;

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "products": Product(),
        "warehouse": Warehouse(),
        "quantity": 0.toDouble(),
        "unitPrice": 0.toDouble(),
        "discount": 0.toDouble(),
        "price": 0.toDouble(),
        "comments": ""
      };

  InvoiceMasterDetails() : super();
  InvoiceMasterDetails setProduct(BuildContext context, Product products,
      {double? quantity}) {
    this.products = products;
    unitPrice = products.getUnitSellPrice();
    price = products.getTotalSellPrice();
    this.quantity = quantity ?? products.getCartableProductQuantity();
    warehouse = (context.read<AuthProvider<AuthUser>>().getUser as Employee)
        .warehouse_employees?[0]
        .warehouse;
    discount = 0;
    return this;
  }

  @override
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
    if (action == ServerActions.edit) {
      backupQuantity = quantity;
      backupWarehouse = warehouse;
      backupProductID = products?.iD;
    }
  }

  Stocks getStockFromDetails() {
    return Stocks()
      ..quantity = quantity
      ..warehouse = warehouse;
  }

  @override
  void onDropdownChanged(BuildContext context, String field, value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onDropdownChanged(context, field, value);
    if (field == "warehouse") {
      warehouse = value as Warehouse;
      debugPrint(
          "onDropdownChanged invoiceDetail master ${formKey?.currentState?.fields}");
      // formKey?.currentState?.fields["quantity"]?.validate();
    }
  }

  // @override
  // T? onManuallyValidate(BuildContext context) {
  //   if (isPricelessInvoice()) {
  //     if (quantity.toNonNullable() == 0) {
  //       return null;
  //     }
  //   }

  //   if (price.toNonNullable() == 0 ||
  //       quantity.toNonNullable() == 0 ||
  //       unitPrice.toNonNullable() == 0) {
  //     return null;
  //   }
  //   return this as T;
  // }

  List<ListableDataRow> getListableDetailsColumns(BuildContext context) => [
        ListableDataRow("quantity", AppLocalizations.of(context)!.quantity),
        ListableDataRow("unitPrice", AppLocalizations.of(context)!.unit_price),
        ListableDataRow("discount", AppLocalizations.of(context)!.discount),
        ListableDataRow("price", AppLocalizations.of(context)!.total_price),
        ListableDataRow("comments", AppLocalizations.of(context)!.comments),
      ];

  @override
  List<String> getMainFields({BuildContext? context}) => [
        "products",
        "warehouse",
        "quantity",
        "unitPrice",
        "discount",
        "price",
        "comments"
      ];
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "quantity": AppLocalizations.of(context)!.quantity,
        "unitPrice": AppLocalizations.of(context)!.unit_price,
        "discount": AppLocalizations.of(context)!.discount,
        "price": AppLocalizations.of(context)!.total_price,
        "comments": AppLocalizations.of(context)!.comments
      };
  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "quantity": Icons.production_quantity_limits,
        "unitPrice": Icons.price_change,
        "discount": Icons.discount,
        "price": Icons.price_check,
        "comments": Icons.comment
      };
  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "quantity": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        "unitPrice":
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        "discount": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        "price": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        "comments": TextInputType.multiline
      };
  @override
  Map<String, bool> isFieldRequiredMap() => {
        "quantity": true,
        "unitPrice": true,
        "discount": true,
        "price": true,
        "warehouse": true
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      products?.getMainHeaderTextOnly(context) ?? "not found for products";

  @override
  Text getMainLabelText(BuildContext context) {
    return products?.getMainLabelText(context) ?? const Text("ds");
  }

  @override
  Text? getMainSubtitleHeaderText(BuildContext context) {
    return Text(quantity.toCurrencyFormat(symbol: "KG"));
  }

  @override
  IconData getMainIconData() => Icons.list;

  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return RequestOptions().addSortBy("iD", SortByType.DESC);
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"quantity": 10, "unitPrice": 10, "price": 10, "discount": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() =>
      {"quantity": getMaxQuantityValue(), "discount": getMaxDiscountValue()};

  @override
  Map<String, double> getTextInputMinValidateMap() =>
      {"quantity": 1, "unitPrice": 0.1, "price": 0.1, "discount": 0};

  @override
  String? getImageUrl(BuildContext context) {
    return products?.getImageUrl(context);
  }

  @override
  void onTextChangeListener(BuildContext context, String field, String? value,
      {GlobalKey<FormBuilderState>? formKey}) {
    super.onTextChangeListener(context, field, value);

    setFieldValue(field, double.tryParse(value ?? "0") ?? 0);

    if (field == "quantity") {
      price =
          (quantity.toNonNullable() * unitPrice.toNonNullable()).roundDouble();
    }
    if (field == "price") {
      unitPrice =
          (price.toNonNullable() / quantity.toNonNullable()).roundDouble();
    }
    if (field == "unitPrice") {
      price =
          (unitPrice.toNonNullable() * quantity.toNonNullable()).roundDouble();
    }
    // notifyOtherControllers(context: context);
    // switch (field) {
    //   case "unitPrice":

    //     price = unitPrice.toNonNullable() * quantity.toNonNullable();
    //     break;
    //   case "price":
    //     unitPrice = unitPrice.toNonNullable() * quantity.toNonNullable();
    //     break;
    //   case "quantity":
    //     price = unitPrice.toNonNullable() * quantity.toNonNullable();
    //     break;
    // }
  }

  bool isDebitsInvoice() {
    return this is OrderDetails || this is PurchasesRefundDetails;
  }

  bool isCreditInvoice() {
    return this is PurchasesDetails || this is OrderRefundDetails;
  }

  bool isRefundCreditInvoice() {
    return this is OrderRefundDetails;
  }

  bool isRefundDebitInvoice() {
    return this is PurchasesRefundDetails;
  }

  bool isPricelessInvoice() {
    bool result = this is CustomerRequestSizeDetails ||
        this is ProductInputDetails ||
        this is ProductOutputDetails ||
        this is ReservationInvoiceDetails ||
        this is TransfersDetails;

    debugPrint("isPricelessInvoice for $runtimeType result =>$result");
    return result;
  }

  @override
  getFieldValue(String field, {BuildContext? context}) {
    // TODO: implement getFieldValue
    if (kIsWeb && context != null) {
      if (field == "unitPrice") {
        return unitPrice.toCurrencyFormatFromSetting(context);
      }
      if (field == "price") {
        return price.toCurrencyFormatFromSetting(context);
      }
    }
    return super.getFieldValue(field, context: context);
  }

  @override
  pdf.Widget getPrintableDetailPageIfLabel(BuildContext context,
      PrintInvoice? pca, PrintableInvoiceInterface<PrintLocalSetting> parent) {
    return ProductLabelIfInvoiceDetailRoll80(
            context: context,
            invoiceMaster: parent as InvoiceMaster,
            invoiceMasterDetail: this,
            product: products!,
            format: roll80,
            setting: pca)
        .generate(
            qrObject: parent,
            description: pca?.changeProductNameTo,
            quantity: quantity);
  }

  @override
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
          BuildContext context, PrintInvoice? pca) =>
      {
        AppLocalizations.of(context)!.iD: getIDFormat(context),
        AppLocalizations.of(context)!.description:
            "${products?.getProductTypeNameString()}\n${products?.getSizeString(context)}",
        AppLocalizations.of(context)!.gsm:
            products?.gsms?.gsm.toString() ?? "0",
        AppLocalizations.of(context)!.quantity:
            quantity?.toCurrencyFormat() ?? "0",
        if (!isPricelessInvoice())
          if (((pca?.hideUnitPriceAndTotalPrice == false)))
            AppLocalizations.of(context)!.unit_price:
                unitPrice?.toStringAsFixed(2) ?? "0",
        if (!isPricelessInvoice())
          if (((pca?.hideUnitPriceAndTotalPrice == false)))
            AppLocalizations.of(context)!.discount:
                discount?.toStringAsFixed(2) ?? "0",
        if (!isPricelessInvoice())
          if (((pca?.hideUnitPriceAndTotalPrice == false)))
            AppLocalizations.of(context)!.total_price:
                price?.toCurrencyFormat() ?? "0",
      };
  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  FormFieldControllerType getInputType(String field) {
    return field == "products"
        ? FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API
        : field == "warehouse"
            ? FormFieldControllerType.DROP_DOWN_API
            : super.getInputType(field);
  }

  @override
  bool isFieldEnabled(String field) {
    // if (field == "products") return false;
    return super.isFieldEnabled(field);
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoices;

  double getMaxDiscountValue() {
    return price ?? 0;
  }

  double getMinQuantityValue() {
    return 1;
  }

  double getBackupQuantity() {
    if (isNew()) return 0;
    if (backupProductID != products?.iD) return 0;
    if (warehouse?.isEquals(backupWarehouse) ?? false) {
      return backupQuantity.toNonNullable();
    }
    return 0;
  }

  @override
  String? getTextInputPrefix(BuildContext context, String field) {
    // TODO: implement getTextInputPrefix
    return super.getTextInputPrefix(context, field);
  }

  @override
  String? getTextInputSuffix(BuildContext context, String field) {
    if (field == "quantity") {
      return products?.getProductTypeUnit(context);
    }
    return super.getTextInputSuffix(context, field);
  }

  double getMaxQuantityValue() {
    if (this is PurchasesDetails) {
      return double.maxFinite;
    }
    return (getBackupQuantity()) +
        (products?.getQuantity(warehouse: warehouse) ?? 0);
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.details;

  @override
  Widget? getWebListTileItemLeading(BuildContext context) {
    return products?.getCardLeading(context);
  }

  @override
  Widget? getWebListTileItemTitle(BuildContext context) {
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
            Text(getMainHeaderTextOnly(context)),
            Text(quantity.toCurrencyFormat(
                symbol: products?.getProductTypeUnit(context) ?? ""))
          ],
        ),
      ],
    );
  }

  @override
  Widget? getWebListTileItemSubtitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(
        //   getDateTextOnly() ?? "",
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        Text(unitPrice.toCurrencyFormatFromSetting(context)),
        Text(
          price.toCurrencyFormatFromSetting(context),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: kPrimaryColor),
        )
      ],
    );
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting) {
    Currency c = Currency.init(context);
    return DashboardContentItem(
        shouldAddToBalance: false,
        iD: iD,
        currency: c.name,
        currencyId: c.iD,
        quantity: quantity.toCurrencyFormat(),
        unit: unitPrice.toCurrencyFormat(),
        description: getMainHeaderTextOnly(context),
        credit: isPricelessInvoice()
            ? 0
            : isCreditInvoice()
                ? price
                : 0,
        debit: isPricelessInvoice()
            ? 0
            : isDebitsInvoice()
                ? price
                : 0);
  }
}
