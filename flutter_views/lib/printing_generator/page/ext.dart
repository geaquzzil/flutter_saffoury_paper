// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_from_pdf_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_dashboard_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_receipt_api.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> getDocumentFile<T extends PrintLocalSetting>(
    BuildContext context,
    PrintableMaster<T> invoiceObj,
    pdf.PdfPageFormat format,
    {T? hasCustomSetting}) async {
  T? pls = hasCustomSetting ?? await getSetting(context, invoiceObj);
  if (invoiceObj is PrintableInvoiceInterface) {
    final pdf = PdfInvoiceApi<PrintableInvoiceInterface, T>(
        context, invoiceObj as PrintableInvoiceInterface,
        printCommand: pls);
    return pdf.getDocumentP(format);
  } else if (invoiceObj is PrintableCustomInterface) {
    final pdf = PdfCustom<PrintableCustomInterface, T>(
        context, invoiceObj as PrintableCustomInterface,
        printCommand: pls);
    return pdf.getDocumentP(format);
  } else if (invoiceObj is PrintableCustomFromPDFInterface) {
    final pdf = PdfCustomFromPDF<PrintableCustomFromPDFInterface, T>(
        context, invoiceObj as PrintableCustomFromPDFInterface,
        printCommand: pls);
    return pdf.getDocumentP(format);
  } else if (invoiceObj is PrintableDashboardInterface) {
    final pdf = PdfDashnoardApi<PrintableDashboardInterface, T>(
        context, invoiceObj as PrintableDashboardInterface,
        printCommand: pls);
    return pdf.getDocumentP(format);
  } else {
    final pdf = PdfReceipt<PrintableReceiptInterface, T>(
        context, invoiceObj as PrintableReceiptInterface,
        printCommand: pls);
    return pdf.getDocumentP(format);
  }
}

Future<Uint8List> getExcelFileUinit<T extends PrintLocalSetting>(
    BuildContext context,
    PrintableMaster<T> invoiceObj,
    pdf.PdfPageFormat format,
    {T? hasCustomSetting}) async {
  {
    T? pls = hasCustomSetting ?? await getSetting(context, invoiceObj);
    // if (invoiceObj is ModifiablePrintableInterface) {
    //   pls = await Configurations.get<T>(
    //       (invoiceObj as ModifiablePrintableInterface)
    //           .getModifibleSettingObject(context),
    //       customKey: "_printsetting${invoiceObj.runtimeType}");
    //   if (pls != null) {
    //     pls = pls.onSavedModiablePrintableLoaded(
    //         context, invoiceObj as ViewAbstract);
    //   }
    // }
    if (invoiceObj is PrintableInvoiceInterface) {
      final pdf = PdfInvoiceApi<PrintableInvoiceInterface, T>(
          context, invoiceObj as PrintableInvoiceInterface,
          printCommand: pls);
      return pdf.generate(format);
    } else if (invoiceObj is PrintableCustomInterface) {
      final pdf = PdfCustom<PrintableCustomInterface, T>(
          context, invoiceObj as PrintableCustomInterface,
          printCommand: pls);
      return pdf.generate(format);
    } else if (invoiceObj is PrintableCustomFromPDFInterface) {
      final pdf = PdfCustomFromPDF<PrintableCustomFromPDFInterface, T>(
          context, invoiceObj as PrintableCustomFromPDFInterface,
          printCommand: pls);
      return pdf.generate(format);
    } else if (invoiceObj is PrintableDashboardInterface) {
      final pdf = PdfDashnoardApi<PrintableDashboardInterface, T>(
          context, invoiceObj as PrintableDashboardInterface,
          printCommand: pls);
      return pdf.generate(format);
    } else {
      final pdf = PdfReceipt<PrintableReceiptInterface, T>(
          context, invoiceObj as PrintableReceiptInterface,
          printCommand: pls);
      return pdf.generate(format);
    }
  }
}

Future<T?> getSettingLoadDefaultIfNull<T extends PrintLocalSetting>(
    BuildContext context, PrintableMaster firstObj) async {
  T? pls;
  if (firstObj is ModifiablePrintableInterface) {
    pls = await Configurations.get<T>(
        (firstObj as ModifiablePrintableInterface)
            .getModifibleSettingObject(context),
        customKey: "_printsetting${firstObj.runtimeType}");
    if (pls != null) {
      pls =
          pls.onSavedModiablePrintableLoaded(context, firstObj as ViewAbstract);
    }
  }
  if (pls == null) {
    if (firstObj is ModifiablePrintableInterface) {
      pls = (firstObj as ModifiablePrintableInterface)
          .getModifibleSettingObject(context);
      if (pls != null) {
        pls = pls.onSavedModiablePrintableLoaded(
            context, firstObj as ViewAbstract);
      }
    }
  }
  pls?.primaryColor = firstObj.getPrintablePrimaryColor(pls);
  pls?.secondaryColor = firstObj.getPrintableSecondaryColor(pls);
  return pls;
}

Future<T?> getSetting<T extends PrintLocalSetting>(
    BuildContext context, PrintableMaster firstObj) async {
  T? pls;
  if (firstObj is ModifiablePrintableInterface) {
    pls = await Configurations.get<T>(
        (firstObj as ModifiablePrintableInterface)
            .getModifibleSettingObject(context),
        customKey: "_printsetting${firstObj.runtimeType}");
    if (pls != null) {
      pls =
          pls.onSavedModiablePrintableLoaded(context, firstObj as ViewAbstract);
    }
  }

  return pls;
}
