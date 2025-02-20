import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NestedFormBuilder extends StatelessWidget {
  /// Parent Form Key
  final GlobalKey<FormBuilderState>? parentFormKey;

  /// Nested Form Key
  final GlobalKey<FormBuilderState> formKey;

  /// Called just before field value is saved. Used to massage data just before
  /// committing the value.
  /// See [FormBuilderField.valueTransformer]
  final ValueTransformer<Map<String, dynamic>?>? valueTransformer;

  /// Used to reference the field within the form, or to reference form data
  /// after the form is submitted.
  final String name;

  /// Called when one of the form fields changes.
  ///
  /// In addition to this callback being invoked, all the form fields themselves
  /// will rebuild.
  final VoidCallback? onChanged;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// Used to enable/disable form fields auto validation and update their error
  /// text.
  ///
  /// {@macro flutter.widgets.form.autovalidateMode}
  final AutovalidateMode? autovalidateMode;

  /// An optional Map of field initialValues. Keys correspond to the field's
  /// name and value to the initialValue of the field.
  ///
  /// The initialValues set here will be ignored if the field has a local
  /// initialValue set.
  final Map<String, dynamic>? initialValue;

  /// Whether the form should ignore submitting values from fields where
  /// `enabled` is `false`.
  /// This behavior is common in HTML forms where _readonly_ values are not
  /// submitted when the form is submitted.
  ///
  /// When `true`, the final form value will not contain disabled fields.
  /// Default is `false`.
  final bool skipDisabled;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true.
  ///
  /// When `false` all the form fields will be disabled - won't accept input -
  /// and their enabled state will be ignored.
  final bool enabled;

  /// Whether the form should auto focus on the first field that fails validation.
  final bool autoFocusOnValidationFailure;

  /// Whether to clear the internal value of a field when it is unregistered.
  ///
  /// Defaults to `false`.
  ///
  /// When set to `true`, the form builder will not keep the internal values
  /// from disposed [FormBuilderField]s. This is useful for dynamic forms where
  /// fields are registered and unregistered due to state change.
  ///
  /// This setting will have no effect when registering a field with the same
  /// name as the unregistered one.
  final bool clearValueOnUnregister;

  final String? Function(Map<String, dynamic>?)? validator;

  final void Function()? onReset;

  NestedFormBuilder({
    super.key,
    required this.name,
    required this.child,
    this.onChanged,
    this.onWillPop,
    this.autovalidateMode,
    this.initialValue,
    this.skipDisabled = false,
    this.onReset,
    this.enabled = true,
    this.autoFocusOnValidationFailure = false,
    this.clearValueOnUnregister = false,
    this.validator,
    GlobalKey<FormBuilderState>? formKey,
    this.parentFormKey,
    this.valueTransformer,
  }) : formKey = formKey ?? GlobalKey<FormBuilderState>();
  Map<String, dynamic>? convertableMap;
  @override
  Widget build(BuildContext context) {
    return FormBuilderField<Map<String, dynamic>>(
      name: name,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ??
          (v) {
            debugPrint("NestedFormBuilder validater $v");
            return formKey.currentState?.validate(
                        autoScrollWhenFocusOnInvalid: false,
                        focusOnInvalid: false) ??
                    false
                ? null
                : "Error";
          },
      initialValue:
          initialValue ?? parentFormKey?.currentState?.initialValue[name],
      valueTransformer: valueTransformer ??
          (value) {
            debugPrint("NestedFormBuilder valueTransformer $name:$value");
            return value;
          },
      onChanged: (value) {
        // formKey.currentState?.patchValue(value ?? {});
        debugPrint("NestedFormBuilder onChanged $name:$value");
        // formKey.currentState?.save();
        // parentFormKey?.currentState?.reset();
      },
      onSaved: (newValue) {
        debugPrint("NestedFormBuilder onSaved $name:$newValue");
      },
      onReset: () => formKey.currentState?.reset(),
      builder: (field) {
        debugPrint("NestedFormBuilder builder $name:${field.value}");
        convertableMap = toJsonViewAbstractForm(field.value);
        return FormBuilder(
          key: formKey,
          initialValue: convertableMap ?? {},
          onChanged: () {
            final st = formKey.currentState;
            if (st == null) return;
            bool res = st.saveAndValidate(
                autoScrollWhenFocusOnInvalid: false, focusOnInvalid: false);
            field.didChange(valueTransformer?.call(st.value) ?? st.value);
           
            debugPrint("\n");
            debugPrint(
                "NestedFormBuilder $res=>onChanged=>$name:${formKey.currentState?.value}");
          },
          // autovalidateMode: AutovalidateMode.always,

          //  onWillPop: onWillPop,
          skipDisabled: skipDisabled,
          enabled: enabled,
          //  autoFocusOnValidationFailure: autoFocusOnValidationFailure,
          clearValueOnUnregister: clearValueOnUnregister,
          child: child,
        );
      },
    );
  }

  static Map<String, dynamic> toJsonViewAbstractForm(
      Map<String, dynamic>? map) {
    if (map == null) {
      return {};
    }
    String jsonString = jsonEncode(map);
    return jsonDecode(
      jsonString,
      reviver: (key, value) {
        if (value is num) {
          return value.toString(); // Convert number to string
        }
        if (value is double) {
          return value.toString();
        }
        if (value is int) {
          return value.toString();
        }

        return value;
      },
    );
  }
}
