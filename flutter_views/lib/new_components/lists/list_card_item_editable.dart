import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

import '../../new_components/editables/editable_widget.dart';
import '../../providers/cart/cart_provider.dart';

class ListCardItemEditable<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  void Function(T object) onDelete;
  void Function(T object) onUpdate;
  ListCardItemEditable(
      {Key? key,
      required this.object,
      required this.onDelete,
      required this.onUpdate})
      : super(key: key);

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
    validated = widget.object;
    // checkEnable();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: dismissBackground(context),
      secondaryBackground: dismissBackground(context),
      onDismissed: (direction) => widget.onDelete(widget.object),
      child: ExpansionTileCustom(
        title: (widget.object.getMainHeaderText(context)),
        subtitle: (widget.object.getMainSubtitleHeaderText(context)),
        leading: widget.object.getCardLeading(context),
        trailing: widget.object.getPopupMenuActionListWidget(context),
        hasError: validated == null,
        canExpand: () => true,
        children: [
          BaseEditWidget(
              viewAbstract: widget.object,
              isTheFirst: true,
              isRequiredSubViewAbstract: false,
              onValidate: (viewAbstract) {
                widget.onUpdate(validated as T);
                setState(() {
                  validated = viewAbstract;
                });
              })
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
