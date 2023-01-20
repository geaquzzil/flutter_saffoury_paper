import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';

import '../text_bold.dart';

class DropdownStringListControllerListenerByIcon extends StatefulWidget {
  String hint;
  IconData icon;
  List<DropdownStringListItem?> list;
  bool showSelectedValueBeside;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListenerByIcon(
      {Key? key,
      required this.hint,
      required this.list,
      this.showSelectedValueBeside = true,
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
  CustomPopupMenuItem<DropdownStringListItem> buildMenuItem(
          BuildContext context, DropdownStringListItem? e) =>
      CustomPopupMenuItem<DropdownStringListItem>(
        value: e,
        color: lastSelected?.label == e?.label
            ? Theme.of(context).highlightColor
            : null,
        enabled: e != null ? (e.enabled ?? true) : false,
        child: e != null && e.enabled == false
            ? Column(
                children: [
                  const PopupMenuDivider(),
                  Text(e.label),
                  const PopupMenuDivider()
                ],
              )
            : e == null
                ? Column(
                    children: [Text(widget.hint), const PopupMenuDivider()],
                  )
                : Row(
                    children: [
                      if (e.icon != null)
                        Icon(
                          e.icon,
                          // color: Colors.black,
                          size: 20,
                        ),
                      const SizedBox(width: kDefaultPadding / 3),
                      Text(e.label, overflow: TextOverflow.clip),
                      // TextBold(
                      //   text: "${widget.hint}: ${e.label}",
                      //   regex: e.label.toString(),
                      // )
                    ],
                  ),
      );

  @override
  Widget build(BuildContext context) {
    Widget pop = PopupMenuButton<DropdownStringListItem>(
      position: PopupMenuPosition.under,
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
    if (widget.showSelectedValueBeside && lastSelected != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeInLeft(
              key: UniqueKey(),
              duration: const Duration(milliseconds: 500),
              child: Text(
                lastSelected!.label,
                style: Theme.of(context).textTheme.caption,
              )),
          pop
        ],
      );
    }
    return pop;
  }
}
