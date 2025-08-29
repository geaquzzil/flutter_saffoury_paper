import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/custom_views/print_product_object.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_apstract_stand_alone_without_api.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:printing/printing.dart';

class PrintProductLabelCustomView
    extends ViewAbstractStandAloneCustomView<PrintProductLabelCustomView> {
  PrintProductLabelCustomView();

  ViewAbstract? viewAbstractPrintObject;
  String? customerName;
  String? cutRequestNumber;
  ProductPrintObject p = ProductPrintObject();

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.print;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.print;
  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    return BaseEditWidget(
      isTheFirst: true,
      viewAbstract: p,
      onValidate: (v) {
        {
          if (v == null) return;
          p = v as ProductPrintObject;
          ProductPrintObject ppo = v;
          customerName = ppo.customer;
          cutRequestNumber = ppo.cutRequestNumber;
          ProductType productType = ProductType()..name = ppo.description;
          GSM g = GSM()..gsm = ppo.gsm;
          productType.unit = ProductTypeUnit.KG;
          // viewAbstractPrintObject = Product();
          viewAbstractPrintObject = Product()
            ..comments = ppo.comments
            ..sizes = ppo.size
            ..gsms = g
            ..products_types = productType
            ..inventory = [Stocks()..quantity = ppo.quantity];
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
          if (viewAbstractPrintObject == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // behavior: SnackBarBehavior.floating,
              // margin: EdgeInsets.only(left: 100.0),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              content: Text(AppLocalizations.of(context)!.errValidation,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer)),
            ));
            return;
          }
          await Printing.layoutPdf(
              onLayout: (pdf.PdfPageFormat format) async => getExcelFileUinit(
                  context,
                  viewAbstractPrintObject as PrintableMaster,
                  pdf.PdfPageFormat.a4,
                  hasCustomSetting: PrintProduct()
                    ..hideQrCode = true
                    ..cutRequestID = cutRequestNumber
                    ..customerName = customerName));
        });
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() => true;

  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
