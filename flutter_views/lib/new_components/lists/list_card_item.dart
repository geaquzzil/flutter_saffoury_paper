import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = context
            .watch<ActionViewAbstractProvider>()
            .getObject
            ?.isEquals(object) ??
        false;
    return Dismissible(
      key: UniqueKey(),
      direction: object.getDismissibleDirection(),
      background: object.getDismissibleBackground(context),
      secondaryBackground:
          object.getDismissibleSecondaryBackground(context),
      onDismissed: (direction) =>
          object.onCardDismissedView(context, direction),
      child: isSelected
          ? ClippedCard(
              borderSide: BorderSideColor.END,
              elevation: 0,
              color: Theme.of(context).colorScheme.primary,
              child: getListTile(isSelected, context),
            )
          : getListTile(isSelected, context),
    );
  }

  Widget getListTile(bool isSelected, BuildContext context) {
    return ListTile(
        selected: isSelected,
        selectedTileColor: Theme.of(context).colorScheme.onSecondary,
        onTap: () => object.onCardClicked(context),
        onLongPress: () {
          (listState as GlobalKey<ListApiMasterState>)
              .currentState
              ?.toggleSelectMood();
          context.read<ListActionsProvider>().toggleSelectMood();
          object.onCardLongClicked(context);
        },
        title: (object.getMainHeaderText(context)),
        subtitle: (object.getMainSubtitleHeaderText(context)),
        leading: object.getCardLeading(context),
        trailing: object.getPopupMenuActionListWidget(context));
  }
}
