import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/printing_generator/page/base_pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/printing_generator/pdf_list_api.dart';
import 'package:flutter_view_controller/printing_generator/pdf_self_list_api.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PdfPageNew<T extends PrintLocalSetting> extends BasePageApi {
  bool buildBaseHeader;
  List<PrintableMaster>? asList;
  PrintPageType? type;
  T? customSetting;

  PdfPageNew(
      {super.key,
      super.iD,
      super.extras,
      super.tableName,
      this.buildBaseHeader = false,
      this.asList,
      this.type,
      this.customSetting,
      super.buildSecondPane,
      super.isFirstToSecOrThirdPane,
      super.buildDrawer = false});

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
        onPressed: () async {
          await Printing.sharePdf(bytes: loadedFileBytes);
        });
  }

  Widget getPrintFloating(BuildContext context) {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.print),
        onPressed: () async {
          if (await getExtrasCast().directPrint(
                  format: context
                      .read<PrintSettingLargeScreenProvider>()
                      .getSelectedFormat,
                  context: context,
                  onLayout: (PdfPageFormat format) async => loadedFile) ==
              false) {
            await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => loadedFile);
          }
        });
  }

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }

  Widget getPrintAdvancedFloating() {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.settings),
        onPressed: () async {
          var v = await getSettingFuture();
          await showFullScreenDialogExt<ViewAbstract?>(
              barrierDismissible: true,
              anchorPoint: const Offset(1000, 1000),
              context: context,
              builder: (p0) {
                return BaseEditNewPage(
                  viewAbstract: v as ViewAbstract,
                  onFabClickedConfirm: (viewAbstract) {
                    if (viewAbstract != null) {
                      debugPrint(
                          "BasePdfPageConsumer newViewAbstract $viewAbstract");
                      // notifyNewViewAbstract(viewAbstract.getCopyInstance());
                      Configurations.saveViewAbstract(viewAbstract);
                      printSettingListener.setViewAbstract = viewAbstract;
                      context.pop();
                    }
                  },
                );
              }).then((value) {
            {
              if (value != null) {}
              debugPrint("getEditDialog result $value");
            }
          });
        });
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
    return getWidth * .4;
  }

  FloatingActionButtonExtended getPrintPageOptions() {
    return FloatingActionButtonExtended(
        colapsed: Icons.note_add,
        onExpandIcon: Icons.arrow_forward_ios_rounded,
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
                insetFirstIsSelect: false,
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
                    } else if (object.label ==
                        AppLocalizations.of(context)!.a5ProductLabel) {
                      chosedPageFormat = PdfPageFormat.a5;
                    } else {
                      //todo translate
                      if (supportsLabelPrinting()) {
                        chosedPageFormat = roll80;
                      } else {
                        chosedPageFormat = PdfPageFormat.a4;
                      }
                    }
                    if (chosedPageFormat ==
                        printSettingListener.getSelectedFormat) return;
                    notifyNewSelectedFormat(context, chosedPageFormat);
                  }
                },
                //todo translate
                hint: "Select size",
                list: [
                  if (supportsLabelPrinting())
                    DropdownStringListItem(
                        icon: null,
                        //todo translate
                        label: AppLocalizations.of(context)!.productLabel),
                  DropdownStringListItem(
                      icon: null,
                      label: AppLocalizations.of(context)!.a3ProductLabel),
                  DropdownStringListItem(
                      icon: null,
                      label: AppLocalizations.of(context)!.a4ProductLabel),
                  DropdownStringListItem(
                      icon: null,
                      label: AppLocalizations.of(context)!.a5ProductLabel),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    printSettingListener =
        Provider.of<PrintSettingLargeScreenProvider>(context, listen: false);
    super.initState();
  }

  @override
  List<Widget>? getAppbarActionsWhenThirdPane() {
    debugPrint("getAppbarActionsWhenThirdPane");
    return [const Icon(Icons.settings)];
  }

  @override
  List<Widget>? getAppbarActions(
      {bool? firstPane, TabControllerHelper? tab, TabControllerHelper? sec}) {
    return null;
  }

  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (widget.buildBaseHeader && firstPane == null) {
      return Text(
          "${AppLocalizations.of(context)!.print} ${getExtrasCast().getMainHeaderText(context)}");
    }
    return null;
  }

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE &&
        firstPane == true) {
      return getFloatingActionButtonConsomer(context, builder: (_, isExpanded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
            if (!isExpanded) getPrintAdvancedFloating(),
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
  List<Widget>? getPane(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab}) {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE && firstPane) {
      return [getPdfPreviewWidget()];
    }
    return [getPdfPreviewWidget()];
  }

  Future getSettingFuture() {
    dynamic extra = getExtras();
    return widget.type == PrintPageType.self_list
        ? getSettingLoadDefaultIfNullSelfList(context, extra)
        : getSettingLoadDefaultIfNull(context, extra);
  }

  Widget getSettingWidget() {
    Widget setting = const Center(
      child: Text("getFirstPane"),
    );

    return FutureBuilder(
      future: getSettingFuture(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          debugPrint(
              "getSettingLoadDefaultIfNull=>hasError ${snapshot.error.toString()}");
          return setting;
        }
        debugPrint("getSettingLoadDefaultIfNull=>data ${snapshot.data}");
        if (snapshot.hasData == false) {
          return setting;
        }
        return Scaffold(
          body: BaseEditWidget(
            isTheFirst: true,
            viewAbstract: snapshot.data as ViewAbstract,
            onValidate: (viewAbstract) {
              debugPrint("BasePdfPageConsumer new viewAbstract $viewAbstract");

              if (viewAbstract != null) {
                // notifyNewViewAbstract(viewAbstract.getCopyInstance());
                Configurations.saveViewAbstract(viewAbstract);
              }
            },
          ),
        );
      },
    );
  }

  Widget getFloatingActionButtonConsomer(BuildContext context,
      {required Widget Function(BuildContext, bool) builder}) {
    return Selector<PrintSettingLargeScreenProvider, bool>(
      builder: (v, isExpanded, __) {
        debugPrint(
            "BasePdfPageConsumer Selector =>  getFloatingActionButtonConsomer");
        return builder(v, isExpanded);
      },
      selector: (ctx, provider) => provider.getFloatActionIsExpanded,
    );
  }

  bool supportsLabelPrinting() {
    return (getExtras() as PrintableMaster).getPrintableSupportsLabelPrinting();
  }

  Widget getPdfPreview(PdfPageFormat fomat) {
    return PdfPreview(
        // pages: const [0, 1],///TODO
        pdfFileName: getExtras()!.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        maxPageWidth: getWidth,
        initialPageFormat: fomat,
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
          dynamic setting = await getSettingFuture();
          if (widget.type == PrintPageType.list) {
            loadedFileBytes = await PDFListApi<PrintLocalSetting>(
                    list: widget.asList!.cast(),
                    context: context,
                    setting: setting)
                .generate(format);
            return loadedFileBytes;
          } else if (widget.type == PrintPageType.self_list) {
            // PrintLocalSetting? setting = await getSetting();
            loadedFileBytes = await PdfSelfListApi<PrintLocalSetting>(
                    widget.asList!.cast(), context, getExtras(),
                    printCommand: setting)
                .generate(format);
            return loadedFileBytes;
          } else {
            loadedFile = getExcelFileUinit(context, getExtras()!, fomat,
                hasCustomSetting: setting as PrintLocalSetting);
            loadedFileBytes = await loadedFile;
            return loadedFileBytes;
          }
        });
  }

  //    else {
  //     if (widget.type == PrintPageType.list) {
  //       return PdfPreview(
  //           shareActionExtraEmails: const ["info@saffoury.com"],
  //           initialPageFormat: fomat,
  //           canChangePageFormat: true,
  //           canChangeOrientation: true,

  //           // pdfPreviewPageDecoration:
  //           canDebug: false,
  //           pageFormats: {
  //             AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
  //             AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
  //             AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
  //           },
  //           scrollViewDecoration:
  //               BoxDecoration(color: Theme.of(context).colorScheme.outline),
  //           shareActionExtraBody: "shareActionExtraBody",
  //           dynamicLayout: true,
  //           loadingWidget: const CircularProgressIndicator(),
  //           // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
  //           // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
  //           useActions: true,

  //           // shouldRepaint: ,
  //           build: (format) async {
  //             dynamic setting =
  //                 await getSetting(context, getExtras() as PrintableMaster);
  //             return await PDFListApi(
  //                     list: widget.asList!.cast(),
  //                     context: context,
  //                     setting: setting)
  //                 .generate(format);
  //           });
  //     } else {
  //       ///self list
  //       ///
  //       ///

  //       return PdfPreview(
  //           shareActionExtraEmails: const ["info@saffoury.com"],
  //           initialPageFormat: fomat,
  //           canChangePageFormat: true,
  //           canChangeOrientation: true,
  //           // pdfPreviewPageDecoration:
  //           canDebug: false,
  //           pageFormats: {
  //             AppLocalizations.of(context)!.a3ProductLabel: PdfPageFormat.a3,
  //             AppLocalizations.of(context)!.a4ProductLabel: PdfPageFormat.a4,
  //             AppLocalizations.of(context)!.a5ProductLabel: PdfPageFormat.a5,
  //           },
  //           scrollViewDecoration:
  //               BoxDecoration(color: Theme.of(context).colorScheme.outline),
  //           shareActionExtraBody: "shareActionExtraBody",
  //           dynamicLayout: true,
  //           loadingWidget: const CircularProgressIndicator(),
  //           // actions: [Icon(Icons.search), Icon(Icons.ac_unit_sharp)],
  //           // pdfPreviewPageDecoration: BoxDecoration(color: Colors.green),
  //           useActions: true,

  //           // shouldRepaint: ,
  //           build: (format) async {
  //             // PrintLocalSetting? setting = await getSetting();
  //             return await PdfSelfListApi(
  //                     widget.asList!.cast(), context, getExtras(),
  //                     printCommand: widget.customSetting)
  //                 .generate(format);
  //           });
  //     }
  //   }
  // }

  Widget getPdfPreviewWidget() {
    return SliverFillRemaining(
      child: Selector<PrintSettingLargeScreenProvider,
          Tuple2<ViewAbstract?, PdfPageFormat>>(
        builder: (_, provider, __) {
          debugPrint("BasePdfPageConsumer Selector =>  getPdfPageConsumer");
          return getPdfPreview(provider.item2);
        },
        selector: (ctx, provider) =>
            Tuple2(provider.getViewAbstract, provider.getSelectedFormat),
      ),
    );
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => !firstPane;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setClipRect(bool? firstPane) => false;

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    debugPrint("getCallApiFunctionIfNull");
    return (getExtras() as ViewAbstract).viewCallGetFirstFromList(
        (getExtras() as ViewAbstract).iD,
        context: context) as Future<PrintableMaster?>;
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }

  @override
  Widget? getPaneDraggableExpandedHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }
}
