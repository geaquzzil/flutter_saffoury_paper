import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/size_config.dart';

ListTile buildMenuItemListTile(BuildContext context, MenuItemBuild e) {
  return ListTile(
    leading: Icon(e.icon),
    title: Text(e.title),
  );
}

PopupMenuItem<MenuItemBuild> buildMenuItem(
        BuildContext context, MenuItemBuild e) =>
    PopupMenuItem(value: e, child: buildMenuItemListTile(context, e));
Future<MenuItemBuild?> showPopupMenu(
    BuildContext context, GlobalKey clickedWidget,
    {required List<PopupMenuEntry<MenuItemBuild>> list}) {
  RenderBox renderBox =
      clickedWidget.currentContext?.findRenderObject() as RenderBox;
  final Size size = renderBox.size;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      offset.dx,
      offset.dy,
    ), //
    items: list,
    elevation: 8.0,
  );
}

Future<T?> showBottomSheetExt<T>(
    {required BuildContext context,
    bool isScrollable = true,
    bool withHeightFactor = true,
    required Widget Function(BuildContext) builder}) {
  return showModalBottomSheet<T>(
    isScrollControlled: isScrollable,
    context: context,
    elevation: 4,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (context) {
      return withHeightFactor
          ? FractionallySizedBox(
              heightFactor: 0.9, child: builder.call(context))
          : builder.call(context);
    },
  );
}

Future<T?> showDialogExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder}) {
  return showDialog(
      context: context, barrierDismissible: false, builder: builder);
}
