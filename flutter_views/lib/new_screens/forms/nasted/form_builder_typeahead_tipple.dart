// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_typeahead/src/keyboard_suggestion_selection_notifier.dart';
// import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
// import 'package:flutter_typeahead/src/utils.dart';
// import 'package:pointer_interceptor/pointer_interceptor.dart';
// import 'package:pointer_interceptor/src/mobile.dart';

// typedef SelectionToTextTransformer<T> = String Function(T suggestion);

// @Deprecated("use TypeAheadField directly")

// /// Text field that auto-completes user input from a list of items
// class FormBuilderTypeAheadTupple<T> extends FormBuilderFieldDecoration<String> {
//   /// Called with the search pattern to get the search suggestions.
//   ///
//   /// This callback must not be null. It is be called by the TypeAhead widget
//   /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
//   /// of suggestions either synchronously, or asynchronously (as the result of a
//   /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
//   /// Typically, the list of suggestions should not contain more than 4 or 5
//   /// entries. These entries will then be provided to [itemBuilder] to display
//   /// the suggestions.
//   ///
//   /// Example:
//   /// ```dart
//   /// suggestionsCallback: (pattern) async {
//   ///   return await _getSuggestions(pattern);
//   /// }
//   /// ```
//   final SuggestionsCallback<T> suggestionsCallback;

//   /// Called when a suggestion is tapped.
//   ///
//   /// This callback must not be null. It is called by the TypeAhead widget and
//   /// provided with the value of the tapped suggestion.
//   ///
//   /// For example, you might want to navigate to a specific view when the user
//   /// tabs a suggestion:
//   /// ```dart
//   /// onSuggestionSelected: (suggestion) {
//   ///   Navigator.of(context).push(MaterialPageRoute(
//   ///     builder: (context) => SearchResult(
//   ///       searchItem: suggestion
//   ///     )
//   ///   ));
//   /// }
//   /// ```
//   ///
//   /// Or to set the value of the text field:
//   /// ```dart
//   /// onSuggestionSelected: (suggestion) {
//   ///   _controller.text = suggestion['name'];
//   /// }
//   /// ```
//   final SuggestionSelectionCallback<T>? onSuggestionSelected;

//   /// Called for each suggestion returned by [suggestionsCallback] to build the
//   /// corresponding widget.
//   ///
//   /// This callback must not be null. It is called by the TypeAhead widget for
//   /// each suggestion, and expected to build a widget to display this
//   /// suggestion's info. For example:
//   ///
//   /// ```dart
//   /// itemBuilder: (context, suggestion) {
//   ///   return ListTile(
//   ///     title: Text(suggestion['name']),
//   ///     subtitle: Text('USD' + suggestion['price'].toString())
//   ///   );
//   /// }
//   /// ```
//   final ItemBuilder<T> itemBuilder;

//   /// The decoration of the material sheet that contains the suggestions.
//   ///
//   /// If null, default decoration with an elevation of 4.0 is used
//   final SuggestionsBoxDecoration suggestionsBoxDecoration;

//   /// Used to control the `_SuggestionsBox`. Allows manual control to
//   /// open, close, toggle, or resize the `_SuggestionsBox`.
//   final SuggestionsBoxController? suggestionsBoxController;

//   /// The duration to wait after the user stops typing before calling
//   /// [suggestionsCallback]
//   ///
//   /// This is useful, because, if not set, a request for suggestions will be
//   /// sent for every character that the user types.
//   ///
//   /// This duration is set by default to 300 milliseconds
//   final Duration debounceDuration;

//   /// Called when waiting for [suggestionsCallback] to return.
//   ///
//   /// It is expected to return a widget to display while waiting.
//   /// For example:
//   /// ```dart
//   /// (BuildContext context) {
//   ///   return Text('Loading...');
//   /// }
//   /// ```
//   ///
//   /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
//   final WidgetBuilder? loadingBuilder;

//   /// Called when [suggestionsCallback] returns an empty array.
//   ///
//   /// It is expected to return a widget to display when no suggestions are
//   /// available.
//   /// For example:
//   /// ```dart
//   /// (BuildContext context) {
//   ///   return Text('No Items Found!');
//   /// }
//   /// ```
//   ///
//   /// If not specified, a simple text is shown
//   final WidgetBuilder? noItemsFoundBuilder;

//   /// Called when [suggestionsCallback] throws an exception.
//   ///
//   /// It is called with the error object, and expected to return a widget to
//   /// display when an exception is thrown
//   /// For example:
//   /// ```dart
//   /// (BuildContext context, error) {
//   ///   return Text('$error');
//   /// }
//   /// ```
//   ///
//   /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
//   final ErrorBuilder? errorBuilder;

//   /// Called to display animations when [suggestionsCallback] returns suggestions
//   ///
//   /// It is provided with the suggestions box instance and the animation
//   /// controller, and expected to return some animation that uses the controller
//   /// to display the suggestion box.
//   ///
//   /// For example:
//   /// ```dart
//   /// transitionBuilder: (context, suggestionsBox, animationController) {
//   ///   return FadeTransition(
//   ///     child: suggestionsBox,
//   ///     opacity: CurvedAnimation(
//   ///       parent: animationController,
//   ///       curve: Curves.fastOutSlowIn
//   ///     ),
//   ///   );
//   /// }
//   /// ```
//   /// This argument is best used with [animationDuration] and [animationStart]
//   /// to fully control the animation.
//   ///
//   /// To fully remove the animation, just return `suggestionsBox`
//   ///
//   /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
//   final AnimationTransitionBuilder? transitionBuilder;

