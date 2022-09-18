import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_screens/printable/base_printable_widget.dart';
import 'package:flutter_view_controller/screens/action_screens/edit_details_page.dart';

import '../providers/actions/edits/edit_error_list_provider.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  Widget getCardLeadingSearch(BuildContext context) {
    return getCardLeadingCircleAvatar(context);
  }

  Widget getCardLeadingDropdown(BuildContext context) {
    return getCardLeadingCircleAvatar(context);
  }

  String getCartItemListText(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  String getCartItemListSubtitle(BuildContext context) {
    return getMainHeaderLabelTextOnly(context);
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

  Widget getCardLeadingCircleAvatar(BuildContext context) {
    return SizedBox(
        width: 60,
        height: 60,
        child: CircleAvatar(radius: 28, child: getCardLeadingImage(context)));
  }

  Widget getCardLeading(BuildContext context) {
    return Hero(tag: this, child: (getCardLeadingCircleAvatar(context)));
  }

  DismissDirection getDismissibleDirection() {
    return DismissDirection.horizontal;
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
      color: Colors.red,
      child: const Icon(
        Icons.delete_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget getCardLeadingImage(BuildContext context) {
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(getMainIconData()),
    );
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

  Widget getPopupMenuActionListWidget(BuildContext context) {
    //TODO for divider use PopupMenuDivider()

    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<MenuItemBuild>> snapshot) {
        return PopupMenuButton<MenuItemBuild>(
          onSelected: (MenuItemBuild result) {
            onPopupMenuActionSelected(context, result);
          },
          itemBuilder: (BuildContext context) =>
              snapshot.data?.map(buildMenuItem).toList() ?? [],
        );
      },
      future: getPopupMenuActionsList(context),
    );
  }

  PopupMenuItem<MenuItemBuild> buildMenuItem(MenuItemBuild e) => PopupMenuItem(
        value: e,
        child: Row(
          children: [
            Icon(
              e.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(e.title),
          ],
        ),
      );

  void onMenuItemActionClickedView(BuildContext context, MenuItemBuild e) {}
  void onPopupMenuActionSelected(BuildContext context, MenuItemBuild result) {
    if (result.icon == Icons.print) {
      debugPrint("onPopupMenuActionSelected $result");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
              body: BasePrintableWidget(
            printObject: this as ViewAbstract,
          )),
        ),
      );
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
