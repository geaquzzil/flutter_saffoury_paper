import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class ListCardItem<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  const ListCardItem({
    Key? key,
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
      child: Material(
        elevation: isSelected ? 20 : 0,
        // shadowColor: Colors.lightBlue,
        child: Padding(
          padding: isSelected ? const EdgeInsets.all(4.0) : const EdgeInsets.all(0),
          child: Ink(
            color: isSelected ? Colors.white : null,
            child: ListTile(
                selected: isSelected,
                onTap: () => widget.object.onCardClicked(context),
                onLongPress: () => widget.object.onCardLongClicked(context),
                title: (widget.object.getMainHeaderText(context)),
                subtitle: (widget.object.getMainSubtitleHeaderText(context)),
                leading: widget.object.getCardLeadingWithSelecedBorder(context),
                trailing: widget.object.getPopupMenuActionListWidget(context)),
          ),
        ),
      ),
    );
  }
}
