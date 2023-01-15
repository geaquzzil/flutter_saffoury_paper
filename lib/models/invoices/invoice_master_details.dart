import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/ext_utils.dart';

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
  InvoiceMasterDetails setProduct(Product products, {double? quantity}) {
    this.products = products;
    this.unitPrice = products.getUnitSellPrice();
    this.price = products.getTotalSellPrice();
    this.quantity = quantity ?? products.getCartableProductQuantity();
    discount = 0;
    return this;
  }

  Stocks getStockFromDetails() {
    return Stocks()
      ..quantity = quantity
      ..warehouse = warehouse;
  }

  @override
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
        "comments": TextInputType.text
      };
  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"quantity": true, "unitPrice": true, "discount": true, "price": true};

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      products?.getMainHeaderTextOnly(context) ?? "not found for products";

  @override
  Text getMainLabelText(BuildContext context) {
    return products?.getMainLabelText(context) ?? Text("ds");
  }

  @override
  Text? getMainSubtitleHeaderText(BuildContext context) {
    return Text(quantity.toCurrencyFormat(symbol: "KG"));
  }

  @override
  IconData getMainIconData() => Icons.list;

  @override
  String? getSortByFieldName() => "iD";

  @override
  SortByType getSortByType() => SortByType.DESC;

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
  void onTextChangeListener(BuildContext context, String field, String? value) {
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
          if (((pca?.hideUnitPriceAndTotalPrice == false) ?? false))
            AppLocalizations.of(context)!.unit_price:
                unitPrice?.toStringAsFixed(2) ?? "0",
        if (!isPricelessInvoice())
          if (((pca?.hideUnitPriceAndTotalPrice == false)))
            AppLocalizations.of(context)!.discount:
                discount?.toStringAsFixed(2) ?? "0",
        if (!isPricelessInvoice())
          if (((pca?.hideUnitPriceAndTotalPrice == false) ?? false))
            AppLocalizations.of(context)!.total_price:
                price?.toCurrencyFormat() ?? "0",
      };
  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoices;

  double getMaxDiscountValue() {
    return price ?? 0;
  }

  double getMinQuantityValue() {
    return 1;
  }

  double getMaxQuantityValue() {
    return products?.getQuantity() ?? 0;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.details;
}
