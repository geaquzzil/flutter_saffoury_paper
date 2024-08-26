import 'package:flutter/material.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_components/dialog/bottom_sheet_viewabstract_options.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_determine_screen_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api.dart';
import 'package:flutter_view_controller/screens/web/parallex/parallexes.dart';
import 'package:flutter_view_controller/screens/web/views/web_master_to_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
      OffsetHelper? position}) async {
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
      {GlobalKey? clickedWidget, OffsetHelper? position}) async {
    debugPrint("onCardLongClicked");

    if (isLargeScreenFromCurrentScreenSize(context)) {
      if (clickedWidget == null && position == null) return;
      showMenuOn(
          context: context, clickedWidget: clickedWidget, position: position);
      return;
    }

    showBottomSheetExt(
      isScrollable: false,
      withHeightFactor: false,
      context: context,
      builder: (context) =>
          BottomSheetDialogWidget(viewAbstract: this as ViewAbstract),
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
        newO = (await viewCallGetFirstFromList(iD)) as ViewAbstract?;
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

  void exportPage(BuildContext context) {
    if (isLargeScreenFromCurrentScreenSize(context)) {
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(
          //todo traanslate
          ListToDetailsSecoundPaneHelper(
              actionTitle:
                  getIDWithLabel(context, action: ServerActions.custom_widget),
              action: ServerActions.custom_widget,
              customWidget:
                  FileReaderPage(viewAbstract: this as ViewAbstract)));
    } else {
      context.goNamed(importRouteName,
          pathParameters: {"tableName": getTableNameApi()!}, extra: this);
    }
  }

  void importPage(BuildContext context) {
    if (isLargeScreenFromCurrentScreenSize(context)) {
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(
          //todo traanslate
          ListToDetailsSecoundPaneHelper(
              actionTitle:
                  getIDWithLabel(context, action: ServerActions.custom_widget),
              action: ServerActions.custom_widget,
              customWidget:
                  FileExporterPage(viewAbstract: this as ViewAbstract)));
    } else {
      context.goNamed(exportRouteName,
          pathParameters: getRoutePathParameters(), extra: this);
    }
  }

  Map<String, String> getRoutePathParameters() =>
      {"tableName": getTableNameApi() ?? "", "id": getIDString()};
  void viewPage(BuildContext context, {bool? isSecoundSubPaneView}) {
    bool isLarge = isLargeScreenFromCurrentScreenSize(context);
    debugPrint("Page=>viewPage Page isLarge:$isLarge");
    bool isGridableItem = isGridable();
    ViewAbstract? isMasterToList = isGridableItem
        ? (this as WebCategoryGridableInterface)
            .getWebCategoryGridableIsMasterToList(context)
        : null;
    if (isLarge) {
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(
          isMasterToList == null
              ? ListToDetailsSecoundPaneHelper(
                  subObject: isSecoundSubPaneView == true ? this : null,
                  actionTitle:
                      getIDWithLabel(context, action: ServerActions.view),
                  isSecoundPaneView: isSecoundSubPaneView ?? false,
                  action: ServerActions.view,
                  viewAbstract: this as ViewAbstract)
              : ListToDetailsSecoundPaneHelper(
                  subObject: isSecoundSubPaneView == true ? this : null,
                  actionTitle:
                      getIDWithLabel(context, action: ServerActions.view),
                  isSecoundPaneView: isSecoundSubPaneView ?? false,
                  action: ServerActions.custom_widget,
                  customWidget: _getMasterToListWidget(context)));
      return;
    } else {
      context.pushNamed(
          isMasterToList == null ? viewRouteName : indexWebMasterToList,
          pathParameters: getRoutePathParameters(),
          extra: this);
    }
  }

  Widget _getMasterToListWidget(BuildContext context) {
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

  void editPage(BuildContext context) {
    bool isLarge = isLargeScreenFromCurrentScreenSize(context);
    debugPrint("Page=>editPage Page isLarge:$isLarge");
    if (isLarge) {
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(
          ListToDetailsSecoundPaneHelper(
              actionTitle: getIDWithLabel(context, action: ServerActions.edit),
              action: ServerActions.edit,
              viewAbstract: this as ViewAbstract));
      return;
      context
          .read<DrawerMenuControllerProvider>()
          .change(context, this, DrawerMenuControllerProviderAction.edit);
    } else {
      context.goNamed(editRouteName,
          pathParameters: getRoutePathParameters(),
          extra: (this as ViewAbstract).getCopyInstance());
    }
  }

  void printPage(BuildContext context) {
    bool isLarge = isLargeScreenFromCurrentScreenSize(context);
    debugPrint("Page=>printPage Page isLarge:$isLarge");
    if (isLarge) {
      Globals.keyForLargeScreenListable.currentState?.setSecoundPane(
          ListToDetailsSecoundPaneHelper(
              actionTitle: getIDWithLabel(context, action: ServerActions.print),
              action: ServerActions.print,
              viewAbstract: this as ViewAbstract));
      return;
      context
          .read<DrawerMenuControllerProvider>()
          .change(context, this, DrawerMenuControllerProviderAction.print);
    } else {
      context.goNamed(printRouteName,
          pathParameters: {
            "tableName": getTableNameApi() ?? getCustomAction() ?? "-",
            "type": PrintPageType.single.toString()
          },
          queryParameters: {"id": "$iD"},
          extra: this);
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