//   /// The duration that [transitionBuilder] animation takes.
//   ///
//   /// This argument is best used with [transitionBuilder] and [animationStart]
//   /// to fully control the animation.
//   ///
//   /// Defaults to 500 milliseconds.
//   final Duration animationDuration;

//   /// Determine the [SuggestionBox]'s direction.
//   ///
//   /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
//   /// and the [_SuggestionsList] will grow **down**.
//   ///
//   /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
//   /// and the [_SuggestionsList] will grow **up**.
//   ///
//   /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
//   final AxisDirection direction;

//   /// The value at which the [transitionBuilder] animation starts.
//   ///
//   /// This argument is best used with [transitionBuilder] and [animationDuration]
//   /// to fully control the animation.
//   ///
//   /// Defaults to 0.25.
//   final double animationStart;

//   /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
//   /// that the TypeAhead widget displays
//   final TextFieldConfiguration textFieldConfiguration;

//   /// How far below the text field should the suggestions box be
//   ///
//   /// Defaults to 5.0
//   final double suggestionsBoxVerticalOffset;

//   /// If set to true, suggestions will be fetched immediately when the field is
//   /// added to the view.
//   ///
//   /// But the suggestions box will only be shown when the field receives focus.
//   /// To make the field receive focus immediately, you can set the `autofocus`
//   /// property in the [textFieldConfiguration] to true
//   ///
//   /// Defaults to false
//   final bool getImmediateSuggestions;

//   /// If set to true, no loading box will be shown while suggestions are
//   /// being fetched. [loadingBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnLoading;

//   /// If set to true, nothing will be shown if there are no results.
//   /// [noItemsFoundBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnEmpty;

//   /// If set to true, nothing will be shown if there is an error.
//   /// [errorBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnError;

//   /// If set to false, the suggestions box will stay opened after
//   /// the keyboard is closed.
//   ///
//   /// Defaults to true.
//   final bool hideSuggestionsOnKeyboardHide;

//   /// If set to false, the suggestions box will show a circular
//   /// progress indicator when retrieving suggestions.
//   ///
//   /// Defaults to true.
//   final bool keepSuggestionsOnLoading;

//   /// If set to true, the suggestions box will remain opened even after
//   /// selecting a suggestion.
//   ///
//   /// Note that if this is enabled, the only way
//   /// to close the suggestions box is either manually via the
//   /// `SuggestionsBoxController` or when the user closes the software
//   /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
//   /// with a physical keyboard will be unable to close the
//   /// box without a manual way via `SuggestionsBoxController`.
//   ///
//   /// Defaults to false.
//   final bool keepSuggestionsOnSuggestionSelected;

//   /// If set to true, in the case where the suggestions box has less than
//   /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
//   /// will be temporarily flipped if there's more room available in the opposite
//   /// direction.
//   ///
//   /// Defaults to false
//   final bool autoFlipDirection;

//   final SelectionToTextTransformer<dynamic>? selectionToTextTransformer;

//   final String Function(T) selectionToTextCallback;

//   /// Controls the text being edited.
//   ///
//   /// If null, this widget will create its own [TextEditingController].
//   final TextEditingController? controller;

//   final bool hideKeyboard;

//   final ScrollController? scrollController;

//   final IndexedWidgetBuilder? itemSeparatorBuilder;

//   /// By default, we render the suggestions in a ListView, using
//   /// the `itemBuilder` to construct each element of the list.  Specify
//   /// your own `layoutArchitecture` if you want to be responsible
//   /// for layinng out the widgets using some other system (like a grid).
//   final LayoutArchitecture? layoutArchitecture;

//   /// Used to overcome [Flutter issue 98507](https://github.com/flutter/flutter/issues/98507)
//   /// Most commonly experienced when placing the [TypeAheadFormField] on a google map in Flutter Web.
//   final bool intercepting;

//   /// If set to false, suggestion list will not be reversed according to the
//   /// [autoFlipDirection] property.
//   ///
//   /// Defaults to true.
//   final bool autoFlipListDirection;

//   /// Minimum height below [autoFlipDirection] is triggered
//   ///
//   /// Defaults to 64.0.
//   final double autoFlipMinHeight;

//   /// The minimum number of characters which must be entered before
//   /// [suggestionsCallback] is triggered.
//   ///
//   /// Defaults to 0.
//   final int minCharsForSuggestions;

//   /// If set to true and if the user scrolls through the suggestion list, hide the keyboard automatically.
//   /// If set to false, the keyboard remains visible.
//   /// Throws an exception, if hideKeyboardOnDrag and hideSuggestionsOnKeyboardHide are both set to true as
//   /// they are mutual exclusive.
//   ///
//   /// Defaults to false
//   final bool hideKeyboardOnDrag;

