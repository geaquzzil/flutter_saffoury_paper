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
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/printing_generator/page/base_pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PdfPageNew<T extends PrintLocalSetting> extends BasePageApi {
  bool buildBaseHeader;

  PdfPageNew(
      {super.key,
      super.iD,
      super.extras,
      super.tableName,
      this.buildBaseHeader = false,
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
        onPressed: () async => await Printing.sharePdf(bytes: loadedFileBytes));
  }

  Widget getPrintFloating(BuildContext context) {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.print),
        onPressed: () async => await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => loadedFile));
  }

  Widget getPrintAdvancedFloating() {
    return FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.settings),
        onPressed: () async {
          var v = await getSettingLoadDefaultIfNull(context, getExtras());
          await showFullScreenDialogExt<ViewAbstract?>(
              anchorPoint: const Offset(1000, 1000),
              context: context,
              builder: (p0) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    // color: Theme.of(context).colorScheme.secondaryContainer,
                    child: IntrinsicWidth(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              (isTablet(context) ? 0.5 : 0.25),
                          height: MediaQuery.of(context).size.height * .8,
                          child: BaseEditNewPage(
                            viewAbstract: v as ViewAbstract,
                          )),
                    ),
                  ),
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
                //todo translate
                hint: "Select size",
                list: [
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
  getPane(
      {required bool firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (getCurrentScreenSize() == CurrentScreenSize.MOBILE && firstPane) {
      return getPdfPreviewWidget();
    }
    return getPdfPreviewWidget();
  }

  Widget getSettingWidget() {
    Widget setting = const Center(
      child: Text("getFirstPane"),
    );

    return FutureBuilder<ViewAbstract?>(
      future: getSettingLoadDefaultIfNull(context, getExtras()),
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
                Configurations.save(
                    "_printsetting${getExtrasCast().runtimeType}",
                    viewAbstract);
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

  Widget getPdfPreviewWidget() {
    return Selector<PrintSettingLargeScreenProvider,
        Tuple2<ViewAbstract?, PdfPageFormat>>(
      builder: (_, provider, __) {
        debugPrint("BasePdfPageConsumer Selector =>  getPdfPageConsumer");
        return PdfPreview(
            pdfFileName: getExtras()!.getPrintableQrCodeID(),
            shareActionExtraEmails: const ["info@saffoury.com"],
            maxPageWidth: getWidth,
            initialPageFormat: provider.item2, //todo setting
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
                  getExcelFileUinit(context, getExtras()!, provider.item2);
              loadedFileBytes = await loadedFile;
              return loadedFileBytes;
            });
      },
      selector: (ctx, provider) =>
          Tuple2(provider.getViewAbstract, provider.getSelectedFormat),
    );
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) =>
      !firstPane;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;

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
}
