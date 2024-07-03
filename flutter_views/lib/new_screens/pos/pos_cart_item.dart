import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/web/views/web_view_details.dart';
import 'package:provider/provider.dart';

import '../../providers/cart/cart_provider.dart';

class POSListCardItem<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  const POSListCardItem({
    super.key,
    required this.object,
  });

  @override
  State<POSListCardItem> createState() => _POSListCardItem();
}

class _POSListCardItem<T extends ViewAbstract>
    extends State<POSListCardItem<T>> {
  bool isExpanded = false;
  ViewAbstract? validated;
  @override
  void initState() {
    super.initState();
    // checkEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: dismissBackground(context),
      secondaryBackground: dismissBackground(context),
      onDismissed: (direction) => context
          .read<CartProvider>()
          .onCartItemRemoved(
              context, widget.object as CartableInvoiceDetailsInterface),
      child: ExpansionTileCustom(
        useLeadingOutSideCard: false,
        // trailing: kIsWeb
        //     ? IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        //     : null,
        title: (widget.object.getMainHeaderText(context)),
        subtitle: (widget.object.getMainSubtitleHeaderText(context)),

        // isThreeLine: true,

        leading: widget.object.getCardLeading(context),
        children: [
          WebViewDetails(
            viewAbstract: widget.object,
          ),
        ],
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