//   /// Allows a bypass of a problem on Flutter 3.7+ with the accessibility through Overlay
//   /// that prevents flutter_typeahead to register a click on the list of suggestions properly.
//   ///
//   /// Defaults to false
//   final bool ignoreAccessibleNavigation;

//   // Adds a callback for the suggestion box opening or closing
//   final void Function(bool)? onSuggestionsBoxToggle;

//   /// Creates text field that auto-completes user input from a list of items
//   FormBuilderTypeAheadTupple({
//     super.key,
//     super.autovalidateMode,
//     super.enabled,
//     super.focusNode,
//     super.onSaved,
//     super.validator,
//     super.decoration,
//     super.initialValue,
//     super.onChanged,
//     super.valueTransformer,
//     super.onReset,
//     required super.name,
//     required this.itemBuilder,
//     required this.suggestionsCallback,
//     required this.selectionToTextCallback,
//     this.animationDuration = const Duration(milliseconds: 500),
//     this.animationStart = 0.25,
//     this.autoFlipDirection = false,
//     this.controller,
//     this.debounceDuration = const Duration(milliseconds: 300),
//     this.direction = AxisDirection.down,
//     this.errorBuilder,
//     this.getImmediateSuggestions = false,
//     this.hideKeyboard = false,
//     this.hideOnEmpty = false,
//     this.hideOnError = false,
//     this.hideOnLoading = false,
//     this.hideSuggestionsOnKeyboardHide = true,
//     this.keepSuggestionsOnLoading = true,
//     this.keepSuggestionsOnSuggestionSelected = false,
//     this.loadingBuilder,
//     this.noItemsFoundBuilder,
//     this.onSuggestionSelected,
//     this.scrollController,
//     this.selectionToTextTransformer,
//     this.suggestionsBoxController,
//     this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
//     this.suggestionsBoxVerticalOffset = 5.0,
//     this.textFieldConfiguration = const TextFieldConfiguration(),
//     this.transitionBuilder,
//     this.autoFlipListDirection = true,
//     this.autoFlipMinHeight = 64.0,
//     this.hideKeyboardOnDrag = false,
//     this.ignoreAccessibleNavigation = false,
//     this.intercepting = false,
//     this.itemSeparatorBuilder,
//     this.layoutArchitecture,
//     this.minCharsForSuggestions = 0,
//     this.onSuggestionsBoxToggle,
//   }) : super(
//           builder: (FormFieldState<String?> field) {
//             final state = field as FormBuilderTypeAheadState<T>;
//             final theme = Theme.of(state.context);

//             return TypeAheadField<T>(
//               textFieldConfiguration: textFieldConfiguration.copyWith(
//                 enabled: state.enabled,
//                 controller: state._typeAheadController,
//                 style: state.enabled
//                     ? textFieldConfiguration.style
//                     : theme.textTheme.titleMedium!.copyWith(
//                         color: theme.disabledColor,
//                       ),
//                 focusNode: state.effectiveFocusNode,
//                 decoration: state.decoration,
//               ),
//               autoFlipListDirection: autoFlipListDirection,
//               autoFlipMinHeight: autoFlipMinHeight,
//               hideKeyboardOnDrag: hideKeyboardOnDrag,
//               ignoreAccessibleNavigation: ignoreAccessibleNavigation,
//               intercepting: intercepting,
//               itemSeparatorBuilder: itemSeparatorBuilder,
//               layoutArchitecture: layoutArchitecture,
//               minCharsForSuggestions: minCharsForSuggestions,
//               onSuggestionsBoxToggle: onSuggestionsBoxToggle,
//               // TODO HACK to satisfy strictness
//               suggestionsCallback: suggestionsCallback,
//               itemBuilder: itemBuilder,
//               transitionBuilder: (context, suggestionsBox, controller) =>
//                   suggestionsBox,
//               onSuggestionSelected: (T suggestion) {
//                 state.didChange(selectionToTextCallback.call(suggestion));
//                 onSuggestionSelected?.call(suggestion);
//               },
//               getImmediateSuggestions: getImmediateSuggestions,
//               errorBuilder: errorBuilder,
//               noItemsFoundBuilder: noItemsFoundBuilder,
//               loadingBuilder: loadingBuilder,
//               debounceDuration: debounceDuration,
//               suggestionsBoxDecoration: suggestionsBoxDecoration,
//               suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
//               animationDuration: animationDuration,
//               animationStart: animationStart,
//               direction: direction,
//               hideOnLoading: hideOnLoading,
//               hideOnEmpty: hideOnEmpty,
//               hideOnError: hideOnError,
//               hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
//               keepSuggestionsOnLoading: keepSuggestionsOnLoading,
//               autoFlipDirection: autoFlipDirection,
//               suggestionsBoxController: suggestionsBoxController,
//               keepSuggestionsOnSuggestionSelected:
//                   keepSuggestionsOnSuggestionSelected,
//               hideKeyboard: hideKeyboard,
//               scrollController: scrollController,
//             );
//           },
//         );

//   @override
//   FormBuilderTypeAheadState<T> createState() => FormBuilderTypeAheadState<T>();
// }

