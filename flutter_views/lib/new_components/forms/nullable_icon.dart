import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A [ReactiveAdvancedSwitch] that contains a [AdvancedSwitch].
///
/// This is a convenience widget that wraps a [AdvancedSwitch] widget in a
/// [ReactiveAdvancedSwitch].
///
/// A [ReactiveForm] ancestor is required.
///
class ReactiveNullableSwitch<T> extends ReactiveFormField<T, bool> {
  ReactiveNullableSwitch(
      {required BuildContext context,
      super.key,
      super.formControlName,
      void Function(bool value)? onChange

      ////////////////////////////////////////////////////////////////////////////
      })
      : super(
          builder: (field) {
            bool val = field.value == true ? false : true;
            final child = IconButton(
              icon: Icon(
                  field.value == true ? Icons.delete_forever : Icons.delete,
                  color: field.value == true
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer),
              onPressed: () {
                onChange?.call(val);
                field.didChange(val);
              },
            );
            return child;

            // return InputDecorator(
            //   decoration: effectiveDecoration.copyWith(
            //     errorText: field.errorText,
            //     enabled: field.control.enabled,
            //   ),
            //   child: Row(children: [child]),
            // );
          },
        );

  @override
  ReactiveFormFieldState<T, bool> createState() =>
      _ReactiveAdvancedSwitchState<T>();
}

class _ReactiveAdvancedSwitchState<T> extends ReactiveFormFieldState<T, bool> {
  late ValueNotifier<bool> _advancedSwitchController;
  late StreamSubscription<T?> _valueChangesSubscription;

  @override
  void initState() {
    super.initState();

    _valueChangesSubscription = control.valueChanges.listen((value) {
      _advancedSwitchController.value =
          valueAccessor.modelToViewValue(value) ?? false;
    });

    _advancedSwitchController = ValueNotifier<bool>(
      valueAccessor.modelToViewValue(control.value) ?? false,
    )..addListener(
        () {
          control.markAsTouched();
          didChange(_advancedSwitchController.value);
        },
      );
  }

  @override
  void dispose() {
    _valueChangesSubscription.cancel();
    _advancedSwitchController.dispose();
    super.dispose();
  }
}
