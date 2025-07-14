import 'package:flutter/material.dart';

///[T] should implements == operater and hashcode
abstract class BaseWidgetControllerWithSave<T> extends StatefulWidget {
  final T? initialValue;
  final ValueNotifier<T?>? onValueSelected;
  final Function(T? value)? onValueSelectedFunction;

  /// if values that selected is null then we wont notify the [onValueSelected] and [onValueSelectedFunction]
  /// set to false if you  do not want this
  /// default is true
  final bool notifyOnNull;
  const BaseWidgetControllerWithSave(
      {super.key,
      this.initialValue,
      this.onValueSelected,
      this.notifyOnNull = true,
      this.onValueSelectedFunction});
}

mixin BaseWidgetControllerWithSaveState<T,
    E extends BaseWidgetControllerWithSave<T>> on State<E> {
  T? _initialValue;

  T? get initialValue => this._initialValue;

  set initialValue(T? value) => this._initialValue = value;

  void notifyValueSelected(T? value) {
    if (value != null || (value == null && widget.notifyOnNull)) {
      debugPrint(
          "BaseWidgetControllerWithSaveStateState  called function changed to ${value.toString()}");
      widget.onValueSelected?.value = value;
      widget.onValueSelectedFunction?.call(value);
    }
    debugPrint(
        "BaseWidgetControllerWithSaveStateState changed to ${value.toString()}");
    setState(() {
      _initialValue = value;
    });
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    debugPrint(
        "BaseWidgetControllerWithSaveState didUpdateWidget $_initialValue");
    if (widget.initialValue != null) {
      debugPrint(
          "BaseWidgetControllerWithSaveState didUpdateWidget widget.initialValue != null");
      if (_initialValue != widget.initialValue) {
        debugPrint(
            "BaseWidgetControllerWithSaveState didUpdateWidget _initialValue $_initialValue widget ${widget.initialValue}");
        _initialValue = widget.initialValue;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;
    super.initState();
  }
}
