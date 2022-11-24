import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../products/products.dart';

class CutRequestProductLabelPDF {
  material.BuildContext context;
  CutRequest cutRequest;
  ThemeData themeData;
  PrintCutRequest? setting;
  CutRequestProductLabelPDF(this.context,
      {required this.cutRequest, required this.themeData, this.setting});

  Future<Document> generate() async {
    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: themeData);

    cutRequest.cut_request_results?.forEach((element) {
      material.debugPrint(
          "CutRequestProductLabelPDF cut_request_results=>$element");
      element.products_inputs?.products_inputs_details
          ?.forEach((productInputDetails) async {
        material.debugPrint("CutRequestProductLabelPDF productInputDetails");
        Widget page = ProductLabelPDF(context, productInputDetails.products!,
                setting: getPrintProductSetting())
            .generate();
        pdf.addPage(Page(
            pageFormat: PdfPageFormat.a4,
            margin: EdgeInsets.zero,
            build: (context) => page));
      });
    });

    return pdf;
  }

  String? getPrintProductName() {
    
    return null; 
  }

  PrintProduct getPrintProductSetting() {
    return PrintProduct()
      ..country = "SYRIA"
      ..description = getPrintProductName()
      ..manufacture = AppLocalizations.of(context)!.appTitle
      ..customerName = setting?.hideCustomerName == true
          ? ""
          : cutRequest.customers?.name ?? ""
      ..cutRequestID = cutRequest.getPrintableQrCodeID();
  }
}
