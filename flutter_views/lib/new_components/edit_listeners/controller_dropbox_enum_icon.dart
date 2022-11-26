import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

import '../text_bold.dart';

class DropdownEnumControllerListenerByIcon<T extends ViewAbstractEnum>
    extends StatefulWidget {
  T viewAbstractEnum;

  void Function(T? object) onSelected;

  DropdownEnumControllerListenerByIcon({
    Key? key,
    required this.viewAbstractEnum,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<DropdownEnumControllerListenerByIcon<T>> createState() =>
      _DropdownEnumControllerListenerByIconState<T>();
}

class _DropdownEnumControllerListenerByIconState<T extends ViewAbstractEnum>
    extends State<DropdownEnumControllerListenerByIcon<T>> {
  bool firstRun = true;
  PopupMenuItem<T> buildMenuItem(BuildContext context, T e) => PopupMenuItem<T>(
        value: e,
        child: Row(
          children: [
            Icon(
              e.getFieldLabelIconData(context, e),
              // color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(e.getFieldLabelString(context, e)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: widget.viewAbstractEnum.getMainLabelText(context),
      icon: Icon(
        firstRun
            ? widget.viewAbstractEnum.getMainIconData()
            : widget.viewAbstractEnum
                .getFieldLabelIconData(context, widget.viewAbstractEnum),
        color: firstRun ? null : Theme.of(context).colorScheme.primary,
      ),
      onSelected: (T result) {
        widget.onSelected(result);
        widget.viewAbstractEnum = result;
        setState(() {
          firstRun = false;
        });
      },
      // child: Text("Sda"),
      initialValue: widget.viewAbstractEnum,
      itemBuilder: (BuildContext context) =>
          widget.viewAbstractEnum
              .getValues()
              .map(
                (e) => buildMenuItem(context, e),
              )
              .toList() ??
          [],
    );
  }
}
