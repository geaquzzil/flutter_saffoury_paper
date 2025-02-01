import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/prints/printer_default_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_components/dialog/bottom_sheet_viewabstract_options.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/print.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/printing_generator/ext.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api.dart';
import 'package:flutter_view_controller/screens/web/views/web_master_to_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/dialogs.dart';
import 'menu_item.dart';
import 'view_abstract_api.dart';

abstract class ViewAbstractController<T> extends ViewAbstractApi<T> {
  void onCardTrailingClickedView(BuildContext context) {
    onCardTrailingClicked(context);
  }

  void onCardTrailingClicked(BuildContext context) {
    debugPrint("onCardTrailingClicked");
  }

  void onCardLongClickedView(BuildContext context) {
    onCardClicked(context);
  }

  void showMenuOn(
      {required BuildContext context,
      GlobalKey? clickedWidget,
      OffsetHelper? position,
      SliverApiWithStaticMixin? state}) async {
    Offset offset;
    Size size;
    if (position != null) {
      offset = position.offset;
      size = position.size;
    } else {
      RenderBox renderBox =
          clickedWidget!.currentContext?.findRenderObject() as RenderBox;

      size = renderBox.size; // or _widgetKey.currentContext?.size

      offset = renderBox.localToGlobal(Offset.zero);
    }
    debugPrint('onCardLongClicked Size: ${size.width}, ${size.height}');
    debugPrint('onCardLongClicked Offset: ${offset.dx}, ${offset.dy}');
    debugPrint(
        'onCardLongClicked Position: ${(offset.dx + size.width) / 2}, ${(offset.dy + size.height) / 2}');
    var list = (this as ViewAbstract).getPopupMenuActionsList(context);
    await showMenu<MenuItemBuild>(
      context: context,

      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx,
        offset.dy,
      ), //position where you want to show the menu on screen
      items: list
          .map((e) => (this as ViewAbstract).buildMenuItem(context, e))
          .toList(),
      elevation: 8.0,
    );
  }

  void onCardLongClicked(BuildContext context,
      {GlobalKey? clickedWidget,
      OffsetHelper? position,
      SliverApiWithStaticMixin? state}) async {
    debugPrint("onCardLongClicked");

    if (isLargeScreenFromCurrentScreenSize(context)) {
      if (clickedWidget == null && position == null) return;
      showMenuOn(
          context: context,
          clickedWidget: clickedWidget,
          position: position,
          state: state);
      return;
    }

    showBottomSheetExt(
      isScrollable: false,
      withHeightFactor: false,
      context: context,
      builder: (context) => BottomSheetDialogWidget(
          viewAbstract: this as ViewAbstract, state: state),
    );
  }

  void onCardClickedView(BuildContext context, {bool? isSecoundSubPaneView}) {
    onCardClicked(context,
        isMain: false, isSecoundSubPaneView: isSecoundSubPaneView);
  }

  void onCardClickedFromSearchResult(BuildContext context) {
    onCardClicked(context);
  }

  void onCardClicked(BuildContext context,
      {bool isMain = true, bool? isSecoundSubPaneView}) {
    viewPage(context, isSecoundSubPaneView: isSecoundSubPaneView);
  }

  String getUriShare({ServerActions? action}) {
    String uri;
    String tableName = (this as ViewAbstract).getTableNameApi()!;
    String iD = (this as ViewAbstract).getIDString();
    switch (action) {
      case ServerActions.view:
        uri = "view";
        break;
      case ServerActions.edit:
        uri = "edit";
        break;
      case ServerActions.list:
        uri = "list";
        break;
      default:
        uri = "view";
    }
    return "https://saffoury.com/$uri/$tableName/$iD";
  }

  Future<void> sharePage(BuildContext context, {ServerActions? action}) async {
    try {
      ViewAbstract? newO = this as ViewAbstract;
      bool b = getBodyWithoutApi(action ?? ServerActions.view);
      if (!b) {
        debugPrint("sharePage waiting to get object form api");
        newO = (await viewCallGetFirstFromList(iD, context: context))
            as ViewAbstract?;
        debugPrint("sharePage done");
      }
      if (newO != null) {
        debugPrint("sharePage updated list");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          context.read<ListMultiKeyProvider>().edit(newO as ViewAbstract);
        });
      } else {
        //TODO Show the error
        debugPrint("sharePage object is null return ");
        return;
      }
      debugPrint("sharePage object is started");
      String content = (newO as SharableInterface)
          .getContentSharable(context, action: action);
      await Share.share(
          subject: AppLocalizations.of(context)!.shareLabel,
          "$content\n\n${newO.getUriShare(action: action)}");
    } catch (e) {
      //TODO Show the error
      debugPrint("shrePage $e");
    }
  }

  ///routes if list is found then extras could be type of [List] and requires [tableName]
  ///routes if viewAbstract then extras is [ViewAbstract] and required [tableName] TODO [iD]
  void exportPage(BuildContext context,
      {List<ViewAbstract>? asList,
      ValueNotifier<SecondPaneHelper?>? secPaneNotifer}) {
    if (!setPaneToSecondOrThird(
        context,
        ListToDetailsSecoundPaneHelper(
            actionTitle:
                getIDWithLabel(context, action: ServerActions.custom_widget),
            action: ServerActions.custom_widget,
            customWidget: FileExporterPage(
              viewAbstract: this as ViewAbstract,
              list: asList,
            )),
        tryToSetToSecoundPane: false)) {
      context.goNamed(exportRouteName,
          pathParameters: {
            "tableName": getTableNameApi()!,
            "type": asList != null
                ? FileExporterPageType.LIST.toString()
                : FileExporterPageType.SINGLE.toString(),
          },
          queryParameters: {
            if (asList != null) "data": toJsonViewAbstractList(asList.cast())
          },
          extra: asList ?? this);
    }
  }

  void importPage(BuildContext context,
      {ValueNotifier<SecondPaneHelper?>? secPaneNotifer}) {
    if (!setPaneToSecondOrThird(
        context,
        ListToDetailsSecoundPaneHelper(
            actionTitle:
                getIDWithLabel(context, action: ServerActions.custom_widget),
            action: ServerActions.custom_widget,
            customWidget: FileReaderPage(viewAbstract: this as ViewAbstract)),
        tryToSetToSecoundPane: false)) {
      context.goNamed(importRouteName,
          pathParameters: getRoutePathParameters(), extra: this);
    }
  }

  bool setPaneToSecondOrThird(
      BuildContext context, ListToDetailsSecoundPaneHelper l,
      {bool tryToSetToSecoundPane = true}) {
    CurrentScreenSize currentScreenSize = findCurrentScreenSize(context);
    bool isSoLarge = isLargeScreenFromCurrentScreenSize(context);
    bool canSecondPane =
        isSoLarge || currentScreenSize == CurrentScreenSize.SMALL_TABLET;
    bool canThirdPane = isSoLarge;

    debugPrint(
        "setPaneToSecondOrThird CurrentScreenSize $currentScreenSize canSecondPane $canSecondPane canThirdPane $canThirdPane");
    if (!canSecondPane) return false;
    if (canThirdPane && !tryToSetToSecoundPane) {
      if (Globals.keyForLargeScreenListable.currentState == null) {
        debugPrint("setPaneToSecondOrThird keyForLargeScreenListable = null");
        return false;
      }

      Globals.keyForLargeScreenListable.currentState?.setThirdPane(l);
    } else {
      if (Globals.keyForLargeScreenListable.currentState == null) {
        debugPrint("setPaneToSecondOrThird keyForLargeScreenListable = null");
        return false;
      }
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(l);
    }
    return true;
  }

  Map<String, String> getRoutePathParameters() =>
      {"tableName": getTableNameApi() ?? "", "id": getIDString()};

  //TODO isSecoundSubPaneView should i deprecate it ?
  void viewPage(BuildContext context,
      {bool? isSecoundSubPaneView,
      bool disableMasterToListOverride = true,
      ValueNotifier<SecondPaneHelper?>? secPaneNotifer}) {
    bool setToThirdPane = isSecoundSubPaneView ?? false;
    bool isGridableItem = isGridable();
    ViewAbstract? isMasterToList = isGridableItem
        ? (this as WebCategoryGridableInterface)
            .getWebCategoryGridableIsMasterToList(context)
        : null;
    isMasterToList = disableMasterToListOverride ? null : isMasterToList;
    ListToDetailsSecoundPaneHelper l = isMasterToList == null
        ? ListToDetailsSecoundPaneHelper(
            subObject: isSecoundSubPaneView == true ? this : null,
            actionTitle: getIDWithLabel(context, action: ServerActions.view),
            isSecoundPaneView: isSecoundSubPaneView ?? false,
            action: ServerActions.view,
            viewAbstract: this as ViewAbstract)
        : ListToDetailsSecoundPaneHelper(
            subObject: isSecoundSubPaneView == true ? this : null,
            actionTitle: getIDWithLabel(context, action: ServerActions.view),
            isSecoundPaneView: isSecoundSubPaneView ?? false,
            action: ServerActions.custom_widget,
            customWidget: _getMasterToListWidget(context));
    if (!setPaneToSecondOrThird(context, l,
        tryToSetToSecoundPane: !setToThirdPane)) {
      debugPrint("sdsdsds");
      context.pushNamed(
          isMasterToList == null ? viewRouteName : indexWebMasterToList,
          pathParameters: getRoutePathParameters(),
          extra: this);
    }
  }

  Widget _getMasterToListWidget(BuildContext context) {
    return const Center(
      child: Text("_getMasterToListWidget"),
    );
    return ListWebApiPage(
      buildFooter: true,
      buildHeader: true,
      pinToolbar: true,
      useSmallFloatingBar: false,
      valueNotifierGrid: ValueNotifier<bool>(true),
      // customHeader: Column(
      //   children: [
      //     LocationListItem(
      //         usePadding: false,
      //         useResponsiveLayout: false,
      //         useClipRect: false,
      //         // soildColor: Colors.black38,
      //         imageUrl: getImageUrl(context) ?? "",
      //         name: getMainHeaderTextOnly(context),
      //         country: ""),
      //   ],
      // ),
      viewAbstract: (this as WebCategoryGridableInterface)
          .getWebCategoryGridableIsMasterToList(context)!,
    );
    return WebMasterToList(
      buildSmallView: true,
      iD: int.parse(getIDString()),
      tableName: getTableNameApi()!,
      extras: this as ViewAbstract,
    );
  }

  void editPage(BuildContext context,
      {ValueNotifier<SecondPaneHelper?>? secPaneNotifer}) {
    if (!setPaneToSecondOrThird(
      context,
      ListToDetailsSecoundPaneHelper(
          actionTitle: getIDWithLabel(context, action: ServerActions.edit),
          action: ServerActions.edit,
          viewAbstract: this as ViewAbstract),
    )) {
      context.goNamed(editRouteName,
          pathParameters: getRoutePathParameters(),
          extra: (this as ViewAbstract).getCopyInstance());
    }
  }

  Future<bool> directPrint(
      {required BuildContext context,
      required FutureOr<Uint8List> Function(pdf.PdfPageFormat) onLayout,
      required pdf.PdfPageFormat format,
      Printer? printer}) async {
    PrinterDefaultSetting? p =
        await Configurations.get(PrinterDefaultSetting());
    if (p != null) {
      debugPrint("directPrint getting saved value => $p");
      Printer? result = printer ??
          await Printing.listPrinters().then((pr) => pr.firstWhereOrNull(
                (p0) =>
                    p0.name ==
                    ((format == roll80)
                        ? p.defaultLabelPrinter
                        : p.defaultPrinter),
              ));
      debugPrint("directPrint result printer $result");
      if (result != null) {
        return await Printing.directPrintPdf(
            forceCustomPrintPaper: true,
            printer: result,
            onLayout: onLayout,
            format: format);
      }
    }
    return false;
  }

  Future<void> printDialog(BuildContext context,
      {bool standAlone = false,
      List<ViewAbstract>? list,
      bool? isSelfListPrint}) async {
    bool isListPrint = list != null;
    bool isSelfList = isSelfListPrint ?? false;
    PrintPageType type = !isListPrint
        ? PrintPageType.single
        : isSelfList
            ? PrintPageType.self_list
            : PrintPageType.list;
    await showFullScreenDialogExt<ViewAbstract?>(
        barrierDismissible: true,
        anchorPoint: const Offset(1000, 1000),
        context: context,
        builder: (p0) {
          return PdfPageNew(
            buildSecondPane: false,
            isFirstToSecOrThirdPane: true,
            asList: list?.cast(),
            type: type,
            iD: iD,
            tableName: getTableNameApi(),
            extras: this,
          );
        });
  }

  Future<void> printDirect(BuildContext context, Uint8List file) async {
    Printer? p = await Printing.pickPrinter(context: context);
    if (p != null) {
      Printing.directPrintPdf(
        onLayout: (format) => file,
        printer: p,
      );
    }
  }

  void printPage(BuildContext context,
      {bool standAlone = false,
      List<ViewAbstract>? list,
      bool? isSelfListPrint,
      ValueNotifier<SecondPaneHelper?>? secPaneNotifer}) {
    bool isListPrint = list != null;
    bool isSelfList = isSelfListPrint ?? false;
    PrintPageType type = !isListPrint
        ? PrintPageType.single
        : isSelfList
            ? PrintPageType.self_list
            : PrintPageType.list;
    final typeString = type.toString();
    if (secPaneNotifer != null) {
      secPaneNotifer.value = SecondPaneHelper(
        title: getIDWithLabel(context, action: ServerActions.print),
        value: PrintNew(
          // buildSecondPane: false,
          isFirstToSecOrThirdPane: true,
          asList: list?.cast(),
          type: type,
          iD: iD,
          tableName: getTableNameApi(),
          // extras: this,
        ),
      );
      return;
    }
    if (!setPaneToSecondOrThird(
        context,
        ListToDetailsSecoundPaneHelper(
            actionTitle: getIDWithLabel(context, action: ServerActions.print),
            action: ServerActions.custom_widget,
            customWidget: PdfPageNew(
              buildSecondPane: false,
              isFirstToSecOrThirdPane: true,
              asList: list?.cast(),
              type: type,
              iD: iD,
              tableName: getTableNameApi(),
              extras: this,
            ),
            viewAbstract: this as ViewAbstract),
        tryToSetToSecoundPane: false)) {
      context.goNamed(printRouteName,
          pathParameters: {
            "tableName": getTableNameApi() ?? getCustomAction() ?? "-",
            "type": typeString
          },
          queryParameters: {
            "id": "$iD",
            if (list != null) "data": toJsonViewAbstractList(list)
          },
          extra: this);

      // if (standAlone) {
      //   context.pushNamed(printRouteName,
      //       pathParameters: {
      //         "tableName": getTableNameApi() ?? getCustomAction() ?? "-",
      //         "type": typeString
      //       },
      //       queryParameters: {"id": "$iD"},
      //       extra: this);
      // } else {
      //   context.goNamed(printRouteName,
      //       pathParameters: {
      //         "tableName": getTableNameApi() ?? getCustomAction() ?? "-",
      //         "type": typeString
      //       },
      //       queryParameters: {"id": "$iD"},
      //       extra: this);
      // }
    }
  }

  void onDrawerLeadingItemClicked(BuildContext context,
      {ViewAbstract? clickedObject}) {
    debugPrint(
        'onDrawerLeadingItemClicked=> ${getMainHeaderTextOnly(context)}');
    if (isLargeScreenFromCurrentScreenSize(context)) {
      Globals.keyForLargeScreenListable.currentState
          ?.setSecoundPane(ListToDetailsSecoundPaneHelper(
        actionTitle: getIDWithLabel(context, action: ServerActions.edit),
        action: ServerActions.edit,
        viewAbstract:
            clickedObject ?? (this as ViewAbstract).getSelfNewInstance(),
      ));

      return;
    } else {
      context.goNamed(editRouteName,
          pathParameters: {"tableName": getTableNameApi()!, "id": "$iD"},
          extra: (this as ViewAbstract).getSelfNewInstance());
    }
  }

  DrawerMenuControllerProviderAction getDrawerMenuControllerProviderAction() {
    if (this is DashableInterface) {
      return DrawerMenuControllerProviderAction.dashboard;
    } else if (this is ViewAbstractStandAloneCustomViewApi) {
      return DrawerMenuControllerProviderAction.custom;
    }
    // else if (this is PrintableMaster) {
    //   return DrawerMenuControllerProviderAction.print;
    // }
    else {
      return DrawerMenuControllerProviderAction.list;
    }
  }

  void onDrawerItemClicked(BuildContext context) {
    DrawerMenuControllerProviderAction action =
        getDrawerMenuControllerProviderAction();

    debugPrint(
        'onDrawerItemClicked=> ${getMainHeaderTextOnly(context)} action => $action');
    context
        .read<DrawerMenuControllerProvider>()
        .change(context, getSelfNewInstance() as ViewAbstract, action);
  }

  ListTile getDrawerListTitle(BuildContext context) {
    return ListTile(
      subtitle: getMainLabelSubtitleText(context),
      leading: getIcon(),
      title: getMainLabelText(context),
      onTap: () => onDrawerItemClicked(context),
    );
  }

  bool getIsSubViewAbstractIsExpanded(String field) {
    return false;
  }

  // for adding drawer headers
  //  const DrawerHeader(
  //             decoration: BoxDecoration(
  //               color: Colors.blue,
  //             ),
  //             child: Text('Drawer Header'),
  //           ),
}

class OffsetHelper {
  Offset offset;
  Size size;
  OffsetHelper(this.offset, this.size);
}
