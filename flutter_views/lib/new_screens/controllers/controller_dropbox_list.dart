import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/size_config.dart';

class DropdownStringListControllerListener extends StatefulWidget {
  final String tag;
  final String hint;
  final bool insetFirstIsSelect;
  final bool isLoading;
  final List<DropdownStringListItem?> list;
  final DropdownStringListItem? initialValue;

  final IconData? icon;
  final CurrentScreenSize? currentScreenSize;
  final void Function(DropdownStringListItem? object) onSelected;

  const DropdownStringListControllerListener(
      {super.key,
      required this.tag,
      required this.hint,
      required this.list,
      this.isLoading = false,
      this.insetFirstIsSelect = true,
      this.initialValue,
      this.icon,
      this.currentScreenSize,
      required this.onSelected});

  @override
  State<DropdownStringListControllerListener> createState() =>
      _DropdownStringListControllerListenerState();
}

class _DropdownStringListControllerListenerState
    extends State<DropdownStringListControllerListener> {
  bool firstRun = true;
  DropdownStringListItem? _initialValue;
  late bool _isLoading;
  List<DropdownStringListItem?> _list = [null];

  @override
  void initState() {
    _initialValue = widget.initialValue;
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
        "DropdownStringListControllerListener buildMenuItem lastSelected ${_initialValue?.value} initailValue ${widget.initialValue} list $_list");
    super.initState();
  }

  DropdownStringListItem? getSelectedValue(DropdownStringListItem? item) {
    return DropdownStringListItemWithRadio(
      label: "",
      value: item?.value,
    );
  }

  @override
  void didUpdateWidget(
      covariant DropdownStringListControllerListener oldWidget) {
    debugPrint("DropdownStringListControllerListener didUpdateWidget");
    if (_initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      isExpanded: true,
      // itemHeight: 50,
      name: widget.tag,
      initialValue: _initialValue,
      // decoration: getDecorationIconHintPrefix(
      //     hint: hint, icon: icon, currentScreenSize: currentScreenSize),
      // decoration: getDecorationDropdownNewWithLabelAndValue(context),
      items: widget.list
          .map((item) => DropdownMenuItem(
                value: item,
                child: item != null
                    ? Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text("dsa"),
              ))
          .toList(),
      onChanged: (obj) {
        debugPrint("changed: $obj");
        widget.onSelected(obj as DropdownStringListItem);
        setState(() {
          _initialValue = obj;
        });
      },
    );
  }
}

class DropdownStringListItemWithRadio extends DropdownStringListItem {
  DropdownStringListItem? radio;
  DropdownStringListItemWithRadio(
      {required super.label, super.value, this.radio});
}

class DropdownStringListItem {
  IconData? icon;
  String label;
  Object? value;
  bool? enabled;
  bool isDivider;
  bool isRadio;
  DropdownStringListItem(
      {this.icon,
      required this.label,
      this.value,
      this.enabled,
      this.isDivider = false,
      this.isRadio = false});

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return other is DropdownStringListItem &&
        label == other.label &&
        isDivider == other.isDivider;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(label, isDivider);
}
