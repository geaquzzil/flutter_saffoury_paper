import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';

import '../text_bold.dart';

class DropdownStringListControllerListenerByIcon extends StatefulWidget {
  String hint;
  IconData icon;
  List<DropdownStringListItem?> list;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListenerByIcon(
      {Key? key,
      required this.hint,
      required this.list,
      required this.icon,
      required this.onSelected})
      : super(key: key) {
    list.insert(0, null);
  }

  @override
  State<DropdownStringListControllerListenerByIcon> createState() =>
      _DropdownStringListControllerListenerByIconState();
}

class _DropdownStringListControllerListenerByIconState
    extends State<DropdownStringListControllerListenerByIcon> {
  bool firstRun = true;
  DropdownStringListItem? lastSelected;
  PopupMenuItem<DropdownStringListItem> buildMenuItem(
          BuildContext context, DropdownStringListItem? e) =>
      PopupMenuItem<DropdownStringListItem>(
        value: e,
        enabled: e != null ? (e.enabled ?? true) : false,
        child: e != null && e.enabled == false
            ? Column(
                children: [
                  PopupMenuDivider(),
                  Text(e.label),
                  PopupMenuDivider()
                ],
              )
            : e == null
                ? Column(
                    children: [Text(widget.hint), PopupMenuDivider()],
                  )
                : Row(
                    children: [
                      if (e.icon != null)
                        Icon(
                          e.icon,
                          // color: Colors.black,
                          size: 20,
                        ),
                      const SizedBox(width: 12),
                      Text(e.label),
                      // TextBold(
                      //   text: "${widget.hint}: ${e.label}",
                      //   regex: e.label.toString(),
                      // )
                    ],
                  ),
      );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DropdownStringListItem>(
      tooltip: widget.hint,
      icon: Icon(
        lastSelected == null || firstRun
            ? widget.icon
            : lastSelected?.icon ?? widget.icon,
        color: firstRun || lastSelected == null
            ? null
            : Theme.of(context).colorScheme.primary,
      ),
      onSelected: (DropdownStringListItem? result) {
        widget.onSelected(result);
        // widget.viewAbstractEnum = result;
        setState(() {
          firstRun = false;
          lastSelected = result;
        });
      },
      // child: Text("Sda"),
      // initialValue: widget.viewAbstractEnum,
      itemBuilder: (BuildContext context) => widget.list
          .map(
            (e) => buildMenuItem(context, e),
          )
          .toList(),
    );
  }
}
