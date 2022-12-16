// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/pdf_custom_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

import '../../interfaces/printable/printable_master.dart';
import '../../models/servers/server_helpers.dart';
import '../pdf_custom_from_pdf_api.dart';
import '../pdf_receipt_api.dart';
import 'ext.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

class PdfPage<T extends PrintLocalSetting> extends StatefulWidget {
  PrintableMaster<T> invoiceObj;

  PdfPage({super.key, required this.invoiceObj});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState<T extends PrintLocalSetting> extends State<PdfPage> {
  bool getBodyWithoutApi() {
    bool canGetBody = (widget.invoiceObj as ViewAbstract)
            .isRequiredObjectsList()?[ServerActions.view] ==
        null;
    if (canGetBody) {
      debugPrint("BaseEditWidget getBodyWithoutApi skiped");
      return true;
    }
    bool res = (widget.invoiceObj as ViewAbstract).isNew() ||
        (widget.invoiceObj as ViewAbstract).isRequiredObjectsListChecker();
    debugPrint("BaseEditWidget getBodyWithoutApi result => $res");
    return res;
  }

  Widget getFutureBody(BuildContext context) {
    if (getBodyWithoutApi()) {
      return getBody(context);
    }
    return FutureBuilder(
      future: (widget.invoiceObj as ViewAbstract)
          .viewCallGetFirstFromList((widget.invoiceObj as ViewAbstract).iD),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            widget.invoiceObj = snapshot.data as PrintableMaster;
            context
                .read<ListMultiKeyProvider>()
                .edit(snapshot.data as ViewAbstract);

            return getBody(context);
          } else {
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = getFutureBody(context);
    return body;
  }

  Widget getBody(BuildContext context) {
    // Printing.layoutPdf

    return PdfPreview(
        pdfFileName: widget.invoiceObj.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: true,
        canChangeOrientation: true,
        // pdfPreviewPageDecoration:
        canDebug: false,
        pageFormats: {
          // AppLocalizations("en")!.a3ProductLabel:PdfPageFormat.a6,
          AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
          AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
          AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
        },
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.outline),
        shareActionExtraBody: "shareActionExtraBody",
        dynamicLayout: true,
        loadingWidget: CircularProgressIndicator(),
        // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
        // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
        useActions: true,

        // shouldRepaint: ,
        build: (format) async {
          return await getExcelFileUinit(context, widget.invoiceObj, format);
        });
  }
}

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
}
