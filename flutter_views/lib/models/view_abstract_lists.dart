import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_components/tow_icons_with_badge.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:flutter_view_controller/screens/action_screens/edit_details_page.dart';
import 'package:provider/provider.dart';

import '../providers/actions/action_viewabstract_provider.dart';
import '../providers/actions/edits/edit_error_list_provider.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  IconData? getCardLeadingBottomIcon() => null;
  Widget getCardLeadingSearch(BuildContext context) {
    return getCardLeadingCircleAvatar(context);
  }

  Widget getCardLeadingDropdown(BuildContext context) {
    return getCardLeadingCircleAvatar(context);
  }

  String getCardItemDropdownSubtitle(BuildContext context) {
    return getIDFormat(context);
  }

  String getCardItemDropdownText(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  String getCardItemSearchSubtitle(BuildContext context) {
    return getIDFormat(context);
  }

  String getCardItemSearchText(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  Widget getCardLeadingEditCard(BuildContext context) {
    return Icon(getMainIconData(),
        color: context
                .watch<ErrorFieldsProvider>()
                .getFormValidationManager
                .hasError(this as ViewAbstract)
            ? Colors.red
            : Colors.black54);
  }

  Widget getCardLeadingCircleAvatar(BuildContext context,
      {double width = 60, double height = 60}) {
    return SizedBox(
        width: width,
        height: height,
        child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  }

  Widget getCardLeadingCircleAvatarWithSelectedBorder(BuildContext context) {
    return SizedBox(
        width: 60,
        height: 60,
        child: CircleAvatar(
            radius: 28, child: getCardLeadingImageWithFutureSelected(context)));
  }

  Widget getCardLeadingWithSelecedBorder(BuildContext context) {
    return Hero(
        tag: this,
        child: (getCardLeadingCircleAvatarWithSelectedBorder(context)));
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(tag: this, child: (getCardLeadingCircleAvatar(context)));
  }

  DismissDirection getDismissibleDirection() {
    if (this is CartableProductItemInterface) {
      return DismissDirection.horizontal;
    }

    return DismissDirection.startToEnd;
  }

  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    debugPrint("onDismissed {$this} => direction: $direction");
  }

  Widget getDismissibleSecondaryBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      alignment: Alignment.centerRight,
      color: Colors.green,
      child: const Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
      ),
    );
  }

  Widget getDismissibleBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      alignment: Alignment.centerLeft,
      color: Theme.of(context).colorScheme.error,
      child:  Icon(
        Icons.delete_outlined,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Widget getCardLeadingImageWithFutureSelected(BuildContext context) {
    bool isSelected = context
            .watch<ActionViewAbstractProvider>()
            .getObject
            ?.isEquals(this as ViewAbstract) ??
        false;

    return getCardLeadingImage(context, isSelected: isSelected);
  }

  Widget getCardLeadingImage(BuildContext context, {bool? isSelected}) {
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    IconData? iconOnButton = getCardLeadingBottomIcon();
    Widget image = CachedNetworkImage(
      color: Colors.white,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          border: (isSelected == false)
              ? null
              : Border.all(
                  color: Theme.of(context).colorScheme.outline, width: 1),
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(getMainIconData()),
    );
    if (iconOnButton != null) {
      return TowIcons(
        largChild: image,
        smallIcon: iconOnButton,
      );
    }
    return image;
  }

  MenuItemBuild getMenuItemPrint(BuildContext context) {
    return MenuItemBuild(
      'Print',
      Icons.print,
      '/print',
    );
  }

  MenuItemBuild getMenuItemEdit(BuildContext context) {
    return MenuItemBuild(
      'Edit',
      Icons.edit,
      'edit',
    );
  }

  MenuItemBuild getMenuItemView(BuildContext context) {
    return MenuItemBuild(
      'View',
      Icons.view_agenda,
      '',
    );
  }

  MenuItemBuild getMenuItemShare(BuildContext context) {
    return MenuItemBuild(
      'Share',
      Icons.share,
      'share',
    );
  }

  List<Widget>? getPopupActionsList(BuildContext context) => null;

  Future<List<MenuItemBuild>> getPopupMenuActionsView(
      BuildContext context) async {
    return [
      if (await hasPermissionPrint(context)) getMenuItemPrint(context),
      if (await hasPermissionShare(context)) getMenuItemShare(context),
      if (await hasPermissionEdit(context)) getMenuItemEdit(context),
    ];
  }

  Future<List<MenuItemBuild>> getPopupMenuActionsEdit(
      BuildContext context) async {
    return [
      if (await hasPermissionPrint(context)) getMenuItemPrint(context),
      if (await hasPermissionShare(context)) getMenuItemShare(context),
      if (await hasPermissionEdit(context)) getMenuItemEdit(context),
    ];
  }

  Future<List<MenuItemBuild>> getPopupMenuActionsList(
      BuildContext context) async {
    return [
      if (await hasPermissionPrint(context)) getMenuItemPrint(context),
      if (await hasPermissionEdit(context)) getMenuItemEdit(context),
      if (await hasPermissionView(context)) getMenuItemView(context),
      if (await hasPermissionShare(context)) getMenuItemShare(context),
    ];
  }

  Widget getPopupMenuActionListWidget(BuildContext c) {
    //TODO for divider use PopupMenuDivider()

    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<MenuItemBuild>> snapshot) {
        return PopupMenuButton<MenuItemBuild>(
          onSelected: (MenuItemBuild result) {
            onPopupMenuActionSelected(c, result);
          },
          itemBuilder: (BuildContext context) =>
              snapshot.data?.map(buildMenuItem).toList() ?? [],
        );
      },
      future: getPopupMenuActionsList(c),
    );
  }

  PopupMenuItem<MenuItemBuild> buildMenuItem(MenuItemBuild e) => PopupMenuItem(
        value: e,
        child: Row(
          children: [
            Icon(
              e.icon,
              // color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(e.title),
          ],
        ),
      );

  void onMenuItemActionClickedView(BuildContext context, MenuItemBuild e) {
    onPopupMenuActionSelected(context, e);
  }

  void onPopupMenuActionSelected(BuildContext context, MenuItemBuild result) {
    debugPrint("onPopupMenuActionSelected $result");
    if (result.icon == Icons.print) {
      debugPrint("onPopupMenuActionSelected $result");

      // context.read<EndDrawerProvider>().changeAndOpen(
      //     context,
      //     PdfPage(
      //       invoiceObj: this as PrintableInterface,
      //     ));
      context.read<ActionViewAbstractProvider>().changeCustomWidget(PdfPage(
            invoiceObj: this as PrintableMaster,
          ));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PdfPage(
      //               invoiceObj: this as PrintableMaster,
      //             )));
    } else if (result.icon == Icons.edit) {
      // context.read<ActionViewAbstractProvider>().change(this as ViewAbstract);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditDetailsPage(
            object: this as ViewAbstract,
          ),
        ),
      );
    }
  }
}
