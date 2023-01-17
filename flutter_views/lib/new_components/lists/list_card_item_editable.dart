import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_dialog.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';

import '../../new_components/editables/editable_widget.dart';
import '../../providers/cart/cart_provider.dart';

class ListCardItemEditable<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  final int index;
  void Function(T object) onDelete;
  void Function(T object) onUpdate;
  bool useDialog;
  ListCardItemEditable(
      {Key? key,
      required this.index,
      required this.object,
      required this.onDelete,
      required this.onUpdate,
      this.useDialog = true})
      : super(key: key);

  @override
  State<ListCardItemEditable> createState() => _ListCardItemEditable();
}

class _ListCardItemEditable<T extends ViewAbstract>
    extends State<ListCardItemEditable<T>> {
  bool isExpanded = false;
  late ViewAbstract validated;
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
      onDismissed: (direction) {
        debugPrint(
            "getListableInterface  from card index => ${widget.index} is Removed");
        widget.onDelete(widget.object);
      },
      child:
          widget.useDialog ? getListTile(context) : getExpansionTile(context),
    );
  }

  Widget getListTile(BuildContext context) {
    return ListTile(
      title: (validated.getMainHeaderText(context)),
      subtitle: (validated.getMainSubtitleHeaderText(context)),
      leading: validated.getCardLeading(context),
      trailing: validated.getPopupMenuActionListWidget(context),
      onTap: () {
        getEditDialog(context);
      },
    );
  }

  Future<void> getEditDialog(BuildContext context) async {
    await showFullScreenDialogExt<ViewAbstract?>(
        anchorPoint: const Offset(1000, 1000),
        context: context,
        builder: (p0) {
          return BaseEditDialog(
            viewAbstract: validated,
          );
        }).then((value) {
      {
        if (value != null) {
          widget.onUpdate(value as T);
          setState(() {
            validated = value;
          });
        }
        debugPrint("getEditDialog result $value");
      }
      ;
    });
  }

  ExpansionTileCustom getExpansionTile(BuildContext context) {
    return ExpansionTileCustom(
      title: (validated.getMainHeaderText(context)),
      subtitle: (validated.getMainSubtitleHeaderText(context)),
      leading: validated.getCardLeading(context),
      trailing: validated.getPopupMenuActionListWidget(context),
      hasError: validated == null,
      canExpand: () => true,
      children: [
        BaseEditWidget(
            viewAbstract: validated,
            isTheFirst: true,
            isRequiredSubViewAbstract: false,
            onValidate: (viewAbstract) {
              if (viewAbstract != null) {
                widget.onUpdate(validated as T);
                setState(() {
                  validated = viewAbstract;
                });
              }
            })
      ],
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
