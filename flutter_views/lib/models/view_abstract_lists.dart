import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_components/tow_icons_with_badge.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:flutter_view_controller/screens/action_screens/edit_details_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:share_plus/share_plus.dart';
import '../new_components/views/view_popup_icon_widget.dart';
import '../providers/actions/action_viewabstract_provider.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  @JsonKey(ignore: true)
  bool isSelected = false;

  Color? getMainColor() {
    return null;
  }

  IconData? getCardLeadingBottomIcon() {
    return null;
  }

  Widget getCardLeadingSearch(BuildContext context,
      {bool addBottomWidget = true}) {
    return getCardLeadingCircleAvatar(context,
        addBottomWidget: addBottomWidget);
  }

  Widget getCardLeadingDropdown(BuildContext context,
      {bool addBottomWidget = true}) {
    return getCardLeadingCircleAvatar(context,
        addBottomWidget: addBottomWidget);
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

  Widget getCardLeadingCircleAvatar(BuildContext context,
      {double width = 60, double height = 60, bool addBottomWidget = true}) {
    return CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).backgroundColor,
        child: getCardLeadingImage(context, addBottomWidget: addBottomWidget));
  }

  Widget getHeroTag(
      {required BuildContext context,
      required Widget child,
      String? addCustomHeroTag}) {
    return Hero(
        tag: getIDFormat(context) +
            (getTableNameApi() ?? "") +
            (addCustomHeroTag ?? ""),
        child: child);
  }

  Widget getCardLeading(BuildContext context,
      {String? addCustomHeroTag, bool addBottomWidget = true}) {
    return getHeroTag(
        context: context,
        child: getCardLeadingCircleAvatar(context,
            addBottomWidget: addBottomWidget));
  }

  DismissDirection getDismissibleDirection() {
    if (this is CartableProductItemInterface) {
      return DismissDirection.horizontal;
    }

    return DismissDirection.startToEnd;
  }

  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    debugPrint("onDismissed {$this} => direction: $direction");
    if (direction == DismissDirection.startToEnd) {
      context
          .read<ActionViewAbstractProvider>()
          .change(this as ViewAbstract, ServerActions.edit);
    }
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
      child: Icon(
        Icons.delete_outlined,
        color: Theme.of(context).colorScheme.onError,
      ),
    );
  }

  Widget getBlurringImage(BuildContext context, {bool addBottomWidget = true}) {
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    IconData? iconOnButton =
        addBottomWidget ? getCardLeadingBottomIcon() : null;
    Widget image = CachedNetworkImage(
      color: Theme.of(context).colorScheme.onBackground,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: Container(
            decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)),
          ),
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

  Widget getCardLeadingImage(BuildContext context,
      {bool? isSelected, bool addBottomWidget = true}) {
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    IconData? iconOnButton =
        addBottomWidget ? getCardLeadingBottomIcon() : null;
    Widget image = CachedNetworkImage(
      color: Theme.of(context).colorScheme.onBackground,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onBackground,
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
      AppLocalizations.of(context)!.print,
      Icons.print,
      '/print',
    );
  }

  MenuItemBuild getMenuItemEdit(BuildContext context) {
    return MenuItemBuild(
      AppLocalizations.of(context)!.edit,
      Icons.edit,
      '/edit',
    );
  }

  MenuItemBuild getMenuItemView(BuildContext context) {
    return MenuItemBuild(
      AppLocalizations.of(context)!.view,
      Icons.view_agenda,
      '/view',
    );
  }

  MenuItemBuild getMenuItemShare(BuildContext context) {
    return MenuItemBuild(
      AppLocalizations.of(context)!.share,
      Icons.share,
      'share',
    );
  }

  List<Widget>? getPopupActionsList(BuildContext context) => null;

  List<MenuItemBuild> getPopupMenuActionsView(BuildContext context) {
    return [
      if (hasPermissionPrint(context)) getMenuItemPrint(context),
      if (hasPermissionShare(context)) getMenuItemShare(context),
      if (hasPermissionEdit(context)) getMenuItemEdit(context),
    ];
  }

  Future<List<MenuItemBuild>> getPopupMenuActions(
      BuildContext context, ServerActions action) async {
    if (action == ServerActions.edit) {
      return getPopupMenuActionsEdit(context);
    }

    return [];
  }

  List<MenuItemBuildGenirc> getPopupMenuActionsThreeDot(
      BuildContext context, ServerActions? action) {
    return [];
  }

  List<MenuItemBuild> getPopupMenuActionsEdit(BuildContext context) {
    return [
      if (hasPermissionPrint(context)) getMenuItemPrint(context),
      if (hasPermissionShare(context)) getMenuItemShare(context),
      if (hasPermissionEdit(context)) getMenuItemEdit(context),
    ];
  }

  List<MenuItemBuild> getPopupMenuActionsList(BuildContext context) {
    return [
      if (hasPermissionShare(context)) getMenuItemShare(context),
      if (hasPermissionPrint(context)) getMenuItemPrint(context),
      if (hasPermissionEdit(context)) getMenuItemEdit(context),
      if (hasPermissionView(context)) getMenuItemView(context),
    ];
  }

  @Deprecated("Not future anymore")
  Widget onFutureAllPopupMenuLoaded(BuildContext context, ServerActions action,
      {required Widget Function(List<MenuItemBuild>) onPopupMenuListLoaded}) {
    List<MenuItemBuild> list = action == ServerActions.edit
        ? getPopupMenuActionsEdit(context)
        : getPopupMenuActionsList(context);
    return onPopupMenuListLoaded(list);
  }

  Widget getPopupMenuActionWidget(BuildContext c, ServerActions action) {
    //TODO for divider use PopupMenuDivider()
    List<MenuItemBuild> items = action == ServerActions.edit
        ? getPopupMenuActionsEdit(c)
        : getPopupMenuActionsList(c);
    return PopupMenuButton<MenuItemBuild>(
      onSelected: (MenuItemBuild result) {
        onPopupMenuActionSelected(c, result);
      },
      itemBuilder: (BuildContext context) =>
          items.map((r) => buildMenuItem(c, r)).toList(),
    );
  }

  Widget getPopupMenuActionListWidget(BuildContext c) {
    List<MenuItemBuild> items = getPopupMenuActionsList(c);
    return PopupMenuButton<MenuItemBuild>(
      onSelected: (MenuItemBuild result) {
        onPopupMenuActionSelected(c, result);
      },
      itemBuilder: (BuildContext context) =>
          items.map((r) => buildMenuItem(c, r)).toList(),
    );
  }

  ListTile buildMenuItemListTile(BuildContext context, MenuItemBuild e) {
    return ListTile(
      leading: Icon(e.icon),
      title: Text(e.title),
      onTap: () => onPopupMenuActionSelected(context, e),
    );
  }

  PopupMenuItem<MenuItemBuild> buildMenuItem(
          BuildContext context, MenuItemBuild e) =>
      PopupMenuItem(value: e, child: buildMenuItemListTile(context, e));

  void onMenuItemActionClickedView(BuildContext context, MenuItemBuild e) {
    onPopupMenuActionSelected(context, e);
  }

  void onPopupMenuActionSelected(
      BuildContext context, MenuItemBuild result) async {
    debugPrint("onPopupMenuActionSelected $result");
    if (result.icon == Icons.share) {
      try {
        await Share.share(
            subject: "sad", 'check out my website https://example.com');
        //  await FlutterShare.share(title: "title");
      } catch (e) {
        debugPrint("$e");
      }
    }
    if (result.icon == Icons.print) {
      debugPrint("onPopupMenuActionSelected $result");
      // if (SizeConfig.hasSecondScreen(context)) {
      //   context.read<ActionViewAbstractProvider>().changeCustomWidget(PdfPage(
      //         invoiceObj: this as PrintableMaster,
      //       ));
      //   return;
      // }
      // context.goNamed(printRouteName,
      //     extra: this,
      //     params: {"tableName": getTableNameApi()!, "id": iD.toString()});
      context.goNamed(printRouteName,
          params: {"tableName": getTableNameApi()!, "id": "$iD"}, extra: this);
      // Navigator.pushNamed(context, "/print", arguments: this);
    } else if (result.icon == Icons.edit) {
      // context.read<ActionViewAbstractProvider>().change(this as ViewAbstract);
      context.goNamed(editRouteName,
          params: {"tableName": getTableNameApi()!, "id": "$iD"},
          extra: (this as ViewAbstract).getCopyInstance());
    } else if (result.icon == Icons.view_agenda) {
      context.goNamed(viewRouteName,
          params: {"tableName": getTableNameApi()!, "id": "$iD"}, extra: this);
    }
  }
}
