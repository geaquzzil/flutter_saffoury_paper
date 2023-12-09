import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/helper_model/product.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

class PdfTestToBasePage extends StatefulWidget {
  const PdfTestToBasePage({super.key});

  @override
  State<PdfTestToBasePage> createState() => _PdfTestToBasePageState();
}

class _PdfTestToBasePageState extends BasePageState<PdfTestToBasePage> {
  late Future<Uint8List> loadedFile;
  late Uint8List loadedFileBytes;

  @override
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize) => null;

  @override
  Widget? getBaseFloatingActionButton(CurrentScreenSize currentScreenSize) =>
      null;

  @override
  getDesktopFirstPane(double width) {
    ViewAbstract v = context.read<DrawerMenuControllerProvider>().getObject;
    debugPrint("gettingDesktopFirstPane ");
    // return const Center(child: Text(" this is a desktop body second pane"));

    return Column(
      children: [
        DropdownStringListControllerListener(
          currentScreenSize: getCurrentScreenSize(),
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
              // if (chosedPageFormat == printSettingListener.getSelectedFormat)
              //   return;
              // notifyNewSelectedFormat(context, chosedPageFormat);
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
        BaseEditWidget(
          currentScreenSize: getCurrentScreenSize(),
          isTheFirst: true,
          viewAbstract: (v as ModifiablePrintableInterface)
              .getModifibleSettingObject(context) as ViewAbstract,
          onValidate: (viewAbstract) {
            debugPrint("BasePdfPageConsumer new viewAbstract $viewAbstract");

            if (viewAbstract != null) {
              // notifyNewViewAbstract(viewAbstract.getCopyInstance());
              // Configurations.save(
              //     "_printsetting${getMainObject().runtimeType}", viewAbstract);
            }
          },
        ),
      ],
    );
  }

  @override
  getDesktopSecondPane(double width) {
    ViewAbstract v = context.read<DrawerMenuControllerProvider>().getObject;
    double pane = getCustomPaneProportion();
    return Center(
      child: PdfPreview(
          pdfFileName: (v as PrintableMaster).getPrintableQrCodeID(),
          shareActionExtraEmails: const ["info@saffoury.com"],
          // maxPageWidth: 500,
          maxPageWidth: ((pane + .05) * width),
          previewPageMargin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          initialPageFormat: PdfPageFormat.a4,
          canDebug: false,
          scrollViewDecoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          // dynamicLayout: true,
          pages: [0],
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
            loadedFile = getExcelFileUinit(
                context, v as PrintableMaster, PdfPageFormat.a4);
            loadedFileBytes = await loadedFile;
            return loadedFileBytes;
          }),
    );
  }

  @override
  getFirstPane(double width) => getDesktopFirstPane(width);

  @override
  getSecoundPane(double width) => getDesktopSecondPane(width);

  @override
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize) => ListTile(
        title: Text("first pane tool bar",
            style: Theme.of(context).textTheme.headlineLarge),
        subtitle: Text("Subtitle Toolbar"),
      );

  @override
  Widget? getFirstPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize) => null;

  @override
  Widget? getSecondPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  bool isPanesIsSliver(bool firstPane) => false;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize) => true;
}
