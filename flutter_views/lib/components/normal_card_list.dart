import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class NormalCardList<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  const NormalCardList({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  State<NormalCardList> createState() => _NormalCardListState();
}

class _NormalCardListState<T extends ViewAbstract>
    extends State<NormalCardList<T>> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.object.iD),
      direction: widget.object.getDismissibleDirection(),
      background: widget.object.getDismissibleBackground(context),
      secondaryBackground:
          widget.object.getDismissibleSecondaryBackground(context),
      onDismissed: (direction) =>
          widget.object.onCardDismissedView(context, direction),
      child: ListTile(
          onTap: () => widget.object.onCardClicked(context),
          onLongPress: () => widget.object.onCardLongClicked(context),
          title: (widget.object.getHeaderText(context)),
          subtitle: (widget.object.getSubtitleHeaderText(context)),
          leading: widget.object.getCardLeading(context),
          trailing: widget.object.getPopupMenuActionListWidget(context)),
    );
  }
}
