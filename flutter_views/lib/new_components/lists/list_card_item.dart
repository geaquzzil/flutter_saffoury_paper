import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class ListCardItemWeb<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  void Function()? onTap;
  void Function()? onLongTap;

  ListCardItemWeb({
    Key? key,
    required this.object,
    this.onTap,
    this.onLongTap,
  }) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: getListTile(false, context),
    );
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
  bool selectionMood;
  ValueNotifier<ViewAbstract?>? onSelectedItem;
  ListCardItem({
    Key? key,
    this.listState,
    this.selectionMood = false,
    this.onSelectedItem,
    required this.object,
  }) : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: object.getDismissibleDirection(),
        background: object.getDismissibleBackground(context),
        secondaryBackground: object.getDismissibleSecondaryBackground(context),
        onDismissed: (direction) =>
            object.onCardDismissedView(context, direction),
        child: getCard());
  }

  Widget getCard() {
    if (onSelectedItem != null) {
      return ValueListenableBuilder(
        valueListenable: onSelectedItem!,
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
    return ListTile(
        selected: isSelected,
        // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
        onTap: () {
          if (onSelectedItem != null) {
            onSelectedItem!.value = object;
          } else {
            object.onCardClicked(context);
          }
        },
        onLongPress: () {
          object.onCardLongClicked(context, clickedWidget: key as GlobalKey);
        },
        title: (object.getMainHeaderText(context)),
        subtitle: (object.getMainSubtitleHeaderText(context)),
        leading: object.getCardLeading(context),
        trailing: object.getCardTrailing(context));
  }
}
