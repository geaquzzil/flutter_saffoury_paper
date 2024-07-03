import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_dialog.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';

class ListCardItemEditable<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  final int index;
  void Function(T object) onDelete;
  void Function(T object) onUpdate;
  bool useDialog;
  GlobalKey<FormBuilderState>? formKey;
  ListCardItemEditable(
      {super.key,
      required this.index,
      required this.object,
      required this.onDelete,
      this.formKey,
      required this.onUpdate,
      this.useDialog = true});

  @override
  State<ListCardItemEditable> createState() => ListCardItemEditableState();
}

class ListCardItemEditableState<T extends ViewAbstract>
    extends State<ListCardItemEditable<T>> {
  GlobalKey<FormBuilderState>? formKey;
  bool isExpanded = false;
  late ViewAbstract validated;

  @override
  void initState() {
    super.initState();
    validated = widget.object;
    formKey = widget.formKey ?? GlobalKey<FormBuilderState>();

    // checkEnable();
  }

  // bool isValidated() {
  //   debugPrint("listCardItemEditableState isValidate");
  //   formKey!.currentState?.validate();
  //   return true;
  // }

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
    return ClippedCard(
        borderSide: BorderSideColor.START,
        color: isValidated()
            ? Colors.transparent
            : Theme.of(context).colorScheme.error,
        child: ListTile(
          title: (validated.getMainHeaderText(context)),
          subtitle: (validated.getMainSubtitleHeaderText(context)),
          leading: validated.getCardLeading(context),
          trailing: validated.getPopupMenuActionListWidget(context),
          onTap: () {
            getEditDialog(context);
          },
        ));
  }

  bool isValidated() {
    return widget.object.onManuallyValidate(context) != null;
  }

  Future<void> getEditDialog(BuildContext context) async {
    await showFullScreenDialogExt<ViewAbstract?>(
        anchorPoint: const Offset(1000, 1000),
        context: context,
        builder: (p0) {
          return BaseEditDialog(
            disableCheckEnableFromParent: true,
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
            disableCheckEnableFromParent: true,
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
