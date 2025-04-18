import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

typedef SelectionToTextTransformer<T> = String Function(T suggestion);

@Deprecated("use TypeAheadField directly")

/// Text field that auto-completes user input from a list of items
class FormBuilderTypeAheadCustom<T> extends FormBuilderField<T> {
  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The text field
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, but the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  ///
  /// ## Limitations
  ///
  /// The text field does not currently count Unicode grapheme clusters (i.e.
  /// characters visible to the user), it counts Unicode scalar values, which
  /// leaves out a number of useful possible characters (like many emoji and
  /// composed characters), so this will be inaccurate in the presence of those
  /// characters. If you expect to encounter these kinds of characters, be
  /// generous in the maxLength used.
  ///
  /// For instance, the character "ö" can be represented as '\u{006F}\u{0308}',
  /// which is the letter "o" followed by a composed diaeresis "¨", or it can
  /// be represented as '\u{00F6}', which is the Unicode scalar value "LATIN
  /// SMALL LETTER O WITH DIAERESIS". In the first case, the text field will
  /// count two characters, and the second case will be counted as one
  /// character, even though the user can see no difference in the input.
  ///
  /// Similarly, some emoji are represented by multiple scalar values. The
  /// Unicode "THUMBS UP SIGN + MEDIUM SKIN TONE MODIFIER", "👍🏽", should be
  /// counted as a single character, but because it is a combination of two
  /// Unicode scalar values, '\u{1F44D}\u{1F3FD}', it is counted as two
  /// characters.
  ///
  /// See also:
  ///
  ///  * [LengthLimitingTextInputFormatter] for more information on how it
  ///    counts characters, and how it may differ from the intuitive meaning.
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Called with the search pattern to get the search suggestions.
  ///
  /// This callback must not be null. It is be called by the TypeAhead widget
  /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
  /// of suggestions either synchronously, or asynchronously (as the result of a
  /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
  /// Typically, the list of suggestions should not contain more than 4 or 5
  /// entries. These entries will then be provided to [itemBuilder] to display
  /// the suggestions.
  ///
  /// Example:
  /// ```dart
  /// suggestionsCallback: (pattern) async {
  ///   return await _getSuggestions(pattern);
  /// }
  /// ```
  final SuggestionsCallback<T> suggestionsCallback;

  /// Called when a suggestion is tapped.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget and
  /// provided with the value of the tapped suggestion.
  ///
  /// For example, you might want to navigate to a specific view when the user
  /// tabs a suggestion:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   Navigator.of(context).push(MaterialPageRoute(
  ///     builder: (context) => SearchResult(
  ///       searchItem: suggestion
  ///     )
  ///   ));
  /// }
  /// ```
  ///
  /// Or to set the value of the text field:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   _controller.text = suggestion['name'];
  /// }
  /// ```
  final SuggestionSelectionCallback<T>? onSuggestionSelected;

