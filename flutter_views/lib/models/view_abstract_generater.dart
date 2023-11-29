import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/dialog/bottom_sheet_viewabstract_options.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/action_screens/view_details_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
      {required BuildContext context, required GlobalKey clickedWidget}) async {
    RenderBox renderBox =
        clickedWidget.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size; // or _widgetKey.currentContext?.size
    debugPrint('onCardLongClicked Size: ${size.width}, ${size.height}');

    final Offset offset = renderBox.localToGlobal(Offset.zero);
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
      {GlobalKey? clickedWidget}) async {
    debugPrint("onCardLongClicked");

    if (SizeConfig.isLargeScreen(context)) {
      if (clickedWidget == null) return;
      showMenuOn(context: context, clickedWidget: clickedWidget);
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

  void onCardClickedView(BuildContext context) {
    onCardClicked(context);
  }

  void onCardClickedFromSearchResult(BuildContext context) {
    onCardClicked(context);
  }

  void onCardClicked(BuildContext context) {
    debugPrint("Card Clicked");
    if (SizeConfig.hasSecondScreen(context)) {
      context
          .read<ActionViewAbstractProvider>()
          .change((this as ViewAbstract).getCopyInstance(), ServerActions.view);
      return;
    }
    context.pushNamed(viewRouteName,
        pathParameters: {
          "tableName": getTableNameApi() ?? "",
          "id": iD.toString()
        },
        extra: this);
  }

  void onDrawerLeadingItemClicked(BuildContext context,
      {ViewAbstract? clickedObject}) {
    debugPrint(
        'onDrawerLeadingItemClicked=> ${getMainHeaderTextOnly(context)}');
    if (SizeConfig.hasSecondScreen(context)) {
      context.read<ActionViewAbstractProvider>().change(
          clickedObject ?? (this as ViewAbstract).getSelfNewInstance(),
          ServerActions.edit);
      return;
    } else {
      context.goNamed(editRouteName,
          pathParameters: {"tableName": getTableNameApi()!, "id": "$iD"},
          extra: (this as ViewAbstract).getSelfNewInstance());
    }
  }

  void onDrawerItemClicked(BuildContext context) {
    debugPrint('onDrawerItemClicked=> ${getMainHeaderTextOnly(context)}');
    if (this is DashableInterface) {
      Navigator.pushNamed(context, "/dashboard", arguments: this);
      return;
    }
    //Navigator.of(context).pop();
    context
        .read<DrawerMenuControllerProvider>()
        .change(context, getSelfNewInstance() as ViewAbstract);
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
