import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
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
        key: Key(widget.object.iD.toString()),
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
            title: (widget.object.getMainHeaderText(context)),
            subtitle: (widget.object.getMainSubtitleHeaderText(context)),
            leading: widget.object.getCardLeading(context),
            trailing: widget.object.getPopupMenuActionListWidget(context)),
      ),
    );
  }
}
