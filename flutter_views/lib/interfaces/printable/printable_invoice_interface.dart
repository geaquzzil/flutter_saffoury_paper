import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/printing_generator/pdf_dashboard_api.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfW;

///بدنا راسسية وذيل مخصص
/// خود الليستات كلها رتبها
/// ترتيب حسب الديبت حسب الكريدت حسب البالانس حسب الوقت وحسب الايدي
///
abstract class PrintableDashboardInterface<T extends PrintLocalSetting>
    extends PrintableMaster<T> {
  ///for each int key is a column
  ///for each List is row list
  List<List<InvoiceHeaderTitleAndDescriptionInfo>>
      getPrintableDashboardHeaderInfo(BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableDashboardFooterTotal(
      BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo>
      getPrintableDashboardTotalDescripton(BuildContext context, T? pca);

  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableDashboardAccountInfoInBottom(BuildContext context, T? pca);

  pdfW.Widget? getPrintableDashboardCustomWidgetTop(
      BuildContext context, T? pca, PdfDashnoardApi generator);

  pdfW.Widget? getPrintableDashboardCustomWidgetBottom(
      BuildContext context, T? pca, PdfDashnoardApi generator);

  List<PrintableMaster> getPrintableRecieptMasterDashboardLists(
      BuildContext context, T? pca);

  List<String> getPrintableDashboardTableHeaders(
      BuildContext context, T? pca, PdfDashnoardApi generator);

  List<String> getPrintableDashboardRowContentConverter(BuildContext context,
      T? pca, PdfDashnoardApi generator, DashboardContentItem? dynamicList);

  DashboardContentItem? getPrintableDashboardFirstRowContentItem(
      BuildContext context, T? pca, PdfDashnoardApi generator);
}

abstract class PrintableInvoiceInterfaceDetails<T extends PrintLocalSetting> {
  Map<String, String> getPrintableInvoiceTableHeaderAndContent(
      BuildContext context, T? pca);
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
      BuildContext context, PrintLocalSetting? dashboardSetting);
}

abstract class PrintableInvoiceInterface<T extends PrintLocalSetting>
    extends PrintableMaster<T> {
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
      BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
      BuildContext context, T? pca);

  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
      BuildContext context, T? pca);

  List<PrintableInvoiceInterfaceDetails> getPrintableInvoiceDetailsList();

  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(BuildContext context, T? pca);
}

class InvoiceHeaderTitleAndDescriptionInfo {
  IconData? icon;
  String? hexColor;
  String title;
  String description;
  InvoiceHeaderTitleAndDescriptionInfo(
      {required this.title,
      required this.description,
      this.icon,
      this.hexColor});

  int? getCodeIcon() {
    return icon?.codePoint;
  }

  pdf.PdfColor getColor() {
    if (hexColor == null) return pdf.PdfColors.black;
    return pdf.PdfColor.fromHex(hexColor ?? "");
  }
}

class InvoiceTotalTitleAndDescriptionInfo {
  String? hexColor;
  String title;
  String? description;
  double? size;
  InvoiceTotalTitleAndDescriptionInfo(
      {required this.title, this.description, this.hexColor, this.size});

  pdf.PdfColor getColor() {
    if (hexColor == null) return pdf.PdfColors.black;
    return pdf.PdfColor.fromHex(hexColor ?? "");
  }
}
