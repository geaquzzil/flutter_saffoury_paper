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

  ValueNotifier<T?>? _onValueSelected;

  Function(T? value)? _onValueSelectedFunction;

  T? get initialValue => this._initialValue;

  set initialValue(T? value) => this._initialValue = value;

  void notifyValueSelected(T? value) {
    if (value != null || (value == null && widget.notifyOnNull)) {
      _onValueSelected?.value = value;
      _onValueSelectedFunction?.call(value);
    }
    _onValueSelected?.value = value;
    _onValueSelectedFunction?.call(value);
    debugPrint(
        "BaseWidgetControllerWithSaveStateState changed to ${value.toString()}");
    setState(() {
      _initialValue = value;
    });
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    if (_initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _onValueSelected?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;
    // _onValueSelected = widget.onValueSelected as ValueNotifier<T?>?;
    // _onValueSelectedFunction = widget.onValueSelectedFunction;

    super.initState();
  }
}
