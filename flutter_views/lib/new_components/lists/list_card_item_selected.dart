import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListCardItemSelected<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  bool? isSelected;
  void Function(T obj, bool selected)? onSelected;

  ListCardItemSelected(
      {super.key, required this.object, this.onSelected, this.isSelected});

  @override
  State<ListCardItemSelected> createState() => _ListCardItemSelected();
}

class _ListCardItemSelected<T extends ViewAbstract>
    extends State<ListCardItemSelected<T>>  {
  late bool isSelected;
  @override
  void initState() {
    super.initState();
    // checkEnable();
    isSelected = widget.isSelected ?? widget.object.isSelected;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isSelected = widget.isSelected ?? widget.object.isSelected;
  }

  @override
  void didUpdateWidget(covariant ListCardItemSelected<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    isSelected = widget.isSelected ?? widget.object.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: isSelected,
      onChanged: (value) {
        debugPrint("CheckboxListTile changed  => $value");
        if ((widget.object.getParnet
                    ?.hasPermissionFromParentSelectItem(context, widget.object) ??
                true) ==
            false ) return;
        setState(() {
          widget.object.isSelected = value ?? false;
          isSelected = value ?? false;
        });
        if (widget.onSelected != null) {
          widget.onSelected!(widget.object, value ?? false);
        }
      },
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.onSecondary,
      // onTap: () => widget.object.onCardClicked(context),
      // onLongPress: () => widget.object.onCardLongClicked(context),
      title: ListTile(
          subtitle: (widget.object.getMainSubtitleHeaderText(context)),
          leading: widget.object.getCardLeading(context),
          title: (widget.object.getMainHeaderText(context))),
    );
  }
}