// class FormBuilderTypeAheadState<T> extends FormBuilderFieldDecorationState<
//     FormBuilderTypeAheadTupple<T>, String> {
//   late TextEditingController _typeAheadController;

//   @override
//   void initState() {
//     super.initState();
//     _typeAheadController = widget.controller ??
//         TextEditingController(text: _getTextString(initialValue ?? ""));
//   }

//   @override
//   void didChange(String? value) {
//     super.didChange(value);
//     String text = _getTextString(value);

//     if (_typeAheadController.text != text) {
//       _typeAheadController.text = text;
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose the _typeAheadController when initState created it
//     super.dispose();
//     _typeAheadController.dispose();
//   }

//   @override
//   void reset() {
//     super.reset();

//     _typeAheadController.text = _getTextString(initialValue);
//   }

//   String _getTextString(String? value) {
//     String text = value == null
//         ? ''
//         : widget.selectionToTextTransformer != null
//             ? widget.selectionToTextTransformer!(value)
//             : value.toString();

//     return text;
//   }
// }

// class TypeAheadFieldTuple<T> extends StatefulWidget {
//   /// Called with the search pattern to get the search suggestions.
//   ///
//   /// This callback must not be null. It is be called by the TypeAhead widget
//   /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
//   /// of suggestions either synchronously, or asynchronously (as the result of a
//   /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
//   /// Typically, the list of suggestions should not contain more than 4 or 5
//   /// entries. These entries will then be provided to [itemBuilder] to display
//   /// the suggestions.
//   ///
//   /// Example:
//   /// ```dart
//   /// suggestionsCallback: (pattern) async {
//   ///   return await _getSuggestions(pattern);
//   /// }
//   /// ```
//   final SuggestionsCallback<T> suggestionsCallback;

//   /// Called when a suggestion is tapped.
//   ///
//   /// This callback must not be null. It is called by the TypeAhead widget and
//   /// provided with the value of the tapped suggestion.
//   ///
//   /// For example, you might want to navigate to a specific view when the user
//   /// tabs a suggestion:
//   /// ```dart
//   /// onSuggestionSelected: (suggestion) {
//   ///   Navigator.of(context).push(MaterialPageRoute(
//   ///     builder: (context) => SearchResult(
//   ///       searchItem: suggestion
//   ///     )
//   ///   ));
//   /// }
//   /// ```
//   ///
//   /// Or to set the value of the text field:
//   /// ```dart
//   /// onSuggestionSelected: (suggestion) {
//   ///   _controller.text = suggestion['name'];
//   /// }
//   /// ```
//   final SuggestionSelectionCallback<T> onSuggestionSelected;

//   /// Called for each suggestion returned by [suggestionsCallback] to build the
//   /// corresponding widget.
//   ///
//   /// This callback must not be null. It is called by the TypeAhead widget for
//   /// each suggestion, and expected to build a widget to display this
//   /// suggestion's info. For example:
//   ///
//   /// ```dart
//   /// itemBuilder: (context, suggestion) {
//   ///   return ListTile(
//   ///     title: Text(suggestion['name']),
//   ///     subtitle: Text('USD' + suggestion['price'].toString())
//   ///   );
//   /// }
//   /// ```
//   final ItemBuilder<T> itemBuilder;
//   final IndexedWidgetBuilder? itemSeparatorBuilder;

//   /// By default, we render the suggestions in a ListView, using
//   /// the `itemBuilder` to construct each element of the list.  Specify
//   /// your own `layoutArchitecture` if you want to be responsible
//   /// for layinng out the widgets using some other system (like a grid).
//   final LayoutArchitecture? layoutArchitecture;

//   /// used to control the scroll behavior of item-builder list
//   final ScrollController? scrollController;

//   /// The decoration of the material sheet that contains the suggestions.
//   ///
//   /// If null, default decoration with an elevation of 4.0 is used
//   ///

//   final SuggestionsBoxDecoration suggestionsBoxDecoration;

//   /// Used to control the `_SuggestionsBox`. Allows manual control to
//   /// open, close, toggle, or resize the `_SuggestionsBox`.
//   final SuggestionsBoxController? suggestionsBoxController;

//   /// The duration to wait after the user stops typing before calling
//   /// [suggestionsCallback]
//   ///
//   /// This is useful, because, if not set, a request for suggestions will be
//   /// sent for every character that the user types.
//   ///
//   /// This duration is set by default to 300 milliseconds
//   final Duration debounceDuration;

//   /// Called when waiting for [suggestionsCallback] to return.
//   ///
//   /// It is expected to return a widget to display while waiting.
//   /// For example:
//   /// ```dart
//   /// (BuildContext context) {
//   ///   return Text('Loading...');
//   /// }
//   /// ```
//   ///
//   /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
//   final WidgetBuilder? loadingBuilder;

//   /// Called when [suggestionsCallback] returns an empty array.
//   ///
//   /// It is expected to return a widget to display when no suggestions are
//   /// avaiable.
//   /// For example:
//   /// ```dart
//   /// (BuildContext context) {
//   ///   return Text('No Items Found!');
//   /// }
//   /// ```
//   ///
//   /// If not specified, a simple text is shown
//   final WidgetBuilder? noItemsFoundBuilder;

