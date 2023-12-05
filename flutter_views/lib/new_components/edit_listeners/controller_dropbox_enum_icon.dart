import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

import '../text_bold.dart';

class DropdownEnumControllerListenerByIcon<T extends ViewAbstractEnum>
    extends StatefulWidget {
  T viewAbstractEnum;
  bool showSelectedValueBeside;
  T? initialValue;
  void Function(T? object) onSelected;

  DropdownEnumControllerListenerByIcon({
    super.key,
    this.showSelectedValueBeside = true,
    required this.viewAbstractEnum,
    this.initialValue,
    required this.onSelected,
  });

  @override
  State<DropdownEnumControllerListenerByIcon<T>> createState() =>
      _DropdownEnumControllerListenerByIconState<T>();
}

class _DropdownEnumControllerListenerByIconState<T extends ViewAbstractEnum>
    extends State<DropdownEnumControllerListenerByIcon<T>> {
  late bool firstRun;
  T? selectedValue;

  @override
  void initState() {
    firstRun = true;
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (selectedValue != null) {
      if (selectedValue.runtimeType == widget.viewAbstractEnum.runtimeType) {
        firstRun = false;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget pop = PopupMenuButton<T>(
      tooltip: widget.viewAbstractEnum.getFieldLabelString(
          context, selectedValue ?? widget.viewAbstractEnum),
      icon: Icon(
        selectedValue == null
            ? widget.viewAbstractEnum.getMainIconData()
            : widget.viewAbstractEnum
                .getFieldLabelIconData(context, selectedValue),
        color: selectedValue == null
            ? null
            : Theme.of(context).colorScheme.primary,
      ),
      onSelected: (T result) {
        widget.onSelected(result);
        widget.viewAbstractEnum = result;
        setState(() {
          selectedValue = result;
          firstRun = false;
        });
      },
      // child: Text("Sda"),
      initialValue: selectedValue ?? widget.viewAbstractEnum,
      itemBuilder: (BuildContext context) => widget.viewAbstractEnum
          .getValues()
          .map(
            (e) => buildMenuItem(context, e),
          )
          .toList(),
    );
    if (widget.showSelectedValueBeside && selectedValue != null) {
      return Row(
        children: [
          FadeInLeft(
              key: UniqueKey(),
              duration: Duration(milliseconds: 500),
              child: Text(
                selectedValue!.getFieldLabelString(context, selectedValue),
                style: Theme.of(context).textTheme.bodySmall,
              )),
          pop
        ],
      );
    }
    return pop;
  }

  CustomPopupMenuItem<T> buildMenuItem(BuildContext context, T e) {
    debugPrint(
        "buildMenuItem  current $e initailValue viewAbstractEnum ${widget.viewAbstractEnum}");
    return CustomPopupMenuItem<T>(
      value: e,
      color: selectedValue == e ? Theme.of(context).highlightColor : null,
      child: Row(
        children: [
          Icon(
            e.getFieldLabelIconData(context, e),
          ),
          const SizedBox(width: 12),
          Text(e.getFieldLabelString(context, e)),
        ],
      ),
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color? color;

  const CustomPopupMenuItem({
    Key? key,
    T? value,
    bool enabled = true,
    Widget? child,
    this.color,
  }) : super(key: key, value: value, enabled: enabled, child: child);

  @override
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: super.build(context),
    );
  }
}
