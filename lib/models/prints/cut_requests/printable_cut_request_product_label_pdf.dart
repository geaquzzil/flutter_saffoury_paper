import 'package:flutter/material.dart' as material;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../products/products.dart';

class CutRequestProductLabelPDF {
  material.BuildContext context;
  CutRequest cutRequest;
  ThemeData themeData;
  PageTheme pageTheme;
  PdfPageFormat? format;
  PrintCutRequest? setting;
  CutRequestProductLabelPDF(this.context,
      {required this.cutRequest,
      required this.pageTheme,
      this.format,
      required this.themeData,
      this.setting});
  Future<Widget> buildHeader() async => Image(await networkImage(
      'https://saffoury.com/SaffouryPaper2/print/headers/headerA4IMG.php?color=${cutRequest.getPrintablePrimaryColor(setting)}&darkColor=${cutRequest.getPrintableSecondaryColor(setting)}'));
  Future<List<Page>> generate() async {
    material.debugPrint("CutRequestProductLabelPDF start building");
    Widget header = await buildHeader();
    material.debugPrint("CutRequestProductLabelPDF image done building");
    List<Page> pages = [];

    cutRequest.cut_request_results?.forEach((element) {
      material.debugPrint(
          "CutRequestProductLabelPDF cut_request_results=>$element");
      element.products_inputs?.products_inputs_details
          ?.forEach((productInputDetails) async {
        material.debugPrint("CutRequestProductLabelPDF productInputDetails");
        Widget page = ProductLabelPDF(context, productInputDetails.products!,
                setting: getPrintProductSetting())
            .generate();
        pages.add(Page(
            pageTheme: pageTheme,
            build: (context) => Column(children: [
                  Stack(
                      alignment: Alignment.bottomRight,
                      fit: StackFit.loose,
                      // alignment: ,
                      children: [
                        header,
                        printableGetMainTitle(this.context, Product(),
                            format: format)
                      ]),
                  page
                ])));
      });
    });

    return pages;
  }

  String? getPrintProductName() {
    return null;
  }

  PrintProduct getPrintProductSetting() {
    return PrintProduct()
      ..country = "SYRIA TODO"
      ..description = getPrintProductName()
      ..manufacture = AppLocalizations.of(context)!.appTitle
      ..customerName = setting?.hideCustomerName == true
          ? ""
          : cutRequest.customers?.name ?? ""
      ..cutRequestID = cutRequest.getPrintableQrCodeID();
  }
}
