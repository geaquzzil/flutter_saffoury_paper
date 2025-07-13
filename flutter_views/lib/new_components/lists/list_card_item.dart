import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class ListCardItemWeb<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  void Function()? onTap;
  void Function()? onLongTap;

  ListCardItemWeb({Key? key, required this.object, this.onTap, this.onLongTap})
    : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Card(child: getListTile(false, context));
  }

  Widget getListTile(bool isSelected, BuildContext context) {
    return ListTile(
      selected: isSelected,
      // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
      onTap: onTap,
      onLongPress: onLongTap,
      title: (object.getWebListTileItemTitle(context)),
      subtitle: (object.getWebListTileItemSubtitle(context)),
      leading: object.getWebListTileItemLeading(context),
      // trailing: object.getCardTrailing(context)
    );
  }
}

class ListCardItem<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  Key? listState;

  SliverApiWithStaticMixin? state;
  @Deprecated("Use glbal key")
  ValueNotifier<ListToDetailsSecoundPaneHelper?>? onSelectedItem;

  final SecoundPaneHelperWithParentValueNotifier? secondPaneHelper;
  Function(T object)? onClick;
  bool? isSelected;
  String? searchQuery;

  ListCardItem({
    Key? key,
    this.listState,
    this.onSelectedItem,
    this.onClick,
    this.searchQuery,
    this.secondPaneHelper,
    this.state,
    this.isSelected,
    required this.object,
  }) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    debugPrint("ListCardItem iis ListCardItem");
    if (isLargeScreen(context)) {
      return _getCardNew(context);
    }
    return Dismissible(
      key: UniqueKey(),
      direction: object.getDismissibleDirection(),
      background: object.getDismissibleBackground(context),
      secondaryBackground: object.getDismissibleSecondaryBackground(context),
      onDismissed: (direction) =>
          object.onCardDismissedView(context, direction),
      child: _getCardNew(context),
    );
  }

  Widget _getCardNew(BuildContext context) {
    return getListTile(isSelected ?? false, context);
  }

  Widget getCard() {
    if (onSelectedItem != null) {
      return ValueListenableBuilder(
        valueListenable: onSelectedItem!,
        builder: (context, value, child) {
          bool isLargeScreen = SizeConfig.isLargeScreen(context);
          bool isSelected =
              (value?.viewAbstract?.isEquals(object) ?? false) && isLargeScreen;
          return isSelected
              ? CardCorner(
                  key: UniqueKey(),
                  // color: Theme.of(context).highlightColor,
                  // borderSide: BorderSideColor.END,
                  // elevation: 0,
                  // color: Theme.of(context).colorScheme.primary,
                  child: getListTile(isSelected, context),
                )
              : getListTile(isSelected, context);
        },
      );
    }
    return Selector<ActionViewAbstractProvider, ViewAbstract?>(
      builder: (context, value, child) {
        bool isLargeScreen = SizeConfig.isLargeScreen(context);
        bool isSelected = (value?.isEquals(object) ?? false) && isLargeScreen;
        return isSelected
            ? CardCorner(
                key: UniqueKey(),
                // color: Theme.of(context).highlightColor,
                // borderSide: BorderSideColor.END,
                // elevation: 0,
                // color: Theme.of(context).colorScheme.primary,
                child: getListTile(isSelected, context),
              )
            : getListTile(isSelected, context);
      },
      selector: (p0, p1) => p1.getObject,
    );
  }

  Widget getListTile(bool isSelected, BuildContext context) {
    // if (!isDesktopPlatform()) {
    //   return ExpansionTile();
    // }
    bool hasThreeLine = object.getMainSubtitleHeaderText(context) is Column;
    return ListTile(
      selected: isSelected,
      // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
      onTap: () {
        if (onSelectedItem != null) {
          onSelectedItem!.value = ListToDetailsSecoundPaneHelper(
            actionTitle: AppLocalizations.of(context)!.view,
            action: ServerActions.view,
            viewAbstract: object,
          );
        } else if (onClick != null) {
          onClick!.call(object);
        } else {
          object.onCardClicked(context);
        }
      },
      onLongPress: () {
        object.onCardLongClicked(
          context,
          clickedWidget: key as GlobalKey,
          state: state,
        );
      },
      title: (object.getMainHeaderText(context,searchQuery: searchQuery)),

      // contentPadding: EdgeInsets.all(20),
      // minVerticalPadding: 4,
      // dense: false,
      subtitle: (object.getMainSubtitleHeaderText(context,searchQuery: searchQuery)),
      // isThreeLine: hasThreeLine,
      leading: object.getCardLeading(context),
      trailing: object.getCardTrailing(
        context,
        secPaneHelper: secondPaneHelper,
      ),
    );
  }
}
