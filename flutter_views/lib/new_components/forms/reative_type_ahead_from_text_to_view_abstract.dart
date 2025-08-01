// Copyright 2020 Vasyl Dytsiak. All rights reserved.
// Use of this source code is governed by the MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A [ReactiveTypeAhead] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [ReactiveTypeAhead].
///
/// A [ReactiveForm] ancestor is required.
///
class ReactiveTypeAheadCustomViewAbstract
    extends ReactiveFormField<ViewAbstract, ViewAbstract> {
  /// Creates a [ReactiveTypeAhead] that contains a [TextField].
  ///
  /// Can optionally provide a [formControl] to bind this widget to a control.
  ///
  /// Can optionally provide a [formControlName] to bind this ReactiveFormField
  /// to a [FormControl].
  ///
  /// Must provide one of the arguments [formControl] or a [formControlName],
  /// but not both at the same time.
  ///
  /// Can optionally provide a [validationMessages] argument to customize a
  /// message for different kinds of validation errors.
  ///
  /// Can optionally provide a [valueAccessor] to set a custom value accessors.
  /// See [ControlValueAccessor].
  ///
  /// Can optionally provide a [showErrors] function to customize when to show
  /// validation messages. Reactive Widgets make validation messages visible
  /// when the control is INVALID and TOUCHED, this behavior can be customized
  /// in the [showErrors] function.
  ///
  /// ### Example:
  /// Binds a text field.
  /// ```
  /// final form = fb.group({'email': Validators.required});
  ///
  /// ReactiveTypeAhead(
  ///   formControlName: 'email',
  /// ),
  ///
  /// ```
  ///
  /// Binds a text field directly with a *FormControl*.
  /// ```
  /// final form = fb.group({'email': Validators.required});
  ///
  /// ReactiveTypeAhead(
  ///   formControl: form.control('email'),
  /// ),
  ///
  /// ```
  ///
  /// Customize validation messages
  /// ```dart
  /// ReactiveTypeAhead(
  ///   formControlName: 'email',
  ///   validationMessages: {
  ///     ValidationMessage.required: 'The email must not be empty',
  ///     ValidationMessage.email: 'The email must be a valid email',
  ///   }
  /// ),
  /// ```
  ///
  /// Customize when to show up validation messages.
  /// ```dart
  /// ReactiveTypeAhead(
  ///   formControlName: 'email',
  ///   showErrors: (control) => control.invalid && control.touched && control.dirty,
  /// ),
  /// ```
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [TextField], the constructor.
  ReactiveTypeAheadCustomViewAbstract({
    required BuildContext context,
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    super.valueAccessor,
    super.showErrors,
    required this.parentViewAbstract,
    required this.formGroup,
    required this.childViewAbstractApi,
    required this.fieldFromChild,
    required this.fieldFromParent,

    ////////////////////////////////////////////////////////////////////////////
    // required FutureOr<List<T>?> Function(String) suggestionsCallback,
    // required Widget Function(BuildContext, T) itemBuilder,
    Widget Function(BuildContext, Widget)? decorationBuilder,
    Duration debounceDuration = const Duration(milliseconds: 300),
    Widget Function(BuildContext)? loadingBuilder,
    Widget Function(BuildContext)? emptyBuilder,
    Widget Function(BuildContext, Object?)? errorBuilder,
    Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Offset? offset,
    VerticalDirection? direction,
    bool hideOnLoading = false,
    bool hideOnEmpty = false,
    bool hideOnError = false,
    bool hideWithKeyboard = true,
    bool retainOnLoading = true,
    bool hideOnSelect = true,
    bool autoFlipDirection = false,
    SuggestionsController<ViewAbstract>? suggestionsController,
    ScrollController? scrollController,
    bool hideKeyboardOnDrag = false,
    Widget Function(BuildContext, int)? itemSeparatorBuilder,
    Widget Function(BuildContext, List<Widget>)? listBuilder,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextEditingController? textEditingController,
    bool autofocus = false,
    bool readOnly = false,
    bool? showCursor,
    bool obscureText = false,
    String obscuringCharacter = '•',
    bool autocorrect = true,
    bool enabled = true,
    FocusNode? focusNode,
    InputDecoration? decoration,
    void Function(ViewAbstract)? onSuggestionSelected,
  }) : super(builder: (field) {
          final controller = SuggestionsController<ViewAbstract>();
          final textController = TextEditingController();

          // controller.close();
          return TypeAheadField<ViewAbstract>(
            controller: textController,
            suggestionsController: controller,
            builder: (context, controller, focusNode) {
              textController.text = field.value?.toString() ?? "";

              return childViewAbstractApi.getFormFieldTextReactive(
                  onChanged: (p0) {
                    // formGroup.controls[fieldFromParent]?.patchValue(
                    //     childViewAbstractApi.getNewInstance(
                    //         values: childViewAbstractApi
                    //             .copyWithFormValues(values: {'text': p0})));
                  },
                  enableClearButton: true,
                  // key: key,
                  field: fieldFromChild,
                  context: context,
                  // options: options,
                  controller: textController,
                  node: focusNode);
            },

            hideOnEmpty: true,
            // debounceDuration: ,
            onSelected: (value) {
              // controller.
              debugPrint(
                  "onSeggestionSelected onSelected ${formGroup.controls}  value $value   value field = >${value.toJsonViewAbstract()[fieldFromChild]}");
              // field.didChange(value.toJsonViewAbstract()[fieldFromChild]);
              // formGroup.patchValue(value.toJsonViewAbstract());

              field.didChange(value);
            },

            itemBuilder: (context, containt) {
              return childViewAbstractApi.getAutoCompleteItemBuilder(
                  context, fieldFromChild, containt);
            },
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];
              if (query.trim().isEmpty) return [];

              return childViewAbstractApi.listCall(
                  context: context,
                  option: RequestOptions(searchQuery: query, countPerPage: 5));
            },
          );
        });

  final ViewAbstract parentViewAbstract;
  final ViewAbstract childViewAbstractApi;
  final FormGroup formGroup;

  final String fieldFromParent;
  final String fieldFromChild;

  // @override
  // ReactiveFormFieldState<E, T> createState() =>
  //     _ReactiveTypeaheadState<E,T>();
}

