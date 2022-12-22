import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListCardItemSelected<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  void Function(T obj)? onSelected;

  ListCardItemSelected({Key? key, required this.object, this.onSelected})
      : super(key: key);

  @override
  State<ListCardItemSelected> createState() => _ListCardItemSelected();
}

class _ListCardItemSelected<T extends ViewAbstract>
    extends State<ListCardItemSelected<T>> {
  late bool isSelected;
  @override
  void initState() {
    super.initState();
    // checkEnable();
    isSelected = widget.object.isSelected;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isSelected = widget.object.isSelected;
  }

  @override
  void didUpdateWidget(covariant ListCardItemSelected<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    isSelected = widget.object.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: isSelected,
      onChanged: (value) {
        setState(() {
          widget.object.isSelected = value ?? false;
        });
        if (widget.onSelected != null) {
          widget.onSelected!(widget.object);
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
