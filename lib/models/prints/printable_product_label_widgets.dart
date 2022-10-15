import 'package:flutter/material.dart' as material;
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../products/products.dart';

class ProductLabelPDF {
  material.BuildContext context;
  Product product;
  ProductLabelPDF(this.context, this.product);

  Widget generate() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        // decoration: BoxDecoration(
        //     border: Border.all(color: PdfColors.black, width: 2),
        //     borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(children: [
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

  Widget build1th() {
    return Row(children: [
      Expanded(
          flex: 4,
          child: buildLabelAndText(AppLocalizations.of(context)!.products_type,
              product.getProductTypeNameString())),
      Expanded(
          child: buildLabelAndText(
              AppLocalizations.of(context)!.grade, product.getGradeString())),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.quality,
              product.getQualityString()))
    ]);
  }

  Widget build2th() {
    return Row(children: [
      Expanded(
          flex: 4,
          child: buildLabelAndText(AppLocalizations.of(context)!.size,
              product.getSizeString(context))),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.gsm,
              product.getGSMString(context))),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.quality,
              product.getQualityString()))
    ]);
  }

  Widget build3thWithQr() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Column(children: [build3th(), build4th()])),
          Expanded(
              flex: 1,
              child: buildQrCode(context, product,
                  withPaddingTop: false, size: 90))
        ]);
  }

  Widget build3th() {
    return Row(children: [
      Expanded(
          flex: 3,
          child: buildLabelAndText(AppLocalizations.of(context)!.quantity, "",
              isValueWidget: getRichSmall(
                  product.getQuantityStringAndLabel(context), " kg"))),
      Expanded(
          flex: 2,
          child: buildLabelAndText(
              AppLocalizations.of(context)!.weightPerSheet, "",
              isValueWidget: getRichSmall(
                  product.getSheetWeight().toStringAsFixed(2), " g"))),
    ]);
  }

  Widget getRichSmall(String text, String small) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
          child: buildLabelAndText(AppLocalizations.of(context)!.quantity,
              product.getQuantityStringAndLabel(context))),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.weightPerSheet,
              product.getSheetWeight().toStringAsFixed(0))),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.weightPerSheet,
              product.getSheetWeight().toStringAsFixed(0))),
    ]);
  }

  Widget build5th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: buildLabelAndText(AppLocalizations.of(context)!.customer,
              product.getCustomerNameIfCutRequest())),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.cutRequest,
              product.getCutRequestID())),
    ]);
  }

  Widget build6th() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: buildLabelAndText(AppLocalizations.of(context)!.country,
              product.getCountryNameString())),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.manufacture,
              product.getManufactureNameString())),
    ]);
  }

  Widget build7th() {
    return Row(children: [
      Expanded(
          flex: 2, child: buildLabelAndText("", "MADE IN SYRIA\nصنع في سورية")),
      Expanded(
          child: buildLabelAndText(AppLocalizations.of(context)!.weightPerSheet,
              product.getSheetWeight().toStringAsFixed(0))),
    ]);
  }

  Widget buildLabelAndText(String label, String value,
      {double size = 80, Widget? isValueWidget}) {
    return Container(
        height: size,
        // padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: PdfColors.black, width: .5),
          // borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(children: [
          Align(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Text(label, style: TextStyle(fontSize: 10))),
              alignment: Alignment.topLeft),
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: isValueWidget ??
                      Text(value,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)))),
        ]));
  }
}
