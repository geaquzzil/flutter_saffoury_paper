import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/prints/cut_requests/printable_cut_request_product_label_pdf.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/prints/printable_product_label_widgets.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/printing_generator/pdf_receipt_api.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../products/products.dart';

class CutRequestRecieptPDF {
  material.BuildContext context;
  CutRequest cutRequest;
  ThemeData themeData;
  PrintCutRequest? setting;
  CutRequestRecieptPDF(this.context,
      {required this.cutRequest, required this.themeData, this.setting});

  Future<Document> generate() async {
    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: themeData);
    final pdfRec = PdfReceipt(
        context, CutRequestRecipt(cutRequest: cutRequest, setting: setting));
    await pdfRec.initHeader();
    pdf.addPage(pdfRec.getPage(PdfPageFormat.a4));
    CutRequestProductLabelPDF cutRequestProductLabelPDF =
        CutRequestProductLabelPDF(context,
            cutRequest: cutRequest, themeData: themeData, setting: setting);

    for (var element in (await cutRequestProductLabelPDF.generate())) {
      pdf.addPage(element);
    }

    return pdf;
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

class CutRequestRecipt extends PrintableReceiptInterface<PrintCutRequest> {
  PrintCutRequest? setting;
  CutRequest cutRequest;
  CutRequestRecipt({required this.cutRequest, this.setting}) : super();

  @override
  String getPrintableInvoiceTitle(
      material.BuildContext context, PrintCutRequest? pca) {
    return cutRequest.getMainHeaderLabelTextOnly(context).toUpperCase();
  }

  @override
  String getPrintablePrimaryColor(PrintCutRequest? pca) {
    return cutRequest.getPrintablePrimaryColor(setting);
  }

  @override
  String getPrintableQrCode() => cutRequest.getPrintableQrCode();
  @override
  String getPrintableSecondaryColor(PrintCutRequest? pca) =>
      cutRequest.getPrintableSecondaryColor(setting);
  @override
  String getPrintableQrCodeID() => cutRequest.getPrintableQrCodeID();

  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptHeaderTitleAndDescription(
          material.BuildContext context, PrintCutRequest? pca) {
    var converter = NumberToCharacterConverter('en');
    return {
      0: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.mr,
            description: cutRequest.customers?.name ?? ""),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.iD,
            description:
                "${cutRequest.getIDFormat(context)}\n${cutRequest.date.toString()}"),
      ],
      10: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.product,
            description:
                "${cutRequest.products?.getMainHeaderTextOnly(context)}\n ID" ??
                    "-"),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.quality,
            description: cutRequest.products?.qualities
                    ?.getMainHeaderTextOnly(context) ??
                "-"),
      ],
      1: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.requestedSizeLabel,
            description:
                "${cutRequest.products?.getMainHeaderTextOnly(context)}\n ID" ??
                    "-"),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.quantity,
            description:
                "${cutRequest.quantity?.toCurrencyFormat(symbol: 'kg')}\n${converter.convertDouble(cutRequest.quantity ?? 0)}" ??
                    "-"),
      ],
      2: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.status,
            hexColor: cutRequest
                .getCutStatusColor()
                .value
                .toRadixString(16)
                .substring(2, 8),
            description: cutRequest.cut_status
                    ?.getFieldLabelString(context, cutRequest.cut_status!)
                    .toUpperCase() ??
                ""),
      ],
      3: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.comments,
            description: cutRequest.comments ?? "")
      ],
    };
  }
}
