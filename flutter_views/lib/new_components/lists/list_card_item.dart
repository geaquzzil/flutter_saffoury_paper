import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:provider/provider.dart';

class ListCardItem<T extends ViewAbstract> extends StatefulWidget {
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
  State<ListCardItem> createState() => _ListCardItemState();
}

class _ListCardItemState<T extends ViewAbstract>
    extends State<ListCardItem<T>> {
  @override
  void initState() {
    super.initState();
    // checkEnable();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = context
            .watch<ActionViewAbstractProvider>()
            .getObject
            ?.isEquals(widget.object) ??
        false;
    return Dismissible(
      key: UniqueKey(),
      direction: widget.object.getDismissibleDirection(),
      background: widget.object.getDismissibleBackground(context),
      secondaryBackground:
          widget.object.getDismissibleSecondaryBackground(context),
      onDismissed: (direction) =>
          widget.object.onCardDismissedView(context, direction),
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

  ListTile getListTile(bool isSelected, BuildContext context) {
    return ListTile(
        selected: isSelected,
        selectedTileColor: Theme.of(context).colorScheme.onSecondary,
        onTap: () => widget.object.onCardClicked(context),
        onLongPress: () {
          (widget.listState as GlobalKey<ListApiMasterState>)
              .currentState
              ?.toggleSelectMood();
          context.read<ListActionsProvider>().toggleSelectMood();
          widget.object.onCardLongClicked(context);
        },
        title: (widget.object.getMainHeaderText(context)),
        subtitle: (widget.object.getMainSubtitleHeaderText(context)),
        leading: widget.object.getCardLeading(context),
        trailing: widget.object.getPopupMenuActionListWidget(context));
  }
}
