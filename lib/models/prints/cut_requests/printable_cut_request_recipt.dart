import 'package:flutter/material.dart' as material;
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
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
  PdfPageFormat? format;
  ThemeData themeData;
  PrintCutRequest? setting;
  CutRequestRecieptPDF(this.context,
      {required this.cutRequest,
      required this.themeData,
      this.setting,
      this.format});

  Future<Document> generate() async {
    final pdf = Document(
        title: "TEST", pageMode: PdfPageMode.fullscreen, theme: themeData);
    switch (setting?.printCutRequestType) {
      case PrintCutRequestType.ALL:
        await addRecipt(pdf);
        await addLabels(pdf);
        break;
      case PrintCutRequestType.ONLY_CUT_REQUEST:
        await addRecipt(pdf);
        break;
      case PrintCutRequestType.ONLY_PRODUCT_LABEL:
        await addLabels(pdf);
        break;
      default:
        await addRecipt(pdf);
        await addLabels(pdf);
        break;
    }

    return pdf;
  }

  Future<void> addRecipt(Document pdf) async {
    final pdfRec = PdfReceipt(
        context, CutRequestRecipt(cutRequest: cutRequest, setting: setting));
    await pdfRec.initHeader();
    pdf.addPage(pdfRec.getPage(format, pdfRec.header));
  }

  Future<void> addLabels(Document pdf) async {
    CutRequestProductLabelPDF cutRequestProductLabelPDF =
        CutRequestProductLabelPDF(context,
            cutRequest: cutRequest, themeData: themeData, setting: setting);

    for (var element in (await cutRequestProductLabelPDF.generate())) {
      pdf.addPage(element);
    }
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
      getPrintableRecieptFooterTitleAndDescription(
              material.BuildContext context, PrintCutRequest? pca) =>
          {};
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
                "${cutRequest.products?.getMainHeaderTextOnly(context)}\n ID"),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.quality,
            description: cutRequest.products?.qualities
                    ?.getMainHeaderTextOnly(context) ??
                "-"),
      ],
      1: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.requestedSizeLabel,
            description: cutRequest.getRequestSizes(context)),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.quantity,
            description:
                "${cutRequest.quantity?.toCurrencyFormat(symbol: 'kg')}\n${converter.convertDouble(cutRequest.quantity ?? 0)}"),
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
        if (cutRequest.cut_status == CutStatus.COMPLETED)
          RecieptHeaderTitleAndDescriptionInfo(
              title: AppLocalizations.of(context)!.totalWaste,
              hexColor:
                  material.Colors.red.value.toRadixString(16).substring(2, 8),
              description:
                  cutRequest.getTotalWaste().toCurrencyFormat(symbol: "kg")),
      ],
      3: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.comments,
            description: cutRequest.comments ?? "-")
      ],
    };
  }

  Widget getProductDetailsWidget(material.BuildContext context,
      ProductInputDetails pid, PrintCutRequest? setting, PdfReceipt generator) {
    return Column(children: [
      SizedBox(height: .2 * (PdfPageFormat.cm)),
      Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: PdfPageFormat.cm, vertical: 5),
          child: Row(
              mainAxisAlignment: generator.getMainAxis(),
              children: generator.checkListToReverse([
                buildQrCode(context, pid.products!,
                    printCommandAbstract: setting, size: 40),
                SizedBox(width: 1 * (PdfPageFormat.cm)),
                generator.getDirections(
                    child: Text(
                  pid.products?.getMainHeaderTextOnly(context) ?? "-",
                )),
                SizedBox(width: 1 * (PdfPageFormat.cm)),
                Text(pid.quantity.toCurrencyFormat(symbol: "kg")),
                SizedBox(width: 1 * (PdfPageFormat.cm)),
                generator.getDirections(
                    child: Text(pid.products?.status?.getFieldLabelString(
                            context, pid.products!.status!) ??
                        "-")),
              ]))),
      Divider(height: 1, color: PdfColors.grey200)
    ]);
  }

  @override
  Widget? getPrintableRecieptCustomWidget(material.BuildContext context,
      PrintCutRequest? pca, PdfReceipt generator) {
    if (cutRequest.cut_status == CutStatus.COMPLETED) {
      var d = cutRequest.cut_request_results?.map((e) => Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: generator.getCrossAxis(),
                children: generator.checkListToReverse([
                  SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
                  generator.getDirections(
                      child: Text(e.getMainHeaderLabelWithText(context),
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 1 * (PdfPageFormat.cm / 2)),
                  Expanded(child: Divider(height: 1, color: PdfColors.grey200))
                ])),
            if (e.products_inputs?.products_inputs_details != null)
              ...e.products_inputs!.products_inputs_details!
                  .map((e) =>
                      getProductDetailsWidget(context, e, pca, generator))
                  .toList()
          ]));

      return Column(
          children: [if (d != null) ...d.whereType<Column>().toList()]);
    }
    return null;
  }
}
