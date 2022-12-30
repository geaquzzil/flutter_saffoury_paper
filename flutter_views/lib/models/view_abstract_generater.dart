import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/dialog/bottom_sheet_viewabstract_options.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/screens/action_screens/view_details_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../utils/dialogs.dart';
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

    await showMenu<String>(
      context: context,

      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx,
        offset.dy,
      ), //position where you want to show the menu on screen
      items: [
        // PopupMenuItem(
        //   child: ElevatedButton(
        //       onPressed: () => {}, child: getMainHeaderText(context)),
        // ),.
        const PopupMenuItem(child: Text('Actions'), enabled: false),
        PopupMenuItem<String>(child: const Text('View'), value: '1'),
        PopupMenuItem<String>(child: const Text('Edit'), value: '2'),
        PopupMenuItem<String>(child: const Text('menu option 3'), value: '3'),
      ],
      elevation: 8.0,
    ).then((value) => {});
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
          .change(this as ViewAbstract, ServerActions.view);
      return;
    }
    Navigator.pushNamed(context, "/view", arguments: this);
  }

  void onDrawerLeadingItemClicked(BuildContext context,
      {ViewAbstract? clickedObject}) {
    debugPrint(
        'onDrawerLeadingItemClicked=> ${getMainHeaderTextOnly(context)}');
    if (SizeConfig.isDesktop(context)) {
      context.read<ActionViewAbstractProvider>().change(
          clickedObject ?? (this as ViewAbstract).getSelfNewInstance(),
          ServerActions.edit);
      return;
    } else {
      Navigator.pushNamed(context, "/add",
          arguments:
              clickedObject ?? (this as ViewAbstract).getSelfNewInstance());
    }
  }

  void onDrawerItemClicked(BuildContext context) {
    debugPrint('onDrawerItemClicked=> ${getMainHeaderTextOnly(context)}');
    //Navigator.of(context).pop();
    context
        .read<DrawerViewAbstractListProvider>()
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

  // for adding drawer headers
  //  const DrawerHeader(
  //             decoration: BoxDecoration(
  //               color: Colors.blue,
  //             ),
  //             child: Text('Drawer Header'),
  //           ),
}
