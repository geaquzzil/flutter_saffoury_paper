import 'package:flutter/material.dart' as material;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_saffoury_paper/models/prints/print_invoice.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../products/products.dart';

const labelMainTextSize = 8.0;

class ProductLabelIfInvoiceDetailRoll80 extends LabelRoll80<PrintInvoice> {
  InvoiceMaster invoiceMaster;
  InvoiceMasterDetails invoiceMasterDetail;
  ProductLabelIfInvoiceDetailRoll80(
      {required this.invoiceMaster,
      required this.invoiceMasterDetail,
      required super.context,
      required super.product,
      super.format,
      super.setting});

  @override
  List<Widget> getHeaderDetails() {
    return [
      labelText(invoiceMaster.getPrintableQrCodeID()),
      // labelText(invoiceMaster.getCustomer),
      labelText("CUSTOMERR ADRESS: DAMASCUS,Syria"),
      labelText("TOTAL QUANTITY: 3,423 KG / 12 items")
    ];
  }

  @override
  Widget? getHeaderOnWidget() => printableGetBorderContainer(
      Row(children: [
        Expanded(
          child: Text("TOTAL : 12,532(kg)/ 12 Items",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: printableFindTextSize(format: format),
                  fontWeight: FontWeight.bold)),
        ),
      ]),
      padding: 10);

  @override
  List<List<Widget>> getWidget() {
    return [
      [
        Expanded(
            child: printableGetLabelAndText(
          context,
          AppLocalizations.of(context)!.iD,
          invoiceMasterDetail.getIDFormat(context),
          format: format,
        )),
        Expanded(
            child: printableGetLabelAndText(
          context,
          AppLocalizations.of(context)!.product,
          invoiceMasterDetail.getIDFormat(context),
          format: format,
        ))
      ]
    ];
  }
}

class ProductLabelIfCutRequestRoll80 extends LabelRoll80<PrintCutRequest> {
  CutRequest cutRequest;

  ProductLabelIfCutRequestRoll80(
      {required this.cutRequest,
      required super.context,
      required super.product,
      super.format,
      super.setting});
  @override
  Widget? getHeaderOnWidget() => null;
  @override
  List<Widget> getHeaderDetails() {
    return [
      labelText("ORDER ID: 213"),
      labelText("CUSTOMEER: Samer B"),
      labelText("CUSTOMERR ADRESS: DAMASCUS,Syria"),
      labelText("TOTAL QUANTITY: 3,423 KG / 12 items")
    ];
  }

  @override
  List<List<Widget>> getWidget() {
    return [
      // [(printableGetLabelAndText(context, "ID/ITEMS"))],
      // [
      //   Expanded(
      //       flex: 2,
      //       child: printableGetLabelAndText(
      //           context,
      //           format: format,
      //           AppLocalizations.of(context)!.customer,
      //           setting?.customerName ?? "")),
      //   Expanded(
      //       child: printableGetLabelAndText(
      //           context,
      //           format: format,
      //           AppLocalizations.of(context)!.cutRequest,
      //           setting?.cutRequestID ?? product.getCutRequestID())),
      // ]
    ];
  }
}

class ProductLabelIfLabelRoll80 extends LabelRoll80<PrintProduct> {
  ProductLabelIfLabelRoll80(
      {required super.product,
      required super.context,
      super.format,
      super.setting});

  @override
  List<Widget> getHeaderDetails() {
    return [
      labelText("CompanyName"),
      labelText("TEL: 011-6334232 MOB:098-994-4380")
    ];
  }

  @override
  List<List<Widget>> getWidget() {
    Widget? barcode = buildBarCodeIfFounded();
    return [
      if (barcode != null)
        [printableWrapBorderContainerWithExpanded(barcode, padding: 10)],
      [
        Expanded(
            flex: 2,
            child: printableGetLabelAndText(
                context,
                format: format,
                AppLocalizations.of(context)!.customer,
                setting?.customerName ?? "")),
        Expanded(
            child: printableGetLabelAndText(
                context,
                format: format,
                AppLocalizations.of(context)!.cutRequest,
                setting?.cutRequestID ?? product.getCutRequestID())),
      ]
    ];
  }

  Widget? buildBarCodeIfFounded() {
    if (product.barcode == null) return null;
    return printableBuildBarcode(context, product.barcode!,
        size: 30, format: format);
  }

  @override
  Widget? getHeaderOnWidget() => null;
}

