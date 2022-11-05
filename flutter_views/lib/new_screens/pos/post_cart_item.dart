import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/cart/cart_provider.dart';

class POSListCardItem<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  const POSListCardItem({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  State<POSListCardItem> createState() => _POSListCardItem();
}

class _POSListCardItem<T extends ViewAbstract>
    extends State<POSListCardItem<T>> {
  @override
  void initState() {
    super.initState();
    // checkEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        background: dismissBackground(context),
        secondaryBackground: dismissBackground(context),
        onDismissed: (direction) => context
            .read<CartProvider>()
            .onCartItemRemoved(
                context, widget.object as CartableInvoiceDetailsInterface),
        child: ListTile(
            selectedTileColor: Theme.of(context).colorScheme.onSecondary,
            onTap: () => widget.object.onCardClicked(context),
            onLongPress: () => widget.object.onCardLongClicked(context),
            title: (widget.object.getMainHeaderText(context)),
            subtitle: (widget.object.getMainSubtitleHeaderText(context)),
            leading: widget.object.getCardLeadingWithSelecedBorder(context),
            trailing: widget.object.getPopupMenuActionListWidget(context)),
      ),
    );
  }

  Container dismissBackground(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.error,
      child: Icon(
        Icons.delete_outlined,
        color: Theme.of(context).colorScheme.onError,
      ),
    );
  }
}
