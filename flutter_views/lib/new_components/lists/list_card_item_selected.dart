import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListCardItemSelected<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  bool? isSelected;
  final bool Function(T? object)? isSelectForListTile;
  final Function(T object)? onClick;
  void Function(T obj, bool selected)? onSelected;
  final String? searchQuery;

  ListCardItemSelected({
    super.key,
    required this.object,
    this.onSelected,
    this.onClick,
    this.isSelectForListTile,
    this.isSelected,
    this.searchQuery,
  });

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
    debugPrint("ListCardItem iis _ListCardItemSelected");
    // return Text("Saad");

    return CheckboxListTile.adaptive(
      controlAffinity: ListTileControlAffinity.leading,
      value: isSelected,
      onChanged: (value) {
        debugPrint("CheckboxListTile changed  => $value");
        if ((widget.object.getParent?.hasPermissionFromParentSelectItem(
                  context,
                  widget.object,
                ) ??
                true) ==
            false)
          return;
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
        selected: widget.isSelectForListTile?.call(widget.object) ?? false,
        onTap: () {
          widget.onClick?.call(widget.object);
        },
        subtitle: (widget.object.getMainSubtitleHeaderText(
          context,
          searchQuery: widget.searchQuery,
        )),
        leading: widget.object.getCardLeading(context),
        title: (widget.object.getMainHeaderText(
          context,
          searchQuery: widget.searchQuery,
        )),
      ),
    );
  }
}