ControlValueAccessor? selectValueAccessor<E>(FormControl control) {
  if (control is FormControl<int>) {
    return IntValueAccessor() as ControlValueAccessor<E, String>;
  } else if (control is FormControl<double>) {
    return DoubleValueAccessor() as ControlValueAccessor<E, String>;
  } else if (control is FormControl<DateTime>) {
    return DateTimeValueAccessor() as ControlValueAccessor<E, String>;
  } else if (control is FormControl<TimeOfDay>) {
    return TimeOfDayValueAccessor() as ControlValueAccessor<E, String>;
  }
  return null;
}

// class _ReactiveTypeaheadState<E,T> extends ReactiveFormFieldState<E, T> {
//   late TextEditingController _textController;
//   FocusNode? _focusNode;
//   late FocusController _focusController;

//   @override
//   FocusNode get focusNode => _focusNode ?? _focusController.focusNode;

//   @override
//   void initState() {
//     super.initState();

//     final initialValue = value;
//     _textController = TextEditingController(
//       text: initialValue ?? '',
//     );
//   }

//   @override
//   void subscribeControl() {
//     _registerFocusController(FocusController());
//     super.subscribeControl();
//   }

//   @override
//   void unsubscribeControl() {
//     _unregisterFocusController();
//     super.unsubscribeControl();
//   }

//   @override
//   void onControlValueChanged(dynamic value) {
//     final effectiveValue = value == null
//         ? ''
//         : (widget as ReactiveTypeAheadCustom<T>).stringify(value as T);

//     _textController.value = _textController.value.copyWith(
//       text: effectiveValue,
//       selection: TextSelection.collapsed(offset: effectiveValue.length),
//       composing: TextRange.empty,
//     );

//     super.onControlValueChanged(value);
//   }

//   void _registerFocusController(FocusController focusController) {
//     _focusController = focusController;
//     control.registerFocusController(focusController);
//   }

//   void _unregisterFocusController() {
//     control.unregisterFocusController(_focusController);
//     _focusController.dispose();
//   }

//   void _setFocusNode(FocusNode? focusNode) {
//     if (_focusNode != focusNode) {
//       _focusNode = focusNode;
//       _unregisterFocusController();
//       _registerFocusController(FocusController(focusNode: _focusNode));
//     }
//   }
// }
