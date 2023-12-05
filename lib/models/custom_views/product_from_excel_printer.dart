import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product_list.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:supercharged/supercharged.dart';

class ProductFromExcel extends Product {
  @override
  Future<List<InvoiceHeaderTitleAndDescriptionInfo>>?
      getPrintableSelfListAccountInfoInBottom(
          BuildContext context, List list, PrintProductList? pca) {
    return null;
  }

  @override
  Future<List<List<InvoiceHeaderTitleAndDescriptionInfo>>>?
      getPrintableSelfListHeaderInfo(
          BuildContext context, List list, PrintProductList? pca) async {
    return [
      getInvoicDesFirstRow(context, list.cast(), pca),
      getInvoiceDesSecRow(context, list.cast(), pca),
      getInvoiceDesTherdRow(context, list.cast(), pca)
    ];
  }

  @override
  Map<String, String> getPrintableSelfListTableHeaderAndContent(
      BuildContext context, dynamic item, PrintProductList? pca) {
    item = item as Product;
    return {
      AppLocalizations.of(context)!.description:
          item.getProductTypeNameString(),
      AppLocalizations.of(context)!.size: item.getSizeString(context),
      AppLocalizations.of(context)!.gsm: item.gsms?.gsm.toString() ?? "0",
      if (((pca?.hideQuantity == false)))
        AppLocalizations.of(context)!.quantity:
            item.getQuantity().toCurrencyFormat(),
      if (((pca?.hideUnitPriceAndTotalPrice == false)))
        AppLocalizations.of(context)!.unit_price:
            item.getUnitSellPrice().toCurrencyFormatFromSetting(context),
      AppLocalizations.of(context)!.comments: item.comments ?? "",
    };
  }

  @override
  Future<List<InvoiceTotalTitleAndDescriptionInfo>>? getPrintableSelfListTotal(
      BuildContext context, List list, PrintProductList? pca) async {
    // return null;
    List<Product> items = list.cast<Product>();
    double total = items.map((e) => (e).getQuantity()).reduce(
        (value, element) => value.toNonNullable() + element.toNonNullable());
    // double total = 231231;
    return [
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: total.toCurrencyFormat()),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.no_summary.toUpperCase(),
          description:
              items.getTotalQuantityGroupedSizeTypeFormattedText(context)),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.total.toUpperCase(),
          description: items.getTotalQuantityGroupedFormattedText(context)),
      // InvoiceTotalTitleAndDescriptionInfo(
      //     title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
      //     description: total.toCurrencyFormat(),
      //     hexColor: getPrintableSelfListPrimaryColor(pca)),
    ];
  }

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesTherdRow(
      BuildContext context, List<Product> list, PrintProductList? pca) {
    double? total;
    if (((pca?.hideQuantity == false))) {
      pca?.currentGroupList?.forEach((element) {
        total = (total ?? 0) + (double.tryParse(element[3]) ?? 0);
      });
    }

    return [
      if (pca?.currentGroupNameFromList != null)
        InvoiceHeaderTitleAndDescriptionInfo(
            title: pca?.groupedByField ?? "-",
            description: pca?.currentGroupNameFromList ?? "sad",
            hexColor: getPrintablePrimaryColor(
                PrintProduct()..primaryColor = pca?.primaryColor)
            // icon: Icons.tag
            ),
      if ((pca?.hideQuantity == false))
        InvoiceHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.total,
            description: total.toCurrencyFormat(),
            hexColor: getPrintablePrimaryColor(
                PrintProduct()..primaryColor = pca?.primaryColor)
            // icon: Icons.tag
            ),

      // if (!isPricelessInvoice())
      //   if ((pca?.hideCustomerBalance == false))
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //         title: AppLocalizations.of(context)!.balance,
      //         description: customers?.balance?.toCurrencyFormat() ?? "",
      //         hexColor: getPrintablePrimaryColor(pca)
      //         // icon: Icons.balance
      //         ),
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

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoicDesFirstRow(
      BuildContext context, List<Product> list, PrintProductList? pca) {
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.comments,
        description: products_types?.comments ?? "",
        // icon: Icons.account_circle_rounded
      ),
      if (pca?.groupedByField != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.grainOn,
          description: pca?.groupedByField ?? "",
          // icon: Icons.account_circle_rounded
        ),
      // if ((pca?.hideCustomerAddressInfo == false))
      //   if (customers?.address != null)
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //       title: AppLocalizations.of(context)!.addressInfo,
      //       description: customers?.name ?? "",
      //       // icon: Icons.map
      //     ),
      // if ((pca?.hideCustomerPhone == false))
      //   if (customers?.phone != null)
      //     InvoiceHeaderTitleAndDescriptionInfo(
      //       title: AppLocalizations.of(context)!.phone_number,
      //       description: customers?.phone ?? "",
      //       // icon: Icons.phone
      //     ),
    ];
  }
}
