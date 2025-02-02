import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/components/base_controller_with_save_state.dart';
import 'package:flutter_view_controller/size_config.dart';

class DropdownStringListControllerListener
    extends BaseWidgetControllerWithSave<DropdownStringListItem> {
  final String tag;
  final String hint;
  final bool insetFirstIsSelect;
  final bool isLoading;
  final List<DropdownStringListItem?> list;

  final IconData? icon;
  final CurrentScreenSize? currentScreenSize;

  const DropdownStringListControllerListener(
      {super.key,
      required this.tag,
      required this.hint,
      required this.list,
      this.isLoading = false,
      this.insetFirstIsSelect = true,
      super.initialValue,
      this.icon,
      this.currentScreenSize,
      super.onValueSelectedFunction});

  @override
  State<DropdownStringListControllerListener> createState() =>
      _DropdownStringListControllerListenerState();
}

class _DropdownStringListControllerListenerState
    extends State<DropdownStringListControllerListener>
    with
        BaseWidgetControllerWithSaveState<DropdownStringListItem,
            DropdownStringListControllerListener> {
  bool firstRun = true;
  late bool _isLoading;
  List<DropdownStringListItem?> _list = [null];

  @override
  void initState() {
    _isLoading = widget.isLoading;
    // debugPrint("initState radio1  ${radioPos.value}");
    // radioPos.addListener(onChangeRadio);
    // if (widget.initialValueIfRadio != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((o) {
    //     radioPos.value = widget.initialValueIfRadio;
    //   });
    // }
    _list.addAll(widget.list);

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
    if (_isLoading != widget.isLoading) {
      _isLoading = widget.isLoading;
    }
    _list = [null];
    _list.addAll(widget.list);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "_DropdownStringListControllerListenerState initialValue ${initialValue.toString()}");
    return FormBuilderDropdown(
      isExpanded: true,
      // itemHeight: 50,
      name: widget.tag,
      initialValue: initialValue,
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
      onChanged: notifyValueSelected,
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
  String toString() => {'label': label}.toString();
  
  @override
  bool operator ==(other) {
    return other is DropdownStringListItem &&
        label == other.label &&
        isDivider == other.isDivider;
  }

  @override
  int get hashCode => Object.hash(label, isDivider);
}
