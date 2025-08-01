// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../interfaces/printable/printable_master.dart';
import '../../models/servers/server_helpers.dart';
import 'base_pdf_page.dart';
import 'ext.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';

class PdfPage<T extends PrintLocalSetting> extends BasePdfPage {
  int? iD;
  String? tableName;
  PrintableMaster<T>? invoiceObj;

  PdfPage(
      {super.key,
      required this.invoiceObj,
      required this.iD,
      required this.tableName});

  @override
  _PdfPageState<T> createState() => _PdfPageState<T>();
}

class _PdfPageState<T extends PrintLocalSetting>
    extends BasePdfPageState<PdfPage, PrintableMaster<T>?> {
  late Future<Uint8List> loadedFile;
  late Uint8List loadedFileBytes;

  _PdfPageState({super.iD, super.tableName, super.extras});

  @override
  void initState() {
    iD = widget.iD;
    tableName = widget.tableName;
    extras = widget.invoiceObj as PrintableMaster<T>?;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    iD = widget.iD;
    tableName = widget.tableName;
    extras = widget.invoiceObj as PrintableMaster<T>?;
    super.didChangeDependencies();
  }

  @override
  Future<PrintableMaster<T>?> getCallApiFunctionIfNull(BuildContext context) {
    if (getExtras() == null) {
      ViewAbstract newViewAbstract =
          context.read<AuthProvider<AuthUser>>().getNewInstance(tableName!)!;
      return newViewAbstract.viewCall(customID: iD!, context: context)
          as Future<PrintableMaster<T>?>;
    } else {
      return (getExtras() as ViewAbstract).viewCall(
          customID: (getExtras() as ViewAbstract).iD,
          context: context) as Future<PrintableMaster<T>?>;
    }
  }

  @override
  Widget getFutureBody(BuildContext context, PrintableMaster<T>? newObject,
      PdfPageFormat formt) {
    return FutureBuilder(
      future: (newObject as ViewAbstract).viewCall(
          context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyWidget(
              lottiUrl:
                  "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
              onSubtitleClicked: () {
                setState(() {});
              },
              title: AppLocalizations.of(context)!.cantConnect,
              subtitle: AppLocalizations.of(context)!.cantConnectRetry);
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            widget.invoiceObj = snapshot.data as PrintableMaster;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              context
                  .read<ListMultiKeyProvider>()
                  .edit(snapshot.data as ViewAbstract);
            });

            return getBody(context, formt);
          } else {
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                onSubtitleClicked: () {
                  setState(() {});
                },
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text("TOTODO");
        }
      },
    );
  }

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
                onValueSelectedFunction: (object) {
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
            )
          ],
        ));
  }

  double getSizeOfController() {
    if (SizeConfig.isFoldableWithOpenDualScreen(context)) {
      Size size = MediaQuery.of(context).size;
      return ((size.width / 2) / 3) - kDefaultPadding;
    }
    return (MediaQuery.of(context).size.width / 3) - kDefaultPadding;
  }

  Widget getBody(BuildContext contextm, PdfPageFormat selectedFormat) {
    return PdfPreview(
        pdfFileName: getExtras()!.getPrintableQrCodeID(),
        shareActionExtraEmails: const ["info@saffoury.com"],
        maxPageWidth: 200,
        initialPageFormat: selectedFormat,
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
          loadedFile = getExcelFileUinit(context, getExtras()!, selectedFormat);
          loadedFileBytes = await loadedFile;
          return loadedFileBytes;
        });
  }

  @override
  Widget getFloatingActions(BuildContext context) {
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

  @override
  Future<ViewAbstract?>? getSettingObject(BuildContext context) {
    if (getExtras() == null) {
      debugPrint("getExtras == null");
      return null;
    }
    return getSettingLoadDefaultIfNull(context, getExtras()!);
  }

  @override
  ViewAbstract getMainObject() {
    return getExtras() as ViewAbstract;
  }

  @override
  ServerActions getServerActions() {
    return ServerActions.view;
  }
}

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    super.key,
    required this.icon,
    required this.text,
  });

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
    super.key,
    required this.text,
    required this.onClicked,
  });

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
