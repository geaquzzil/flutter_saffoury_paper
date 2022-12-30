// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_custom_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
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
import 'dart:math' as math;
// import 'package:webcontent_converter/webcontent_converter.dart';

class PdfPage<T extends PrintLocalSetting> extends StatefulWidget {
  PrintableMaster<T> invoiceObj;

  PdfPage({super.key, required this.invoiceObj});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState<T extends PrintLocalSetting> extends State<PdfPage> {
  late Future<Uint8List> loadedFile;
  late Uint8List loadedFileBytes;

  PdfPageFormat _selectedFormat = PdfPageFormat.a4;
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getPrintShareFloating(BuildContext context) {
    return FloatingActionButton.small(
        child: const Icon(Icons.share),
        onPressed: () async => await Printing.sharePdf(bytes: loadedFileBytes));
  }

  Widget getPrintFloating(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(Icons.print),
        onPressed: () async => await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => loadedFile!));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = getFutureBody(context);

    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton: BaseFloatingActionButtons(
            viewAbstract: widget.invoiceObj as ViewAbstract,
            serverActions: ServerActions.print,
            addOnList: [
              getPrintShareFloating(context),
              const SizedBox(
                width: kDefaultPadding,
              ),
              getPrintFloating(context),
              const SizedBox(
                width: kDefaultPadding,
              ),
              getPrintPageO()
            ],
          ),

          // provider.getIsLoaded
          //     ? null
          //     : BaseFloatingActionButtons(
          //         viewAbstract: widget.viewAbstract,
          //         serverActions: widget.getServerAction(),
          //         addOnList: widget.getFloatingActionWidgetAddOns(context),
          //       ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    (widget.invoiceObj as ViewAbstract).getBaseTitle(context,
                        serverAction: ServerActions.print,
                        descriptionIsId: true),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Center(child: body),
              )
            ],
          )),
    );
  }

  FloatingActionButtonExtended getPrintPageO() {
    return FloatingActionButtonExtended(
        colapsed: Icons.settings,
        onExpandIcon: Icons.settings,
        onPress: () => {},
        expandedWidget: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedFormat = _selectedFormat.portrait;
                });
              },
              icon: Transform.rotate(
                angle: -math.pi / 2,
                child: Icon(
                  Icons.note_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedFormat = _selectedFormat.landscape;
                });
              },
              icon: Icon(
                Icons.note_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(
              width: 200,
              child: DropdownStringListControllerListener(
                tag: "printOptions",
                onSelected: (object) {
                  if (object != null) {
                    PdfPageFormat chosedPageFormat;
                    if (object.label ==
                        AppLocalizations.of(context)!.a3ProductLabel) {
                      chosedPageFormat = PdfPageFormat.a3;
                    } else if (object.label ==
                        AppLocalizations.of(context)!.a4ProductLabel) {
                      chosedPageFormat = PdfPageFormat.a4;
                    } else {
                      chosedPageFormat = PdfPageFormat.a5;
                    }
                    if (chosedPageFormat == _selectedFormat) return;
                    setState(() {
                      _selectedFormat = chosedPageFormat;
                    });
                  }
                },
                hint: "Select size",
                list: [
                  DropdownStringListItem(
                      null, AppLocalizations.of(context)!.a3ProductLabel),
                  DropdownStringListItem(
                      null, AppLocalizations.of(context)!.a4ProductLabel),
                  DropdownStringListItem(
                      null, AppLocalizations.of(context)!.a5ProductLabel),
                ],
              ),
            )
          ],
        ));
  }

  Widget getBody(BuildContext context) {
    // Printing.layoutPdf
    return PdfPreview(
        pdfFileName: widget.invoiceObj.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        initialPageFormat: _selectedFormat,
        canDebug: false,
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        dynamicLayout: true,
        loadingWidget: const CircularProgressIndicator(),
        useActions: false,

        // shouldRepaint: ,
        build: (format) async {
          loadedFile =
              getExcelFileUinit(context, widget.invoiceObj, _selectedFormat);
          loadedFileBytes = await loadedFile;
          return loadedFileBytes;
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
