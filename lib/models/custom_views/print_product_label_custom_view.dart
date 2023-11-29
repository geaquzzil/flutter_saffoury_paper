import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/custom_views/print_product_object.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pdf;

class PrintProductLabelCustomView
    extends ViewAbstractStandAloneCustomView<PrintProductLabelCustomView>
    implements PrintableInvoiceInterface<PrintProduct> {
  PrintProductLabelCustomView();

  ViewAbstract? viewAbstractPrintObject;
  String? customerName;

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.print;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.print;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.balance;

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
              BuildContext context, PrintProduct? pca) =>
          [];

  @override
  List<PrintableInvoiceInterfaceDetails<PrintLocalSetting>>
      getPrintableInvoiceDetailsList() {
    return [];
  }

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
          BuildContext context, PrintProduct? pca) =>
      [];
  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintProduct? pca) =>
      getMainHeaderLabelTextOnly(context);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
          BuildContext context, PrintProduct? pca) =>
      [];

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
          BuildContext context, PrintProduct? pca) =>
      [];

  @override
  String getPrintablePrimaryColor(PrintProduct? setting) =>
      Colors.blueGrey.toHex();
  @override
  String getPrintableSecondaryColor(PrintProduct? setting) =>
      Colors.blueGrey.shade500.toHex();

  @override
  String getPrintableQrCode() => "TODO";

  @override
  String getPrintableQrCodeID() => "TODO";

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    return BaseEditWidget(
      isTheFirst: true,
      viewAbstract: ProductPrintObject(
        ProductSize(),
        GSM(),
      ),
      onValidate: (v) {
        {
          if (v == null) return;
          ProductPrintObject ppo = v as ProductPrintObject;
          customerName = ppo.customer;
          ProductType productType = ProductType()..name = ppo.description;
          // viewAbstractPrintObject = Product();
          viewAbstractPrintObject = Product()
            ..comments = ppo.comments
            ..sizes = ppo.size
            ..gsms = ppo.gsm
            ..products_types = productType
            ..inStock = [Stocks()..quantity = ppo.quantity];
        }
      },
    );
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) {
    return null;
  }

  @override
  PrintProductLabelCustomView getSelfNewInstance() {
    return PrintProductLabelCustomView();
  }

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.print),
        onPressed: () async {
          if (viewAbstractPrintObject == null) return;
          await Printing.layoutPdf(
              onLayout: (pdf.PdfPageFormat format) async => getExcelFileUinit(
                  context,
                  viewAbstractPrintObject as PrintableMaster,
                  pdf.PdfPageFormat.a4,
                  hasCustomSetting: PrintProduct()
                    ..hideQrCode = true
                    ..customerName = customerName));
        });
  }
}
