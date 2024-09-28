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
  final bool isLoading;
  final DropdownStringListItem? initialValue;
  final DropdownStringListItem? initialValueIfRadio;

  final bool showSelectedValueBeside;
  final bool showFirstValueAsTitle;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListenerByIcon(
      {super.key,
      required this.hint,
      required this.list,
      this.initialValue,
      this.initialValueIfRadio,
      this.showFirstValueAsTitle = true,
      this.isLoading = false,
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
  DropdownStringListItem? _initialValue;
  late bool _isLoading;
  late ValueNotifier<DropdownStringListItem?> radioPos;
  List<DropdownStringListItem?> _list = [null];

  @override
  void initState() {
    _initialValue = widget.initialValue;

    radioPos = ValueNotifier(widget.initialValueIfRadio);
    _isLoading = widget.isLoading;
    // debugPrint("initState radio1  ${radioPos.value}");
    // radioPos.addListener(onChangeRadio);
    // if (widget.initialValueIfRadio != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((o) {
    //     radioPos.value = widget.initialValueIfRadio;
    //   });
    // }
    _list.addAll(widget.list);
    debugPrint(
        "DropdownStringListControllerListenerByIcon buildMenuItem lastSelected $_initialValue initailValue ${widget.initialValue} list $_list");
    super.initState();
  }

  DropdownStringListItem? getSelectedValue(DropdownStringListItem? item) {
    if (radioPos.value == null) {
      return item;
    }
    return DropdownStringListItemWithRadio(
        label: "", value: item?.value, radio: radioPos.value);
  }

  void onChangeRadio() {}
  @override
  void didUpdateWidget(
      covariant DropdownStringListControllerListenerByIcon oldWidget) {
    debugPrint("DropdownStringListControllerListenerByIcon didUpdateWidget");
    if (_initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
    }
    if (widget.initialValueIfRadio != radioPos.value) {
      WidgetsBinding.instance.addPostFrameCallback((o) {
        debugPrint("didUpdateWidget radio");
        radioPos.value = widget.initialValueIfRadio;
      });
    }
    if (_isLoading != widget.isLoading) {
      _isLoading = widget.isLoading;
    }
    _list = [null];
    _list.addAll(widget.list);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // radioPos.removeListener(onChangeRadio);
    radioPos.dispose();
    super.dispose();
  }

  Color? getColor(DropdownStringListItem? item) {
    return _initialValue == null
        ? null
        : _initialValue?.label == item?.label
            ? Theme.of(context).highlightColor
            : null;
  }

  bool isEnabled(DropdownStringListItem? item) {
    return widget.showFirstValueAsTitle
        ? item != null
            ? (item.enabled ?? true)
            : false
        : true;
  }

  Widget getRadioChild(DropdownStringListItem? item) {
    return ValueListenableBuilder(
      valueListenable: radioPos,
      builder: (c, v, e) {
        debugPrint("ValueListenableBuilder  radio $v");
        return ListTile(
          onTap: () {
            debugPrint("onTap radio");
            radioPos.value = item;
          },
          title: Text(
            item!.label,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          leading: Radio<DropdownStringListItem>(
              value: item,
              groupValue: v,
              onChanged: (i) {
                debugPrint("radio $i");
                radioPos.value = i;
              }),
        );
      },
    );
  }

  CustomPopupMenuItem<DropdownStringListItem?> buildMenuItem(
      BuildContext context, DropdownStringListItem? e) {
    if (e?.isDivider == true) {
      return CustomPopupMenuItem<DropdownStringListItem?>(
        enabled: false,
        value: null,
        child: const PopupMenuDivider(),
      );
    }

    return CustomPopupMenuItem<DropdownStringListItem?>(
      dontPop: e?.isRadio == true,
      value: e,
      color: getColor(e),
      enabled: isEnabled(e),
      child: e?.isRadio == true
          ? getRadioChild(e)
          : e != null && e.enabled == false
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      double? size = IconTheme.of(context).size;
      return SizedBox(
          height: size,
          width: size,
          child: const CircularProgressIndicator.adaptive(
            strokeWidth: 2,
          ));
    }

    Widget pop = PopupMenuButton<DropdownStringListItem?>(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      position: PopupMenuPosition.under,
      tooltip: _initialValue == null ? widget.hint : _initialValue!.label,
      icon: Icon(
        _initialValue == null
            ? widget.icon
            : _initialValue?.icon ?? widget.icon,
        color: _initialValue == null
            ? Theme.of(context).indicatorColor
            : Theme.of(context).colorScheme.primary,
      ),
      onSelected: (DropdownStringListItem? result) {
        widget.onSelected(getSelectedValue(result));
        // widget.viewAbstractEnum = result;
        setState(() {
          firstRun = false;
          _initialValue = result;
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
                  key: Key('${_initialValue?.label}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _initialValue?.label ?? widget.hint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
              : FadeInLeft(
                  key: Key('${_initialValue?.label}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _initialValue?.label ?? widget.hint,
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
          pop
        ],
      );
    }
    return pop;
  }
}
