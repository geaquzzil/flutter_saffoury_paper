import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_enum_icon.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';

class DropdownStringListControllerListenerByIcon extends StatefulWidget {
  final String hint;
  final IconData icon;
  final List<DropdownStringListItem?> list;
  final DropdownStringListItem? initialValue;
  final List<DropdownStringListItem>? multipleInitialValues;
  final bool showSelectedValueBeside;
  final bool showFirstValueAsTitle;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListenerByIcon(
      {super.key,
      required this.hint,
      required this.list,
      this.initialValue,
      this.multipleInitialValues,
      this.showFirstValueAsTitle = true,
      this.showSelectedValueBeside = true,
      required this.icon,
      required this.onSelected});

  @override
  State<DropdownStringListControllerListenerByIcon> createState() =>
      _DropdownStringListControllerListenerByIconState();
}

class _DropdownStringListControllerListenerByIconState
    extends State<DropdownStringListControllerListenerByIcon> {
  bool firstRun = true;
  DropdownStringListItem? lastSelected;
  List<DropdownStringListItem?> _list = [null];
  CustomPopupMenuItem<DropdownStringListItem?> buildMenuItem(
      BuildContext context, DropdownStringListItem? e) {
    if (e?.isDivider == true) {
      return const CustomPopupMenuItem<DropdownStringListItem?>(
        enabled: false,
        value: null,
        child: PopupMenuDivider(),
      );
    }
    return CustomPopupMenuItem<DropdownStringListItem?>(
      value: e,
      color: lastSelected == null
          ? null
          : lastSelected?.label == e?.label
              ? Theme.of(context).highlightColor
              : null,
      enabled: widget.showFirstValueAsTitle
          ? e != null
              ? (e.enabled ?? true)
              : false
          : true,
      child: e != null && e.enabled == false
          ? Column(
              children: [
                const PopupMenuDivider(),
                Text(
                  e.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
                        size: 15,
                        e.icon,
                      ),
                    const SizedBox(width: kDefaultPadding / 3),
                    Text(
                      e.label,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // TextBold(
                    //   text: "${widget.hint}: ${e.label}",
                    //   regex: e.label.toString(),
                    // )
                  ],
                ),
    );
  }

  @override
  void initState() {
    lastSelected = widget.initialValue;

    _list.addAll(widget.list);
    debugPrint(
        "DropdownStringListControllerListenerByIcon buildMenuItem lastSelected $lastSelected initailValue ${widget.initialValue} list $_list");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint(
        "DropdownStringListControllerListenerByIcon didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(
      covariant DropdownStringListControllerListenerByIcon oldWidget) {
    debugPrint("DropdownStringListControllerListenerByIcon didUpdateWidget");

    lastSelected = widget.initialValue;
    _list = [null];
    _list.addAll(widget.list);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return Text("dd");
    Widget pop = PopupMenuButton<DropdownStringListItem?>(
      // iconColor: Theme.of(context).colorScheme.,
      position: PopupMenuPosition.under,
      // surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      // child: Icon(
      //   lastSelected == null || firstRun
      //       ? widget.icon
      //       : lastSelected?.icon ?? widget.icon,
      //   // color: Theme.of(context).highlightColor,
      // ),
      tooltip: lastSelected == null ? widget.hint : lastSelected!.label,
      // tooltip: widget.hint,
      icon: Icon(
        lastSelected == null ? widget.icon : lastSelected?.icon ?? widget.icon,
        color: lastSelected == null
            ? Theme.of(context).indicatorColor
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
      itemBuilder: (BuildContext context) => _list
          .map(
            (e) => buildMenuItem(context, e),
          )
          .toList(),
    );
    if (widget.showSelectedValueBeside) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Globals.isArabic(context)
              ? FadeInRight(
                  key: Key('${lastSelected?.label}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    lastSelected?.label ?? widget.hint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
              : FadeInLeft(
                  key: Key('${lastSelected?.label}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    lastSelected?.label ?? widget.hint,
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
          pop
        ],
      );
    }
    return pop;
  }
}
