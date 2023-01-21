import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class ListCardItem<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  Key? listState;
  bool selectionMood;
  ListCardItem({
    Key? key,
    this.listState,
    this.selectionMood = false,
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
        child: Selector<ActionViewAbstractProvider, ViewAbstract?>(
          builder: (context, value, child) {
            bool isLargeScreen = SizeConfig.isLargeScreen(context);
            bool isSelected =
                (value?.isEquals(object) ?? false) && isLargeScreen;
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
        ));
  }

  Widget getListTile(bool isSelected, BuildContext context) {
    return ListTile(
        selected: isSelected,
        // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
        onTap: () => object.onCardClicked(context),
        onLongPress: () {
          object.onCardLongClicked(context, clickedWidget: key as GlobalKey);
        },
        title: (object.getMainHeaderText(context)),
        subtitle: (object.getMainSubtitleHeaderText(context)),
        leading: object.getCardLeading(context),
        trailing: object.getCardTrailing(context));
  }
}
