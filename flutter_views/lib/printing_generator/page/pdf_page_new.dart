import 'dart:typed_data';

import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PdfPageNew<T extends PrintLocalSetting> extends StatefulWidget {
  int? iD;
  String? tableName;
  PrintableMaster<T>? invoiceObj;

  PdfPageNew({super.key, this.iD, this.invoiceObj, this.tableName});

  @override
  State<PdfPageNew> createState() => _PdfPageNewState();
}

class _PdfPageNewState extends BasePageWithApi<PdfPageNew> {
  late Future<Uint8List> loadedFile;
  late Uint8List loadedFileBytes;

  @override
  void initState() {
    setExtras(iD: widget.iD, tableName: tableName, ex: widget.invoiceObj);
    super.initState();
  }

  @override
  Widget? getBaseAppbar() => null;

  @override
  Widget? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) => getFirstPane(tab: tab);

  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getSecoundPane(tab: tab, secoundTab: secoundTab);

  @override
  getFirstPane({TabControllerHelper? tab}) {
    return Center(
      child: Text("TEST"),
    );
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return PdfPreview(
        pdfFileName: getExtras()!.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        maxPageWidth: 200,
        initialPageFormat: PdfPageFormat.a4, //todo setting
        canDebug: false,
        scrollViewDecoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surface),
        dynamicLayout: true,
        loadingWidget: const CircularProgressIndicator(),
        useActions: false,
        onError: (context, error) {
          return EmptyWidget(
              lottiUrl:
                  "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
              onSubtitleClicked: () {
                setState(() {});
              },
              title: AppLocalizations.of(context)!.cantConnect,
              subtitle: error.toString());
        },
        // shouldRepaint: ,
        build: (format) async {
          loadedFile =
              getExcelFileUinit(context, getExtras()!, PdfPageFormat.a4);
          loadedFileBytes = await loadedFile;
          return loadedFileBytes;
        });
  }

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  Widget? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) => !firstPane;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => true;

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    return (getExtras() as ViewAbstract)
            .viewCallGetFirstFromList((getExtras() as ViewAbstract).iD)
        as Future<PrintableMaster?>;
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }
}
