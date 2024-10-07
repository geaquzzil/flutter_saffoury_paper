import 'package:flutter/material.dart' as material;
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../products/products.dart';



class ProductLabelPDF {
  material.BuildContext context;
  Product product;
  PrintProduct? setting;
  PdfPageFormat? format;
  ProductLabelPDF(this.context, this.product, {this.setting, this.format});
  late bool isLabel;

  Widget labelText(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 8,
            // color: PdfColors.grey,
            fontWeight: FontWeight.bold));
  }

  Widget generate() {
    isLabel = format == roll80;
    Widget? barcode = buildBarCodeIfFounded();

    if (isLabel) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(children: [
            // Watermark(child: Text("SDA")),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      // flex: 3,
                      child: borderContainer(Center(
                    child: Expanded(
                        child: Icon(
                      IconData(material.Icons.check.codePoint),
                    )),
                  ))),
                  Expanded(
                      flex: 2,
                      child: borderContainer(
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxis,

                              children: [
                                labelText("CompanyName"),
                                labelText("TEL: 011-6334232 MOB:098-994-4380")
                              ]),
                          padding: 10)),
                ]),
            buildLabel(),

            borderContainer(build4th()),
            borderContainer(build5th()),
            // borderContainer(build5th()),
            if (barcode != null)
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: borderContainer(barcode, padding: 10))
                  ]),

            SizedBox(height: .3 * (PdfPageFormat.cm)),
            Align(
                alignment: Alignment.topLeft,
                child: Text("SaffouryPaper 2025-2026 ® All Rights Reserved",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 8)))
          ]));
    }
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
    return buildBarcode(context, product.barcode!, size: 30);
  }

  Widget build1th() {
    if (isLabel == true) {
      return Row(children: [
        Expanded(
            child: buildLabelAndText(AppLocalizations.of(context)!.description,
                setting?.description ?? product.getProductTypeNameString())),
        Expanded(
            flex: 2,
            child: buildLabelAndText(AppLocalizations.of(context)!.quantity, "",
                isValueWidget: getRichSmall(
                    product.getQuantity().toCurrencyFormat(symbol: ""),
                    " ${product.getProductTypeUnit(context)}"))),
      ]);
    }
    return Row(children: [
      Expanded(
          flex: 4,
          child: buildLabelAndText(AppLocalizations.of(context)!.description,
              setting?.description ?? product.getProductTypeNameString())),
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.grade, product.getGradeString())),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.quality,
              product.getQualityString()))
    ]);
  }

  Widget build2th() {
    Widget? size =
        product.sizes?.getSizeTextRichWidget(context, isLabel: isLabel);
    return Row(children: [
      Expanded(
          flex: isLabel ? 2 : 4,
          child: buildLabelAndText(AppLocalizations.of(context)!.size,
              product.getSizeString(context),
              isValueWidget: size)),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.gsm,
              product.getGSMString(context))),
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.grainOn, product.getGrainOn()))
    ]);
  }

  Widget buildLabel() {
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2, child: Column(children: [build1th(), build2th()])),
              Expanded(
                  flex: 1,
                  child: buildQrCode(context, product,
                      withPaddingTop: false,
                      size: 50,
                      printCommandAbstract: setting))
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
                  child: buildQrCode(context, product,
                      withPaddingTop: false,
                      size: 90,
                      printCommandAbstract: setting))
            ]));
  }

  Widget build3th() {
    return Row(children: [
      Expanded(
          flex: 3,
          child: buildLabelAndText(AppLocalizations.of(context)!.quantity, "",
              isValueWidget: getRichSmall(
                  product.getQuantity().toCurrencyFormat(symbol: ""),
                  " ${product.getProductTypeUnit(context)}"))),
      Expanded(
          flex: 2,
          child: buildLabelAndText(
              AppLocalizations.of(context)!.weightPerSheet, "",
              isValueWidget: getRichSmall(
                  product.getSheetWeight().toCurrencyFormat(symbol: ""),
                  " ${AppLocalizations.of(context)!.gramSymbol}"))),
    ]);
  }

  Widget getRichSmall(String text, String small) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:
                isLabel ? printerLabelFontSizePrimary : printerFontSizePrimary),
        children: <TextSpan>[
          TextSpan(
              text: small,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8)),
          // TextSpan(text: ' world!'),
        ],
      ),
    );
  }

  Widget build4th() {
    return Row(children: [
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.sheetsInNotPrac,
              product.getSheets().toCurrencyFormat())),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.sheetsPerReam,
              product.sheets?.toCurrencyFormatChangeToDashIfZero() ?? "-")),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.reams,
              product.getReams().toCurrencyFormatChangeToDashIfZero())),
    ]);
  }

  Widget build5th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: buildLabelAndText(
              AppLocalizations.of(context)!.customer,
              fontSize: 20,
              setting?.customerName ?? "")),
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.cutRequest,
              fontSize: 20,
              setting?.cutRequestID ?? product.getCutRequestID())),
    ]);
  }

  Widget build6th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: buildLabelAndText(AppLocalizations.of(context)!.country,
              setting?.country ?? product.getCountryNameString())),
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.manufacture,
              fontSize: 12,
              setting?.manufacture ?? product.getManufactureNameString())),
    ]);
  }

  Widget build7th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: buildLabelAndText("", "MADE IN SYRIA\nصنع في سورية",
              fontSize: 24)),
      Expanded(
          child: buildLabelAndText("", product.comments ?? "", fontSize: 20)),
    ]);
  }

}
