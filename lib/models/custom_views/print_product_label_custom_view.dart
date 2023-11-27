import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/custom_views/print_product_object.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/test_var.dart';

class PrintProductLabelCustomView
    extends ViewAbstractStandAloneCustomView<PrintProductLabelCustomView>
    implements PrintableInvoiceInterface<PrintProduct> {
  PrintProductLabelCustomView();

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
      onValidate: (v) => {},
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
}
