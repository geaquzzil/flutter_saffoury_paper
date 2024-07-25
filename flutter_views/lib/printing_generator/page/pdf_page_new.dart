import 'dart:typed_data';

import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/printing_generator/page/base_pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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
  late PrintSettingLargeScreenProvider printSettingListener;

  Widget getPrintShareFloating(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        child: const Icon(Icons.share),
        onPressed: () async => await Printing.sharePdf(bytes: loadedFileBytes));
  }

  Widget getPrintFloating(BuildContext context) {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.print),
        onPressed: () async => await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => loadedFile));
  }

  void notifyToggleFloatingButton(BuildContext context, {bool? isExpaned}) {
    if (isExpaned != null) {
      printSettingListener.setFloatActionIsExpanded = isExpaned;
    }
    printSettingListener.toggleFloatingActionIsExpanded();
  }

  void notifyNewSelectedFormat(
      BuildContext context, PdfPageFormat selectedFormat) {
    printSettingListener.setSelectedFormat = selectedFormat;
  }

  double getSizeOfController() {
    if (SizeConfig.isFoldableWithOpenDualScreen(context)) {
      Size size = MediaQuery.of(context).size;
      return ((size.width / 2) / 3) - kDefaultPadding;
    }
    return (MediaQuery.of(context).size.width / 3) - kDefaultPadding;
  }

  FloatingActionButtonExtended getPrintPageOptions() {
    return FloatingActionButtonExtended(
        colapsed: Icons.settings,
        onExpandIcon: Icons.settings,
        onPress: () {},
        onToggle: () {
          notifyToggleFloatingButton(context);
        },
        expandedWidget: Row(
          children: [
            IconButton(
              onPressed: () {
                notifyNewSelectedFormat(
                    context, printSettingListener.getSelectedFormat.portrait);
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
                notifyNewSelectedFormat(
                    context, printSettingListener.getSelectedFormat.landscape);
              },
              icon: Icon(
                Icons.note_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(
              width: getSizeOfController(),
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
                    if (chosedPageFormat ==
                        printSettingListener.getSelectedFormat) return;
                    notifyNewSelectedFormat(context, chosedPageFormat);
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

  @override
  void initState() {
    printSettingListener =
        Provider.of<PrintSettingLargeScreenProvider>(context, listen: false);
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
  getDesktopFirstPane({TabControllerHelper? tab}) => const Center(
        child: Text("FirstPaneDesktop"),
      );

  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getPdfPreviewWidget();

  @override
  getFirstPane({TabControllerHelper? tab}) {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE) {
      return getPdfPreviewWidget();
    }
    return const Center(
      child: Text("getFirstPane"),
    );
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getPdfPreviewWidget();
  }

  Widget getFloatingActionButtonConsomer(BuildContext context,
      {required Widget Function(BuildContext, bool) builder}) {
    return Selector<PrintSettingLargeScreenProvider, bool>(
      builder: (_, isExpanded, __) {
        debugPrint(
            "BasePdfPageConsumer Selector =>  getFloatingActionButtonConsomer");
        return builder(_, isExpanded);
      },
      selector: (ctx, provider) => provider.getFloatActionIsExpanded,
    );
  }

  PdfPreview getPdfPreviewWidget() {
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
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE) {
      return getFloatingActionButtonConsomer(context, builder: (_, isExpanded) {
        return BaseFloatingActionButtons(
          viewAbstract: getExtras() as ViewAbstract,
          serverActions: ServerActions.print,
          addOnList: [
            if (!isExpanded) getPrintShareFloating(context),
            if (!isExpanded)
              const SizedBox(
                width: kDefaultPadding,
              ),
            if (!isExpanded) getPrintFloating(context),
            if (!isExpanded)
              const SizedBox(
                width: kDefaultPadding,
              ),
            getPrintPageOptions()
          ],
        );
      });
    }
    return null;
  }

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