  /// Called for each suggestion returned by [suggestionsCallback] to build the
  /// corresponding widget.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget for
  /// each suggestion, and expected to build a widget to display this
  /// suggestion's info. For example:
  ///
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion['name']),
  ///     subtitle: Text('USD' + suggestion['price'].toString())
  ///   );
  /// }
  /// ```
  final SuggestionsItemBuilder<T> itemBuilder;

  /// The decoration of the material sheet that contains the suggestions.
  ///
  /// If null, default decoration with an elevation of 4.0 is used
  // final SuggestionsBoxDecoration suggestionsBoxDecoration;

  /// Used to control the `_SuggestionsBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsBox`.
  final SuggestionsController<T>? suggestionsBoxController;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback]
  ///
  /// This is useful, because, if not set, a request for suggestions will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds
  final Duration debounceDuration;

  /// Called when waiting for [suggestionsCallback] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  final WidgetBuilder? loadingBuilder;

  /// Called when [suggestionsCallback] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestions are
  /// available.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  final WidgetBuilder? noItemsFoundBuilder;

  /// Called when [suggestionsCallback] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  final SuggestionsErrorBuilder? errorBuilder;

  /// Called to display animations when [suggestionsCallback] returns suggestions
  ///
  /// It is provided with the suggestions box instance and the animation
  /// controller, and expected to return some animation that uses the controller
  /// to display the suggestion box.
  ///
  /// For example:
  /// ```dart
  /// transitionBuilder: (context, suggestionsBox, animationController) {
  ///   return FadeTransition(
  ///     child: suggestionsBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn
  ///     ),
  ///   );
  /// }
  /// ```
  /// This argument is best used with [animationDuration] and [animationStart]
  /// to fully control the animation.
  ///
  /// To fully remove the animation, just return `suggestionsBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  // final AnimationTransitionBuilder? transitionBuilder;

  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// Determine the [SuggestionBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  final VerticalDirection direction;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final TextField textFieldConfiguration;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.0
  final double suggestionsBoxVerticalOffset;

  /// If set to true, suggestions will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestions box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [textFieldConfiguration] to true
  ///
  /// Defaults to false
  final bool getImmediateSuggestions;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnError;

  /// If set to false, the suggestions box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  final bool hideSuggestionsOnKeyboardHide;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  final bool keepSuggestionsOnLoading;

  /// If set to true, the suggestions box will remain opened even after
  /// selecting a suggestion.
  ///
  /// Note that if this is enabled, the only way
  /// to close the suggestions box is either manually via the
  /// `SuggestionsBoxController` or when the user closes the software
  /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
  /// with a physical keyboard will be unable to close the
  /// box without a manual way via `SuggestionsBoxController`.
  ///
  /// Defaults to false.
  final bool keepSuggestionsOnSuggestionSelected;

  /// If set to true, in the case where the suggestions box has less than
  /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false
  final bool autoFlipDirection;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;
  final SelectionToTextTransformer<T>? selectionToTextTransformer;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final bool hideKeyboard;

  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  final void Function()? onTap;
  T Function(String text) onChangeGetObject;

  /// Creates text field that auto-completes user input from a list of items
  FormBuilderTypeAheadCustom({
    super.key,
    //From Super
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    required super.validator,
    required this.onChangeGetObject,
    InputDecoration decoration = const InputDecoration(),
    required super.name,
    required this.itemBuilder,
    required this.suggestionsCallback,
    this.onTap,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.autoFlipDirection = false,
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.direction = VerticalDirection.up,
    this.errorBuilder,
    this.getImmediateSuggestions = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLengthEnforcement,
    this.maxLength,
    this.hideKeyboard = false,
    this.hideOnEmpty = true,
    this.hideOnError = false,
    this.hideOnLoading = true,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.loadingBuilder,
    this.inputFormatters,
    this.noItemsFoundBuilder,
    this.onSuggestionSelected,
    this.scrollController,
    this.selectionToTextTransformer,
    this.suggestionsBoxController,
    // this.suggestionsBoxDecoration = const SuggestionsBox(),
    this.suggestionsBoxVerticalOffset = 5.0,
    this.textFieldConfiguration = const TextField(),
    // this.transitionBuilder,
  })  : assert(T == String || selectionToTextTransformer != null),
        assert(maxLength == null || maxLength > 0),
        super(
          builder: (FormFieldState<T?> field) {
            final state = field as FormBuilderTypeAheadState<T>;
            final theme = Theme.of(state.context);

            return TypeAheadField<T>(
              decorationBuilder: (context, child) {
                return Material(
                  type: MaterialType.card,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                );
              },
              // TextFieldConfiguration has been removed. You can now directly build your own custom TextField via the builder property. Note that you must use the provided controller and focusNode properties, as they are required for the suggestions box to function.
              builder: (c, e, a) => TextField(
                inputFormatters: inputFormatters,
                maxLengthEnforcement: maxLengthEnforcement,
                textCapitalization: textCapitalization,
                maxLength: maxLength,
                keyboardType: keyboardType,
                enabled: state.enabled,
                // controller: state._typeAheadController,
                controller: e,
                // autofocus: true,//TODO i add this for auto select all text for AutComplete ViewAbstract
                onTap: onTap,
                style: state.enabled
                    ? textFieldConfiguration.style
                    : theme.textTheme.titleMedium!.copyWith(
                        color: theme.disabledColor,
                      ),
                onChanged: (val) {
                  state.didChange(onChangeGetObject(val));
                },
                // focusNode: state.effectiveFocusNode,
                focusNode: a,

                decoration: decoration,
              ),
              suggestionsCallback: suggestionsCallback,
              itemBuilder: itemBuilder,
              // transitionBuilder: (context, suggestionsBox, controller) =>
              //     suggestionsBox,
              // onSuggestionSelected: (T suggestion) {
              //   state.didChange(suggestion);
              //   onSuggestionSelected?.call(suggestion);
              // },
              onSelected: (value) {
                state.didChange(value);
                onSuggestionSelected?.call(value);
              },

              // minCharsForSuggestions: 2,
              // getImmediateSuggestions: getImmediateSuggestions,
              errorBuilder: errorBuilder,
              emptyBuilder: noItemsFoundBuilder,
              loadingBuilder: loadingBuilder,
              debounceDuration: debounceDuration,
              // suggestionsBoxDecoration: suggestionsBoxDecoration,
              // suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
              animationDuration: animationDuration,
              // animationStart: animationStart,
              direction: direction,
              hideOnLoading: hideOnLoading,
              hideOnEmpty: hideOnEmpty,
              hideOnError: hideOnError,
              hideWithKeyboard: hideSuggestionsOnKeyboardHide,
              retainOnLoading: keepSuggestionsOnLoading,
              autoFlipDirection: autoFlipDirection,
              suggestionsController: suggestionsBoxController,
              hideOnSelect: keepSuggestionsOnSuggestionSelected,

              scrollController: scrollController,
            );
          },
        );

  @override
  FormBuilderTypeAheadState<T> createState() => FormBuilderTypeAheadState<T>();
}

class FormBuilderTypeAheadState<T>
    extends FormBuilderFieldState<FormBuilderTypeAheadCustom<T>, T> {
  late TextEditingController _typeAheadController;

  @override
  void initState() {
    super.initState();
    _typeAheadController = widget.controller ??
        TextEditingController(text: _getTextString(initialValue));
    // _typeAheadController.addListener(_handleControllerChanged);
  }

  // void _handleControllerChanged() {
  // Suppress changes that originated from within this class.
  //
  // In the case where a controller has been passed in to this widget, we
  // register this change listener. In these cases, we'll also receive change
  // notifications for changes originating from within this class -- for
  // example, the reset() method. In such cases, the FormField value will
  // already have been set.
  //   if (_typeAheadController.text != value) {
  //     didChange(_typeAheadController.text as T);
  //   }
  // }

  @override
  void didChange(T? value) {
    super.didChange(value);
    var text = _getTextString(value);

    if (_typeAheadController.text != text) {
      _typeAheadController.text = text;
    }
  }

  @override
  void dispose() {
    // Dispose the _typeAheadController when initState created it
    super.dispose();
    _typeAheadController.dispose();
  }

  @override
  void reset() {
    super.reset();

    _typeAheadController.text = _getTextString(initialValue);
  }

  String _getTextString(T? value) {
    debugPrint("CustomTypeAhed  before => $value");
    var text = value == null
        ? ''
        : widget.selectionToTextTransformer != null
            ? widget.selectionToTextTransformer!(value)
            : value.toString();
    debugPrint("CustomTypeAhed  after text => $text");
    return text;
  }
}
