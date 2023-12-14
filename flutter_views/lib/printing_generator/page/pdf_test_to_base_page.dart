import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/helper_model/product.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/printing_generator/page/ext.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
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
  bool isPaneScaffoldOverlayColord(bool firstPane) {
    return firstPane;
  }

  @override
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize) {
    return null;
    return ListTile(
      leading: BackButton(),
      // title: Text("base pane tool bar",
      //     style: Theme.of(context).textTheme.headlineLarge),
      // subtitle: Text("Subtitle Toolbar"),
    );
  }

  @override
  Widget? getBaseFloatingActionButton(CurrentScreenSize currentScreenSize) =>
      null;

  @override
  getDesktopFirstPane(double width) {
    return getFirstPane(width);
    ViewAbstract v = context.read<DrawerMenuControllerProvider>().getObject;
    debugPrint("gettingDesktopFirstPane ");
    // return const Center(child: Text(" this is a desktop body second pane"));

    return Column(
      children: [
        IconButton(
          iconSize: 40,
          padding: EdgeInsets.all(20),
          // hoverColor: Colors.red,
          icon: Icon(Icons.print),
          onPressed: () {},
        ),
        DropdownStringListControllerListener(
          icon: Icons.print,
          currentScreenSize: getCurrentScreenSize(),
          tag: "printOptions",
          onSelected: (object) {
            if (object != null) {
              pdf.PdfPageFormat chosedPageFormat;
              if (object.label ==
                  AppLocalizations.of(context)!.a3ProductLabel) {
                chosedPageFormat = pdf.PdfPageFormat.a3;
              } else if (object.label ==
                  AppLocalizations.of(context)!.a4ProductLabel) {
                chosedPageFormat = pdf.PdfPageFormat.a4;
              } else {
                chosedPageFormat = pdf.PdfPageFormat.a5;
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
    return BaseSharedDetailsView();
    return null;
    ViewAbstract v = context.read<DrawerMenuControllerProvider>().getObject;
    double pane = getCustomPaneProportion();
    return Column(
      children: [
        // MaterialBanner(
        //   content: Text('This is a MaterialBanner'),
        //   actions: <Widget>[
        //     TextButton(
        //       onPressed: null,
        //       child: Text('DISMISS'),
        //     ),
        //   ],
        // ),
        Expanded(
          child: PdfPreview(
              pdfFileName: (v as PrintableMaster).getPrintableQrCodeID(),
              shareActionExtraEmails: const ["info@saffoury.com"],
              // maxPageWidth: 500,
              maxPageWidth: ((pane + .05) * width),
              previewPageMargin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              initialPageFormat: pdf.PdfPageFormat.a4,
              canDebug: false,
              scrollViewDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
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
                pw.Document c = await getDocumentFile(
                    context, v as PrintableMaster, format);
                debugPrint(
                    "pdf document c files pages ${c.document.pdfPageList.pages.length} ");
                loadedFile = c.save();
                loadedFileBytes = await loadedFile;
                // secondPaneScaffold.currentState.sh
                ScaffoldMessenger.of(context).showMaterialBanner(
                  const MaterialBanner(
                    content: Text('This is a MaterialBanner'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: null,
                        child: Text('DISMISS'),
                      ),
                    ],
                  ),
                );
                return loadedFileBytes;
              }),
        ),
        Row(
          // mainAxisSize: ,
          children: [
            IconButton(
              // iconSize: 40,
              // padding: EdgeInsets.all(20),
              // hoverColor: Colors.red,
              icon: Icon(Icons.arrow_left),
              onPressed: () {},
            ),
            SizedBox(width: 20, child: TextFormField()),
            Text("of 1"),
            IconButton(
              // iconSize: 40,
              // padding: EdgeInsets.all(20),
              // hoverColor: Colors.red,
              icon: Icon(Icons.arrow_right),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  @override
  getFirstPane(double width) => SliverApiMaster(
        buildSearchWidgetAsEditText:
            isLargeScreenFromScreenSize(getCurrentScreenSize()),
        tableName: "products_inputs",
        currentScreenSize: getCurrentScreenSize(),
        buildFabIfMobile: getCurrentScreenSize() != CurrentScreenSize.DESKTOP,
      );

  @override
  getSecoundPane(double width) => getDesktopSecondPane(width);

  @override
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize) {
    return null;
    return ListTile(
      title: Text("first pane tool bar",
          style: Theme.of(context).textTheme.headlineLarge),
      subtitle: Text("Subtitle Toolbar"),
    );
  }

  @override
  Widget? getFirstPaneFloatingActionButton(
          CurrentScreenSize currentScreenSize) =>
      null;

  @override
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize) {
    return null;
    return Selector<ActionViewAbstractProvider, List<StackedActions?>>(
      builder: (_, v, __) {
        debugPrint("SelectorActionViewAbstractProvider ${v.length}");
        if (v.isEmpty || v.length == 1) {
          return SizedBox();
        }
        int i = v.length - 1;
        return ListTile(
          leading: BackButton(onPressed: () {
            context.read<ActionViewAbstractProvider>().pop();
            // context
            //     .read<ActionViewAbstractProvider>()
            //     .change(v[i]!.object!, v[i]!.serverActions!,removeLast: true);
          }),
        );
      },
      selector: (p, p0) => p0.getStackedActions,
    );
  }

  @override
  Widget? getSecondPaneFloatingActionButton(
      CurrentScreenSize currentScreenSize) {
    return null;
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.print),
    );
  }

  @override
  bool isPanesIsSliver(bool firstPane) => false;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize) => true;

  @override
  Widget? getBaseBottomSheet() => null;

  @override
  Widget? getFirstPaneBottomSheet() {
    return null;
    return BottomAppBar(
      // color: Theme.of(context).colorScheme.surface,
      // elevation: 2,
      shape: const AutomaticNotchedShape(RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25)),
      )),
      child: IconButton(
        iconSize: 40,
        // padding: EdgeInsets.all(20),
        // hoverColor: Colors.red,
        icon: Icon(Icons.print),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget? getSecondPaneBottomSheet() {
    return null;
    // BottomNavigationBar(items: items)
    return BottomAppBar(
      // color: Colors.transparent,
      // color: Theme.of(context).colorScheme.surface,
      // elevation: 2,
      shape: const AutomaticNotchedShape(RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25)),
      )),
      child: Expanded(
        child: Row(
          // mainAxisSize: ,
          children: [
            IconButton(
              // iconSize: 40,
              // padding: EdgeInsets.all(20),
              // hoverColor: Colors.red,
              icon: Icon(Icons.arrow_left),
              onPressed: () {},
            ),
            SizedBox(width: 20, child: TextFormField()),
            Text("of 1"),
            IconButton(
              // iconSize: 40,
              // padding: EdgeInsets.all(20),
              // hoverColor: Colors.red,
              icon: Icon(Icons.arrow_right),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool setBodyPadding(bool firstPane) => false;
  
  @override
  bool setPaneClipRect(bool firstPane)  => false;
}
