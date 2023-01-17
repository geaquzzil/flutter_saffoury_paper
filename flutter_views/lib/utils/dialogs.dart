import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/size_config.dart';

ListTile buildMenuItemListTile(BuildContext context, MenuItemBuild e) {
  return ListTile(
    leading: Icon(e.icon),
    title: Text(e.title),
  );
}

Size getSize(GlobalKey key) {
  RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
  return renderBox.size;
}

Offset getOffset(GlobalKey key) {
  RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero);
}

Rect getRect(GlobalKey key) {
  Offset offset = getOffset(key);
  Size size = getSize(key);
  return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
}

PopupMenuItem<MenuItemBuild> buildMenuItem(
        BuildContext context, MenuItemBuild e) =>
    PopupMenuItem(value: e, child: buildMenuItemListTile(context, e));
Future<MenuItemBuild?> showPopupMenu(
    BuildContext context, GlobalKey clickedWidget,
    {required List<PopupMenuEntry<MenuItemBuild>> list, Alignment? alignment}) {
  RenderBox renderBox =
      clickedWidget.currentContext?.findRenderObject() as RenderBox;
  final Size size = renderBox.size;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  debugPrint(
      "showPopupMenu renderBox:size=> width: ${size.width} , height: ${size.height} offset.dx  => ${offset.dx} offset.dY=> ${offset.dy} ");
  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx + (alignment == Alignment.centerRight ? size.width : 0),
      offset.dy +
          (alignment == Alignment.centerRight
              ? (size.height / 2)
              : size.height),
      offset.dx + (alignment == Alignment.centerRight ? size.width : 0),
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

Future<T?> showFullScreenDialogExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder,
    Offset? anchorPoint}) {
  if (SizeConfig.isLargeScreenGeneral(context)) {
    return showGeneralDialog(
      anchorPoint: anchorPoint,
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) =>
          builder.call(context),
    );
  } else {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return builder.call(context);
        },
        fullscreenDialog: true));
  }
}

Future<T?> showDialogExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder,
    Offset? anchorPoint}) {
  return showDialog(
      anchorPoint: anchorPoint,
      context: context,
      barrierDismissible: false,
      builder: builder);
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color? color;

  const CustomPopupMenuItem({
    Key? key,
    T? value,
    bool enabled = true,
    Widget? child,
    this.color,
  }) : super(key: key, value: value, enabled: enabled, child: child);

  @override
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: super.build(context),
      color: widget.color ?? Theme.of(context).cardColor,
    );
  }
}
