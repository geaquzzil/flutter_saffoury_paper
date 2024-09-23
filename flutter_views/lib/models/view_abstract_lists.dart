// ignore_for_file: use_build_context_synchronously

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_components/tow_icons_with_badge.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import '../providers/actions/action_viewabstract_provider.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: getCardLeadingImage(context, addBottomWidget: addBottomWidget));
  }

  Widget getHeroTag(
      {required BuildContext context,
      required Widget child,
      String? addCustomHeroTag}) {
    return child;
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
        child: getCardLeadingImage(context, addBottomWidget: addBottomWidget));
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

  Widget getCachedImage(BuildContext context, {String? url}) {
    return Container(
        width: 60,
        height: 100,
        // width: 60,
        // height: 60,
        // width: 150,
        // height: 100,
        decoration: BoxDecoration(
          // color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),

          image: url == null
              ? null
              : DecorationImage(
                  image: FastCachedImageProvider(url), fit: BoxFit.cover),
          // color: url == null ? null : color?.darkVibrantColor?.color,
          // borderRadius: const BorderRadius.all(Radius.circular(20))
        ));
    // return Image.network(url);
    //TODO: this is for leading card
    // return CachedNetworkImage(
    //   color: Theme.of(context).colorScheme.onBackground,
    //   imageUrl: url,
    //   imageBuilder: (context, imageProvider) => Container(
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: Theme.of(context).colorScheme.onBackground,
    //       image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
    //     ),
    //   ),
    //   placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => Icon(getMainIconData()),
    // );
    //todo this is the old method for normal
    // Widget image = CachedNetworkImage(
    //   color: Theme.of(context).colorScheme.onBackground,
    //   imageUrl: imageUrl,
    //   imageBuilder: (context, imageProvider) => Container(
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).colorScheme.onBackground,
    //       image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
    //     ),
    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
    //       child: Container(
    //         decoration: BoxDecoration(
    //             color:
    //                 Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)),
    //       ),
    //     ),
    //   ),
    //   placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => Icon(getMainIconData()),
    // );

    return FastCachedImage(
      url: url ?? "",
      fit: BoxFit.cover,
      width: 60,
      height: 60,

      // color: Theme.of(context).colorScheme.onBackground,
      loadingBuilder: (context, url) => SkeletonAvatar(),
      errorBuilder: (context, url, error) => Icon(getMainIconData()),
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

    Widget image = getCachedImage(context, url: imageUrl);

    if (iconOnButton != null) {
      return TowIcons(
        largChild: image,
        smallIcon: iconOnButton,
      );
    }
    return image;
  }

  Widget getImageIfNoUrl() {
    return Icon(getMainIconData());
  }

  Widget getCardLeadingImage(BuildContext context,
      {bool? isSelected, bool addBottomWidget = true}) {
    String? imageUrl = getImageUrl(context);
    if (imageUrl == null) {
      return Icon(getMainIconData());
    }
    IconData? iconOnButton =
        addBottomWidget ? getCardLeadingBottomIcon() : null;
    Widget image = getCachedImage(context, url: imageUrl);
    if (iconOnButton != null) {
      return TowIconsWithTextBadge(
        largChild: image,
        text: "WASTED",
      );
    }
    return image;
  }

  MenuItemBuild getMenuItemSelect(BuildContext context) {
    return MenuItemBuild(
      AppLocalizations.of(context)!.selectItems,
      Icons.list,
      '/print',
    );
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

  List<MenuItemBuild> getPopupMenuActionsEdit(BuildContext context,
      {SliverApiWithStaticMixin? state}) {
    return [
      if (state != null) getMenuItemSelect(context),
      if (hasPermissionPrint(context)) getMenuItemPrint(context),
      if (hasPermissionShare(context)) getMenuItemShare(context),
      if (hasPermissionEdit(context)) getMenuItemEdit(context),
    ];
  }

  List<MenuItemBuild> getPopupMenuActionsList(BuildContext context,
      {SliverApiWithStaticMixin? state}) {
    return [
      if (state != null) getMenuItemSelect(context),
      if (hasPermissionShare(context)) getMenuItemShare(context),
      if (hasPermissionPrint(context)) getMenuItemPrint(context),
      if (hasPermissionEdit(context)) getMenuItemEdit(context),
      if (hasPermissionView(context)) getMenuItemView(context),
    ];
  }

  @Deprecated("Not future anymore")
  Widget onFutureAllPopupMenuLoaded(BuildContext context, ServerActions action,
      {required Widget Function(List<MenuItemBuild>) onPopupMenuListLoaded,
      SliverApiWithStaticMixin? state}) {
    List<MenuItemBuild> list = action == ServerActions.edit
        ? getPopupMenuActionsEdit(context, state: state)
        : getPopupMenuActionsList(context, state: state);
    return onPopupMenuListLoaded(list);
  }

  Widget getPopupMenuActionWidget(BuildContext c, ServerActions action,
      {SliverApiWithStaticMixin? state}) {
    //TODO for divider use PopupMenuDivider()
    List<MenuItemBuild> items = action == ServerActions.edit
        ? getPopupMenuActionsEdit(c)
        : getPopupMenuActionsList(c);
    return PopupMenuButton<MenuItemBuild>(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (MenuItemBuild result) {
        onPopupMenuActionSelected(c, result, state: state);
      },
      itemBuilder: (BuildContext context) =>
          items.map((r) => buildMenuItem(c, r)).toList(),
    );
  }

  Widget getPopupMenuActionListWidget(BuildContext c,
      {SliverApiWithStaticMixin? state}) {
    List<MenuItemBuild> items = getPopupMenuActionsList(c);
    return PopupMenuButton<MenuItemBuild>(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onSelected: (MenuItemBuild result) {
        onPopupMenuActionSelected(c, result, state: state);
      },
      itemBuilder: (BuildContext context) =>
          items.map((r) => buildMenuItem(c, r)).toList(),
    );
  }

  ListTile buildMenuItemListTile(BuildContext context, MenuItemBuild e,
      {SliverApiWithStaticMixin? state}) {
    return ListTile(
      leading: Icon(e.icon),
      title: Text(e.title),
      onTap: () {
        Navigator.of(context).pop();
        onPopupMenuActionSelected(context, e, state: state);
      },
    );
  }

  PopupMenuItem<MenuItemBuild> buildMenuItem(
          BuildContext context, MenuItemBuild e) =>
      PopupMenuItem(value: e, child: buildMenuItemListTile(context, e));

  void onMenuItemActionClickedView(BuildContext context, MenuItemBuild e,
      {SliverApiWithStaticMixin? state}) {
    onPopupMenuActionSelected(context, e, state: state);
  }

  void onPopupMenuActionSelected(BuildContext context, MenuItemBuild result,
      {ServerActions? action, SliverApiWithStaticMixin? state}) async {
    debugPrint("onPopupMenuActionSelected $result");

    if (result.icon == Icons.share) {
      sharePage(context, action: action);
    } else if (result.icon == Icons.print) {
      printPage(context);
    } else if (result.icon == Icons.edit) {
      editPage(context);
    } else if (result.icon == Icons.view_agenda) {
      viewPage(context);
    } else if (result.icon == Icons.list) {
      state?.toggleSelectedMood();
    }
  }
}