//   /// Called when [suggestionsCallback] throws an exception.
//   ///
//   /// It is called with the error object, and expected to return a widget to
//   /// display when an exception is thrown
//   /// For example:
//   /// ```dart
//   /// (BuildContext context, error) {
//   ///   return Text('$error');
//   /// }
//   /// ```
//   ///
//   /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
//   final ErrorBuilder? errorBuilder;

//   /// Used to overcome [Flutter issue 98507](https://github.com/flutter/flutter/issues/98507)
//   /// Most commonly experienced when placing the [TypeAheadFormField] on a google map in Flutter Web.
//   final bool intercepting;

//   /// Called to display animations when [suggestionsCallback] returns suggestions
//   ///
//   /// It is provided with the suggestions box instance and the animation
//   /// controller, and expected to return some animation that uses the controller
//   /// to display the suggestion box.
//   ///
//   /// For example:
//   /// ```dart
//   /// transitionBuilder: (context, suggestionsBox, animationController) {
//   ///   return FadeTransition(
//   ///     child: suggestionsBox,
//   ///     opacity: CurvedAnimation(
//   ///       parent: animationController,
//   ///       curve: Curves.fastOutSlowIn
//   ///     ),
//   ///   );
//   /// }
//   /// ```
//   /// This argument is best used with [animationDuration] and [animationStart]
//   /// to fully control the animation.
//   ///
//   /// To fully remove the animation, just return `suggestionsBox`
//   ///
//   /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
//   final AnimationTransitionBuilder? transitionBuilder;

//   /// The duration that [transitionBuilder] animation takes.
//   ///
//   /// This argument is best used with [transitionBuilder] and [animationStart]
//   /// to fully control the animation.
//   ///
//   /// Defaults to 500 milliseconds.
//   final Duration animationDuration;

//   /// Determine the [SuggestionBox]'s direction.
//   ///
//   /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
//   /// and the [_SuggestionsList] will grow **down**.
//   ///
//   /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
//   /// and the [_SuggestionsList] will grow **up**.
//   ///
//   /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
//   final AxisDirection direction;

//   /// The value at which the [transitionBuilder] animation starts.
//   ///
//   /// This argument is best used with [transitionBuilder] and [animationDuration]
//   /// to fully control the animation.
//   ///
//   /// Defaults to 0.25.
//   final double animationStart;

//   /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
//   /// that the TypeAhead widget displays
//   final TextFieldConfiguration textFieldConfiguration;

//   /// How far below the text field should the suggestions box be
//   ///
//   /// Defaults to 5.0
//   final double suggestionsBoxVerticalOffset;

//   /// If set to true, suggestions will be fetched immediately when the field is
//   /// added to the view.
//   ///
//   /// But the suggestions box will only be shown when the field receives focus.
//   /// To make the field receive focus immediately, you can set the `autofocus`
//   /// property in the [textFieldConfiguration] to true
//   ///
//   /// Defaults to false
//   final bool getImmediateSuggestions;

//   /// If set to true, no loading box will be shown while suggestions are
//   /// being fetched. [loadingBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnLoading;

//   /// If set to true, nothing will be shown if there are no results.
//   /// [noItemsFoundBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnEmpty;

//   /// If set to true, nothing will be shown if there is an error.
//   /// [errorBuilder] will also be ignored.
//   ///
//   /// Defaults to false.
//   final bool hideOnError;

//   /// If set to false, the suggestions box will stay opened after
//   /// the keyboard is closed.
//   ///
//   /// Defaults to true.
//   final bool hideSuggestionsOnKeyboardHide;

//   /// If set to false, the suggestions box will show a circular
//   /// progress indicator when retrieving suggestions.
//   ///
//   /// Defaults to true.
//   final bool keepSuggestionsOnLoading;

//   /// If set to true, the suggestions box will remain opened even after
//   /// selecting a suggestion.
//   ///
//   /// Note that if this is enabled, the only way
//   /// to close the suggestions box is either manually via the
//   /// `SuggestionsBoxController` or when the user closes the software
//   /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
//   /// with a physical keyboard will be unable to close the
//   /// box without a manual way via `SuggestionsBoxController`.
//   ///
//   /// Defaults to false.
//   final bool keepSuggestionsOnSuggestionSelected;

//   /// If set to true, in the case where the suggestions box has less than
//   /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
//   /// will be temporarily flipped if there's more room available in the opposite
//   /// direction.
//   ///
//   /// Defaults to false
//   final bool autoFlipDirection;

//   /// If set to false, suggestion list will not be reversed according to the
//   /// [autoFlipDirection] property.
//   ///
//   /// Defaults to true.
//   final bool autoFlipListDirection;

//   /// Minimum height below [autoFlipDirection] is triggered
//   ///
//   /// Defaults to 64.0.
//   final double autoFlipMinHeight;

//   final bool hideKeyboard;

//   /// The minimum number of characters which must be entered before
//   /// [suggestionsCallback] is triggered.
//   ///
//   /// Defaults to 0.
//   final int minCharsForSuggestions;

