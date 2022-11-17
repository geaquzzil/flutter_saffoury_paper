import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

import '../../new_components/editables/editable_widget.dart';
import '../../providers/cart/cart_provider.dart';

class ListCardItemEditable<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  const ListCardItemEditable({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  State<ListCardItemEditable> createState() => _ListCardItemEditable();
}

class _ListCardItemEditable<T extends ViewAbstract>
    extends State<ListCardItemEditable<T>> {
  bool isExpanded = false;
  ViewAbstract? validated;
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
      child: Container(
        decoration: validated != null
            ? null
            : BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border(
                left: BorderSide(
                  //                   <--- left side
                  color: Theme.of(context).colorScheme.onError,
                  width: 5.0,
                ),
              )),
        child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: ((value) {
              if (value) {
                setState(() {
                  isExpanded = value;
                });
              }
            }),
            // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
            // onTap: () => widget.object.onCardClicked(context),
            // onLongPress: () => widget.object.onCardLongClicked(context),
            title: (widget.object.getMainHeaderText(context)),
            subtitle: (widget.object.getMainSubtitleHeaderText(context)),
            // isThreeLine: true,

            leading: widget.object.getCardLeading(context),
            trailing: widget.object.getPopupMenuActionListWidget(context),

            // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
            // onTap: () => widget.object.onCardClicked(context),
            // onLongPress: () => widget.object.onCardLongClicked(context),
            children: [
              EditableWidget(
                  viewAbstract: widget.object,
                  onValidated: (viewAbstract) {
                    setState(() {
                      validated = viewAbstract;
                    });

                    context.read<CartProvider>().onCartItemChanged(context, -1,
                        viewAbstract as CartableInvoiceDetailsInterface);
                  })
            ]),
      ),
    ));
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
