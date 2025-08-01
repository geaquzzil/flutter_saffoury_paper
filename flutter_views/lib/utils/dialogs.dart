import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../providers/cart/cart_provider.dart';

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
    isDismissible: false,
    elevation: 10,
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
    Offset? anchorPoint,
    bool barrierDismissible = false}) {
  if (isLargeScreenFromCurrentScreenSize(context)) {
    return showGeneralDialog(
      anchorPoint: anchorPoint,
      context: context,
      barrierDismissible: barrierDismissible,
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
          child: Align(alignment: Alignment.topRight, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicWidth(
            child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    (isTablet(context) ? 0.5 : 0.3),
                height: MediaQuery.of(context).size.height,
                child: builder.call(context)),
          ),
        );
      },
    );
  } else {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return builder.call(context);
        },
        fullscreenDialog: true));
  }
}

Future<dynamic> showCartDialog(
    BuildContext context, CartableProductItemInterface viewAbstract) {
  return showDialogExt(
      barrierDismissible: true,
      anchorPoint: const Offset(1000, 1000),
      context: context,
      builder: (context) {
        final TextEditingController textEditingController =
            TextEditingController();
        textEditingController.text =
            "${viewAbstract.getCartableProductQuantity()}";
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        return StatefulBuilder(builder: (context, setState) {
          double minValue = 1;
          double maxValue = viewAbstract.getCartableProductQuantity();
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: SizedBox(
              width: 200,
              // height: 500,
              child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.number,
                        controller: textEditingController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(maxValue),
                          FormBuilderValidators.min(minValue),
                        ]),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.quantity,
                          icon: const Icon(Icons.shopping_cart_rounded),
                          // iconColor: context
                          //         .watch<ErrorFieldsProvider>()
                          //         .hasErrorField(viewAbstract, field)
                          //     ? Theme.of(context).colorScheme.error
                          //     : null,
                          labelText: AppLocalizations.of(context)!.add_to_cart,
                          suffixText:
                              viewAbstract.getCartableQuantityUnit(context),
                        ),
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.subment),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<CartProvider>().onCartItemAdded(
                        context,
                        -1,
                        viewAbstract,
                        double.tryParse(textEditingController.text) ?? 0);
                    // Do something like updating SharedPreferences or User Settings etc.
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
      });
}

Future<T?> showDialogExt<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder,
    Offset? anchorPoint,
    bool barrierDismissible = false}) {
  return showDialog(
      anchorPoint: anchorPoint,
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder);
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color? color;

  const CustomPopupMenuItem({
    super.key,
    super.value,
    super.enabled,
    super.child,
    this.color,
  });

  @override
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? Theme.of(context).cardColor,
      child: super.build(context),
    );
  }
}