//   /// If set to true and if the user scrolls through the suggestion list, hide the keyboard automatically.
//   /// If set to false, the keyboard remains visible.
//   /// Throws an exception, if hideKeyboardOnDrag and hideSuggestionsOnKeyboardHide are both set to true as
//   /// they are mutual exclusive.
//   ///
//   /// Defaults to false
//   final bool hideKeyboardOnDrag;

//   /// Allows a bypass of a problem on Flutter 3.7+ with the accessibility through Overlay
//   /// that prevents flutter_typeahead to register a click on the list of suggestions properly.
//   ///
//   /// Defaults to false
//   final bool ignoreAccessibleNavigation;

//   // Adds a callback for the suggestion box opening or closing
//   final void Function(bool)? onSuggestionsBoxToggle;

//   /// Creates a [TypeAheadField]
//   const TypeAheadFieldTuple({
//     required this.suggestionsCallback,
//     required this.itemBuilder,
//     this.itemSeparatorBuilder,
//     this.layoutArchitecture,
//     this.intercepting = false,
//     required this.onSuggestionSelected,
//     this.textFieldConfiguration = const TextFieldConfiguration(),
//     this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
//     this.debounceDuration = const Duration(milliseconds: 300),
//     this.suggestionsBoxController,
//     this.scrollController,
//     this.loadingBuilder,
//     this.noItemsFoundBuilder,
//     this.errorBuilder,
//     this.transitionBuilder,
//     this.animationStart = 0.25,
//     this.animationDuration = const Duration(milliseconds: 500),
//     this.getImmediateSuggestions = false,
//     this.suggestionsBoxVerticalOffset = 5.0,
//     this.direction = AxisDirection.down,
//     this.hideOnLoading = false,
//     this.hideOnEmpty = false,
//     this.hideOnError = false,
//     this.hideSuggestionsOnKeyboardHide = true,
//     this.keepSuggestionsOnLoading = true,
//     this.keepSuggestionsOnSuggestionSelected = false,
//     this.autoFlipDirection = false,
//     this.autoFlipListDirection = true,
//     this.autoFlipMinHeight = 64.0,
//     this.hideKeyboard = false,
//     this.minCharsForSuggestions = 0,
//     this.onSuggestionsBoxToggle,
//     this.hideKeyboardOnDrag = false,
//     this.ignoreAccessibleNavigation = false,
//     super.key,
//   })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
//         assert(
//             direction == AxisDirection.down || direction == AxisDirection.up),
//         assert(minCharsForSuggestions >= 0),
//         assert(!hideKeyboardOnDrag ||
//             hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide);

//   @override
//   State<TypeAheadFieldTuple<T>> createState() => _TypeAheadFieldTupleState<T>();
// }

// class _TypeAheadFieldTupleState<T> extends State<TypeAheadFieldTuple<T>>
//     with WidgetsBindingObserver {
//   FocusNode? _focusNode;
//   final KeyboardSuggestionSelectionNotifier
//       _keyboardSuggestionSelectionNotifier =
//       KeyboardSuggestionSelectionNotifier();
//   TextEditingController? _textEditingController;
//   SuggestionsBox? _suggestionsBox;

//   TextEditingController? get _effectiveController =>
//       widget.textFieldConfiguration.controller ?? _textEditingController;
//   FocusNode? get _effectiveFocusNode =>
//       widget.textFieldConfiguration.focusNode ?? _focusNode;
//   late VoidCallback _focusNodeListener;

//   final LayerLink _layerLink = LayerLink();

//   // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
//   Timer? _resizeOnScrollTimer;
//   // The rate at which the suggestion box will resize when the user is scrolling
//   final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);
//   // Will have a value if the typeahead is inside a scrollable widget
//   ScrollPosition? _scrollPosition;

//   // Keyboard detection
//   final Stream<bool>? _keyboardVisibility =
//       (supportedPlatform) ? KeyboardVisibilityController().onChange : null;
//   late StreamSubscription<bool>? _keyboardVisibilitySubscription;

//   bool _areSuggestionsFocused = false;
//   late final _shouldRefreshSuggestionsFocusIndex =
//       ShouldRefreshSuggestionFocusIndexNotifier(
//           textFieldFocusNode: _effectiveFocusNode);

//   @override
//   void didChangeMetrics() {
//     // Catch keyboard event and orientation change; resize suggestions list
//     this._suggestionsBox!.onChangeMetrics();
//   }

//   @override
//   void dispose() {
//     this._suggestionsBox!.close();
//     this._suggestionsBox!.widgetMounted = false;
//     WidgetsBinding.instance.removeObserver(this);
//     _keyboardVisibilitySubscription?.cancel();
//     _effectiveFocusNode!.removeListener(_focusNodeListener);
//     _focusNode?.dispose();
//     _resizeOnScrollTimer?.cancel();
//     _scrollPosition?.removeListener(_scrollResizeListener);
//     _textEditingController?.dispose();
//     _keyboardSuggestionSelectionNotifier.dispose();
//     super.dispose();
//   }

