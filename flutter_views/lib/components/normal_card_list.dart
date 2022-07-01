import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/action_view_abstract_provider.dart';
import 'package:flutter_view_controller/providers/cart_provider.dart';
import 'package:provider/provider.dart';

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
  bool isEnable = true;

  Future<void> checkEnable() async {
    bool result = await context.watch<CartProvider>().hasItem(widget.object);
    setState(() => isEnable = result); // set the local variable
  }

  @override
  void initState() {
    super.initState();
    // checkEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: Key(widget.object.iD),
        direction: widget.object.getDismissibleDirection(),
        background: widget.object.getDismissibleBackground(context),
        secondaryBackground:
            widget.object.getDismissibleSecondaryBackground(context),
        onDismissed: (direction) =>
            widget.object.onCardDismissedView(context, direction),
        child: ListTile(
            enabled: isEnable,
            selected: context
                    .watch<ActionViewAbstractProvider>()
                    .getObject
                    ?.isEquals(widget.object) ??
                false,
            onTap: () => widget.object.onCardClicked(context),
            onLongPress: () => widget.object.onCardLongClicked(context),
            title: (widget.object.getHeaderText(context)),
            subtitle: (widget.object.getSubtitleHeaderText(context)),
            leading: widget.object.getCardLeading(context),
            trailing: widget.object.getPopupMenuActionListWidget(context)),
      ),
    );
  }
}