abstract class LabelUtils {
  PdfPageFormat? format;
  late bool isLabel;
  LabelUtils({this.format}) {
    isLabel = printableIsLabel(format: format);
  }

  Widget getRichSmall(String text, String small) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: printableFindTextSize(format: format)),
        children: <TextSpan>[
          TextSpan(
              text: " $small",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: printableFindLabelSize(format: format))),
        ],
      ),
    );
  }
}

abstract class LabelRoll80<T extends PrintLocalSetting> extends LabelUtils {
  material.BuildContext context;
  T? setting;

  Product product;
  List<Widget> getHeaderDetails();

  List<List<Widget>> getWidget();

  Widget? getHeaderOnWidget();

  LabelRoll80(
      {required this.context,
      required this.product,
      this.setting,
      super.format});

  Widget buildSheetsAndReams({double? quantity}) {
    bool hasReams = product.isReams();

    return Row(children: [
      printableWrapBorderContainerWithExpanded(printableGetLabelAndText(
          context,
          format: format,
          AppLocalizations.of(context)!.sheetsInNotPrac,
          product.getSheets(customQuantity: quantity).toCurrencyFormat())),
      if (hasReams)
        printableWrapBorderContainerWithExpanded(printableGetLabelAndText(
            context,
            format: format,
            AppLocalizations.of(context)!.sheetsPerReam,
            product.sheets?.toCurrencyFormatChangeToDashIfZero() ?? "-")),
      if (hasReams)
        printableWrapBorderContainerWithExpanded(printableGetLabelAndText(
            context,
            format: format,
            AppLocalizations.of(context)!.reams,
            product.getReams().toCurrencyFormatChangeToDashIfZero())),
    ]);
  }

  Widget buildQrCodeIfLabel({
    required PrintableMaster qrObject,
    String? description,
    double? quantity,
  }) {
    return printableGetBorderContainer(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Column(children: [
                _getProductDesciptionAndQuantity(
                  description: description,
                  quantity: quantity,
                ),
                _getProductSizeAndGsmAndGrain()
              ])),
          Expanded(
              flex: 1,
              child: printableBuildQrCode(context, qrObject,
                  withPaddingTop: false,
                  size: 50,
                  printCommandAbstract: setting,
                  format: format))
        ]));
  }

  Widget _getProductSizeAndGsmAndGrain() {
    // bool isRoll = product.isRoll();
    Widget? size =
        product.sizes?.getSizeTextRichWidget(context, format: format);
    return Row(children: [
      Expanded(
          flex: isLabel ? 4 : 4,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.size,
              product.getSizeString(context),
              isValueWidget: size)),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.gsm,
              product.getGSMString(context))),
      // if (!isRoll)
      //   Expanded(
      //       child: printableGetLabelAndText(
      //           context,
      //           format: format,
      //           AppLocalizations.of(context)!.grainOn,
      //           product.getGrainOn()))
    ]);
  }

  ///setting?.description ?? product.getProductTypeNameString()
  /// product.getQuantity().toCurrencyFormat(symbol: "")
  Widget _getProductDesciptionAndQuantity(
      {String? description, double? quantity}) {
    return Row(children: [
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.description,
              description ?? product.getProductTypeNameString())),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.quantity,
              "",
              isValueWidget: getRichSmall(
                  quantity?.toCurrencyFormat() ??
                      product.getQuantity().toCurrencyFormat(),
                  product.getProductTypeUnit(context))))
    ]);
  }

  Row buildHeaderLabel() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          printableWrapBorderContainerWithExpanded(
              Icon(
                IconData(material.Icons.local_parking_sharp.codePoint),
              ),
              padding: 10),
          printableWrapBorderContainerWithExpanded(
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: getHeaderDetails()),
              flex: 2,
              padding: 10)
        ]);
  }

  Widget labelText(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: labelMainTextSize, fontWeight: FontWeight.bold));
  }

  Widget generate({
    required PrintableMaster qrObject,
    String? description,
    double? quantity,
  }) {
    return Column(children: [
      buildHeaderLabel(),
      if (getHeaderOnWidget() != null) getHeaderOnWidget()!,
      buildQrCodeIfLabel(
        qrObject: qrObject,
        description: description,
        quantity: quantity,
      ),
      buildSheetsAndReams(quantity: quantity),
      ...getWidget().map(
        (e) => printableGetBorderContainer(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: e)),
      ),
      SizedBox(height: .3 * (PdfPageFormat.cm)),
      Align(
          alignment: Alignment.topLeft,
          child: Text("SaffouryPaper 2025-2026 ® All Rights Reserved",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontSize: labelMainTextSize)))
    ]);
  }
}