//   KeyEventResult _onKeyEvent(FocusNode _, RawKeyEvent event) {
//     if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
//         event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
//       // do nothing to avoid puzzling users until keyboard arrow nav is implemented
//     } else {
//       _keyboardSuggestionSelectionNotifier.onKeyboardEvent(event);
//     }
//     return KeyEventResult.ignored;
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     if (widget.textFieldConfiguration.controller == null) {
//       this._textEditingController = TextEditingController();
//     }

//     final textFieldConfigurationFocusNode =
//         widget.textFieldConfiguration.focusNode;
//     if (textFieldConfigurationFocusNode == null) {
//       this._focusNode = FocusNode(onKey: _onKeyEvent);
//     } else if (textFieldConfigurationFocusNode.onKey == null) {
//       // * we add the _onKeyEvent callback to the textFieldConfiguration focusNode
//       textFieldConfigurationFocusNode.onKey = ((node, event) {
//         final keyEventResult = _onKeyEvent(node, event);
//         return keyEventResult;
//       });
//     } else {
//       final onKeyCopy = textFieldConfigurationFocusNode.onKey!;
//       textFieldConfigurationFocusNode.onKey = ((node, event) {
//         _onKeyEvent(node, event);
//         return onKeyCopy(node, event);
//       });
//     }

//     this._suggestionsBox = SuggestionsBox(
//       context,
//       widget.direction,
//       widget.autoFlipDirection,
//       widget.autoFlipListDirection,
//       widget.autoFlipMinHeight,
//     );

//     widget.suggestionsBoxController?.suggestionsBox = this._suggestionsBox;
//     widget.suggestionsBoxController?.effectiveFocusNode =
//         this._effectiveFocusNode;

//     this._focusNodeListener = () {
//       if (_effectiveFocusNode!.hasFocus) {
//         this._suggestionsBox!.open();
//       } else if (!_areSuggestionsFocused) {
//         if (widget.hideSuggestionsOnKeyboardHide) {
//           this._suggestionsBox!.close();
//         }
//       }

//       widget.onSuggestionsBoxToggle?.call(this._suggestionsBox!.isOpened);
//     };

//     this._effectiveFocusNode!.addListener(_focusNodeListener);

//     // hide suggestions box on keyboard closed
//     this._keyboardVisibilitySubscription =
//         _keyboardVisibility?.listen((isVisible) {
//       if (widget.hideSuggestionsOnKeyboardHide && !isVisible) {
//         _effectiveFocusNode!.unfocus();
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((duration) {
//       if (mounted) {
//         this._initOverlayEntry();
//         // calculate initial suggestions list size
//         this._suggestionsBox!.resize();

//         // in case we already missed the focus event
//         if (this._effectiveFocusNode!.hasFocus) {
//           this._suggestionsBox!.open();
//         }
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final scrollableState = Scrollable.maybeOf(context);
//     if (scrollableState != null) {
//       // The TypeAheadField is inside a scrollable widget
//       _scrollPosition = scrollableState.position;

//       _scrollPosition!.removeListener(_scrollResizeListener);
//       _scrollPosition!.isScrollingNotifier.addListener(_scrollResizeListener);
//     }
//   }

//   void _scrollResizeListener() {
//     bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
//     _resizeOnScrollTimer?.cancel();
//     if (isScrolling) {
//       // Scroll started
//       _resizeOnScrollTimer =
//           Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
//         _suggestionsBox!.resize();
//       });
//     } else {
//       // Scroll finished
//       _suggestionsBox!.resize();
//     }
//   }

//   void _initOverlayEntry() {
//     this._suggestionsBox!.overlayEntry = OverlayEntry(
//       builder: (context) {
//         void giveTextFieldFocus() {
//           _effectiveFocusNode?.requestFocus();
//           _areSuggestionsFocused = false;
//         }

//         void onSuggestionFocus() {
//           if (!_areSuggestionsFocused) {
//             _areSuggestionsFocused = true;
//           }
//         }

//         final suggestionsList = SuggestionsList<T>(
//           suggestionsBox: _suggestionsBox,
//           decoration: widget.suggestionsBoxDecoration,
//           debounceDuration: widget.debounceDuration,
//           intercepting: widget.intercepting,
//           controller: this._effectiveController,
//           loadingBuilder: widget.loadingBuilder,
//           scrollController: widget.scrollController,
//           noItemsFoundBuilder: widget.noItemsFoundBuilder,
//           errorBuilder: widget.errorBuilder,
//           transitionBuilder: widget.transitionBuilder,
//           suggestionsCallback: widget.suggestionsCallback,
//           animationDuration: widget.animationDuration,
//           animationStart: widget.animationStart,
//           getImmediateSuggestions: widget.getImmediateSuggestions,
//           onSuggestionSelected: (selection) {
//             if (!widget.keepSuggestionsOnSuggestionSelected) {
//               this._effectiveFocusNode!.unfocus();
//               this._suggestionsBox!.close();
//             }
//             widget.onSuggestionSelected(selection);
//           },
//           itemBuilder: widget.itemBuilder,
//           itemSeparatorBuilder: widget.itemSeparatorBuilder,
//           layoutArchitecture: widget.layoutArchitecture,
//           direction: _suggestionsBox!.direction,
//           hideOnLoading: widget.hideOnLoading,
//           hideOnEmpty: widget.hideOnEmpty,
//           hideOnError: widget.hideOnError,
//           keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
//           minCharsForSuggestions: widget.minCharsForSuggestions,
//           keyboardSuggestionSelectionNotifier:
//               _keyboardSuggestionSelectionNotifier,
//           shouldRefreshSuggestionFocusIndexNotifier:
//               _shouldRefreshSuggestionsFocusIndex,
//           giveTextFieldFocus: giveTextFieldFocus,
//           onSuggestionFocus: onSuggestionFocus,
//           onKeyEvent: _onKeyEvent,
//           hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
//         );

//         double w = _suggestionsBox!.textBoxWidth;
//         if (widget.suggestionsBoxDecoration.constraints != null) {
//           if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
//               widget.suggestionsBoxDecoration.constraints!.maxWidth !=
//                   double.infinity) {
//             w = (widget.suggestionsBoxDecoration.constraints!.minWidth +
//                     widget.suggestionsBoxDecoration.constraints!.maxWidth) /
//                 2;
//           } else if (widget.suggestionsBoxDecoration.constraints!.minWidth !=
//                   0.0 &&
//               widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
//             w = widget.suggestionsBoxDecoration.constraints!.minWidth;
//           } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth !=
//                   double.infinity &&
//               widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
//             w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
//           }
//         }

//         final Widget compositedFollower = CompositedTransformFollower(
//           link: this._layerLink,
//           showWhenUnlinked: false,
//           offset: Offset(
//               widget.suggestionsBoxDecoration.offsetX,
//               _suggestionsBox!.direction == AxisDirection.down
//                   ? _suggestionsBox!.textBoxHeight +
//                       widget.suggestionsBoxVerticalOffset
//                   : -widget.suggestionsBoxVerticalOffset),
//           child: _suggestionsBox!.direction == AxisDirection.down
//               ? suggestionsList
//               : FractionalTranslation(
//                   translation:
//                       const Offset(0.0, -1.0), // visually flips list to go up
//                   child: suggestionsList,
//                 ),
//         );

//         // When wrapped in the Positioned widget, the suggestions box widget
//         // is placed before the Scaffold semantically. In order to have the
//         // suggestions box navigable from the search input or keyboard,
//         // Semantics > Align > ConstrainedBox are needed. This does not change
//         // the style visually. However, when VO/TB are not enabled it is
//         // necessary to use the Positioned widget to allow the elements to be
//         // properly tappable.
//         return MediaQuery.of(context).accessibleNavigation &&
//                 !widget.ignoreAccessibleNavigation
//             ? Semantics(
//                 container: true,
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(maxWidth: w),
//                     child: compositedFollower,
//                   ),
//                 ),
//               )
//             : Positioned(
//                 width: w,
//                 child: compositedFollower,
//               );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: this._layerLink,
//       child: PointerInterceptor(
//         intercepting: widget.intercepting,
//         child: TextField(
//           focusNode: this._effectiveFocusNode,
//           controller: this._effectiveController,
//           decoration: widget.textFieldConfiguration.decoration,
//           style: widget.textFieldConfiguration.style,
//           textAlign: widget.textFieldConfiguration.textAlign,
//           enabled: widget.textFieldConfiguration.enabled,
//           keyboardType: widget.textFieldConfiguration.keyboardType,
//           autofocus: widget.textFieldConfiguration.autofocus,
//           inputFormatters: widget.textFieldConfiguration.inputFormatters,
//           autocorrect: widget.textFieldConfiguration.autocorrect,
//           expands: widget.textFieldConfiguration.expands,
//           maxLines: widget.textFieldConfiguration.maxLines,
//           textAlignVertical: widget.textFieldConfiguration.textAlignVertical,
//           minLines: widget.textFieldConfiguration.minLines,
//           maxLength: widget.textFieldConfiguration.maxLength,
//           maxLengthEnforcement:
//               widget.textFieldConfiguration.maxLengthEnforcement,
//           obscureText: widget.textFieldConfiguration.obscureText,
//           onChanged: widget.textFieldConfiguration.onChanged,
//           onSubmitted: widget.textFieldConfiguration.onSubmitted,
//           onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
//           onTap: widget.textFieldConfiguration.onTap,
//           onTapOutside: widget.textFieldConfiguration.onTapOutside,
//           scrollPadding: widget.textFieldConfiguration.scrollPadding,
//           textInputAction: widget.textFieldConfiguration.textInputAction,
//           textCapitalization: widget.textFieldConfiguration.textCapitalization,
//           keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
//           cursorWidth: widget.textFieldConfiguration.cursorWidth,
//           cursorRadius: widget.textFieldConfiguration.cursorRadius,
//           cursorColor: widget.textFieldConfiguration.cursorColor,
//           textDirection: widget.textFieldConfiguration.textDirection,
//           enableInteractiveSelection:
//               widget.textFieldConfiguration.enableInteractiveSelection,
//           readOnly: widget.hideKeyboard,
//           autofillHints: widget.textFieldConfiguration.autofillHints,
//         ),
//       ),
//     );
//   }
// }