class ProductLabelPDF extends LabelUtils {
  material.BuildContext context;
  Product product;
  PrintProduct? setting;

  ProductLabelPDF(this.context, this.product, {this.setting, super.format});
  Widget generate() {
    //TODO Widget? barcode = buildBarCodeIfFounded();TODO barcode on A4 label

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        // decoration: BoxDecoration(
        //     border: Border.all(color: PdfColors.black, width: 2),
        //     borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(children: [
          // Watermark(child: Text("SDA")),
          build1th(),
          build2th(),
          build3thWithQr(),
          build5th(),
          build6th(),
          build7th(),
          SizedBox(height: .3 * (PdfPageFormat.cm)),
          Align(
              alignment: Alignment.topLeft,
              child: Text("SaffouryPaper 2023-2024 ® All Rights Reserved",
                  style: TextStyle(
                      color: PdfColors.grey, fontWeight: FontWeight.normal)))
        ]));
  }

  Widget? buildBarCodeIfFounded() {
    if (product.barcode == null) return null;
    return printableBuildBarcode(context, product.barcode!,
        size: 30, format: format);
  }

  Widget build1th() {
    return Row(children: [
      Expanded(
          flex: 4,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.description,
              setting?.description ?? product.getProductTypeNameString())),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.grade,
              product.getGradeString())),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.quality,
              product.getQualityString()))
    ]);
  }

  Widget build2th() {
    Widget? size =
        product.sizes?.getSizeTextRichWidget(context, format: format);
    return Row(children: [
      Expanded(
          flex: 4,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.size,
              product.getSizeString(context),
              isValueWidget: size)),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.gsm,
              product.getGSMString(context))),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.grainOn,
              product.getGrainOn()))
    ]);
  }

  Widget buildQrCodeIfLabel() {
    return printableGetBorderContainer(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Column(children: [build1th(), build2th()])),
          Expanded(
              flex: 1,
              child: printableBuildQrCode(context, product,
                  withPaddingTop: false,
                  size: 50,
                  printCommandAbstract: setting,
                  format: format))
        ]));
  }

  Widget build3thWithQr() {
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2, child: Column(children: [build3th(), build4th()])),
              Expanded(
                  flex: 1,
                  child: printableBuildQrCode(context, product,
                      withPaddingTop: false,
                      size: 90,
                      printCommandAbstract: setting,
                      format: format))
            ]));
  }

  Widget build3th() {
    return Row(children: [
      Expanded(
          flex: 3,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.quantity,
              "",
              isValueWidget: getRichSmall(
                  product.getQuantity().toCurrencyFormat(symbol: ""),
                  " ${product.getProductTypeUnit(context)}"))),
      Expanded(
          flex: 2,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.weightPerSheet,
              "",
              isValueWidget: getRichSmall(
                  product.getSheetWeight().toCurrencyFormat(symbol: ""),
                  " ${AppLocalizations.of(context)!.gramSymbol}"))),
    ]);
  }

  Widget build4th() {
    return Row(children: [
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.sheetsInNotPrac,
              product.getSheets().toCurrencyFormat())),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.sheetsPerReam,
              product.sheets?.toCurrencyFormatChangeToDashIfZero() ?? "-")),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.reams,
              product.getReams().toCurrencyFormatChangeToDashIfZero())),
    ]);
  }

  Widget build5th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.customer,
              customFontSize: 20,
              setting?.customerName ?? "")),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.cutRequest,
              //TODO barcode
              customFontSize: 20,
              setting?.cutRequestID ?? product.getCutRequestID())),
    ]);
  }

  Widget build6th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.country,
              setting?.country ?? product.getCountryNameString())),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              AppLocalizations.of(context)!.manufacture,
              customFontSize: 12,
              setting?.manufacture ?? product.getManufactureNameString())),
    ]);
  }

  Widget build7th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: printableGetLabelAndText(
              context,
              format: format,
              "",
              "MADE IN SYRIA\nصنع في سورية",
              customFontSize: 24)),
      Expanded(
          child: printableGetLabelAndText(
              context,
              format: format,
              "",
              product.comments ?? "",
              customFontSize: 20)),
    ]);
  }
}
