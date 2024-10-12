import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ListTileEdit extends ListTile {
  ListTileEdit({
    required BuildContext context,
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense = true,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.titleTextStyle,
    super.subtitleTextStyle,
    super.leadingAndTrailingTextStyle,
    super.enabled = true,
    super.onTap,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
    super.minTileHeight,
    super.titleAlignment,
  }) : super(
            tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16));
}

class ExpansionEdit extends StatefulWidget {
  final bool initiallyExpanded;

  /// Typically used to force the expansion arrow icon to the tile's leading or trailing edge.
  ///
  /// By default, the value of [controlAffinity] is [ListTileControlAffinity.platform],
  /// which means that the expansion arrow icon will appear on the tile's trailing edge.
  final ListTileControlAffinity? controlAffinity;

  /// Specifies whether the state of the children is maintained when the tile expands and collapses.
  ///
  /// When true, the children are kept in the tree while the tile is collapsed.
  /// When false (default), the children are removed from the tree when the tile is
  /// collapsed and recreated upon expansion.
  final bool maintainState;

  final String name;

  final ViewAbstract viewAbstract;
  final dynamic valueFromParent;

  /// Parent Form Key
  final GlobalKey<FormBuilderState>? parentFormKey;

  /// Nested Form Key
  final GlobalKey<FormBuilderState> formKey;
  ExpansionEdit({
    super.key,
    this.initiallyExpanded = false,
    this.controlAffinity,
    this.valueFromParent,
    required this.viewAbstract,
    this.maintainState = true,
    required this.name,
    GlobalKey<FormBuilderState>? formKey,
    this.parentFormKey,
  }) : formKey = formKey ?? GlobalKey<FormBuilderState>();

  @override
  State<ExpansionEdit> createState() => _ExpansionEditState();
}

class _ExpansionEditState extends State<ExpansionEdit>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();
  final CurveTween _heightFactorTween = CurveTween(curve: Curves.easeIn);

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool canExpand = true;
  bool _isNullPressed = false;
  bool hasAutoCompleteFieldValue = false;
  String fieldThatHasAutoComplete = "";
  bool _isExpanded = false;
  Timer? _timer;
  Map<String, dynamic>? convertableMap;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_heightFactorTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _border = _animationController.drive(_borderTween.chain(_easeOutTween));
    _headerColor =
        _animationController.drive(_headerColorTween.chain(_easeInTween));
    _iconColor =
        _animationController.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _animationController.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
    hasAutoCompleteFieldValue = hasAutoCompleteField();
  }

  @override
  void didUpdateWidget(covariant ExpansionEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    // if (widget.collapsedShape != oldWidget.collapsedShape ||
    //     widget.shape != oldWidget.shape) {
    //   _updateShapeBorder(expansionTileTheme, theme);
    // }
    // if (widget.collapsedTextColor != oldWidget.collapsedTextColor ||
    //     widget.textColor != oldWidget.textColor) {
    //   _updateHeaderColor(expansionTileTheme, defaults);
    // }
    // if (widget.collapsedIconColor != oldWidget.collapsedIconColor ||
    //     widget.iconColor != oldWidget.iconColor) {
    //   _updateIconColor(expansionTileTheme, defaults);
    // }
    // if (widget.backgroundColor != oldWidget.backgroundColor ||
    //     widget.collapsedBackgroundColor != oldWidget.collapsedBackgroundColor) {
    //   _updateBackgroundColor(expansionTileTheme);
    // }
    // if (widget.expansionAnimationStyle != oldWidget.expansionAnimationStyle) {
    //   _updateAnimationDuration(expansionTileTheme);
    //   _updateHeightFactorCurve(expansionTileTheme);
    // }
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    _updateAnimationDuration(expansionTileTheme);
    _updateShapeBorder(expansionTileTheme, theme);
    _updateHeaderColor(expansionTileTheme, defaults);
    _updateIconColor(expansionTileTheme, defaults);
    _updateBackgroundColor(expansionTileTheme);
    _updateHeightFactorCurve(expansionTileTheme);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _updateAnimationDuration(ExpansionTileThemeData expansionTileTheme) {
    _animationController.duration =
        expansionTileTheme.expansionAnimationStyle?.duration ?? _kExpand;
  }

  void _updateShapeBorder(
      ExpansionTileThemeData expansionTileTheme, ThemeData theme) {
    _borderTween
      ..begin = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)))
      ..end = const RoundedRectangleBorder(

          // side: BorderSide(
          // width: 1,
          // color: _iconColor.value ?? Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)));
  }

  void _updateHeaderColor(ExpansionTileThemeData expansionTileTheme,
      ExpansionTileThemeData defaults) {
    _headerColorTween
      ..begin = defaults.collapsedTextColor
      ..end = defaults.textColor;
  }

  void _updateIconColor(ExpansionTileThemeData expansionTileTheme,
      ExpansionTileThemeData defaults) {
    _iconColorTween
      ..begin = defaults.collapsedIconColor
      ..end = defaults.iconColor;
  }

  void _updateBackgroundColor(ExpansionTileThemeData expansionTileTheme) {
    _backgroundColorTween
      ..begin = Theme.of(context).colorScheme.surfaceContainerLow
      ..end = Theme.of(context).colorScheme.surfaceContainer;
  }

  void _updateHeightFactorCurve(ExpansionTileThemeData expansionTileTheme) {
    _heightFactorTween.curve =
        expansionTileTheme.expansionAnimationStyle?.curve ?? Curves.easeIn;
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  // Platform or null affinity defaults to trailing.
  ListTileControlAffinity _effectiveAffinity(
      ListTileControlAffinity? affinity) {
    switch (affinity ?? ListTileControlAffinity.trailing) {
      case ListTileControlAffinity.leading:
        return ListTileControlAffinity.leading;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        return ListTileControlAffinity.trailing;
    }
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) !=
        ListTileControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getChildrens() ?? [],
          ),
        ),
      ),
    );

    Widget d = AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
    return FormBuilderField<Map<String, dynamic>>(
      name: widget.name,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) {
        debugPrint("BaseEditFinalSub validater $v");
        return widget.formKey.currentState?.validate(
                    autoScrollWhenFocusOnInvalid: false,
                    focusOnInvalid: false) ??
                false
            ? null
            : "Error";
      },
      initialValue:
          widget.parentFormKey?.currentState?.initialValue[widget.name],
      valueTransformer: (value) {
        debugPrint("BaseEditFinalSub valueTransformer ${widget.name}:$value");
        return value;
      },
      onReset: () => widget.formKey.currentState?.reset(),
      builder: (field) {
        debugPrint("BaseEditFinalSub builder ${widget.name}:${field.value}");
        convertableMap ??= toJsonViewAbstractForm(field.value);
        return FormBuilder(
          key: widget.formKey,
          initialValue: convertableMap ?? {},
          onChanged: () {
            final st = widget.formKey.currentState;
            if (st == null) return;
            bool res = st.saveAndValidate(
                autoScrollWhenFocusOnInvalid: false, focusOnInvalid: false);
            field.didChange(st.value);
            debugPrint("\n");
            debugPrint(
                "BaseEditFinalSub $res=>onChanged=>${widget.name}:${widget.formKey.currentState?.value}");
          },
          // autovalidateMode: AutovalidateMode.always,

          //  onWillPop: onWillPop,
          skipDisabled: !isFormEnabled(),
          enabled: isFormEnabled(),
          //  autoFocusOnValidationFailure: autoFocusOnValidationFailure,

          child: d,
        );
      },
    );
  }

  bool isFormEnabled() {
    return widget.viewAbstract.getParnet?.isFieldEnabled(widget.name) ?? true;
  }

  bool isNullable() {
    return widget.viewAbstract.getParnet
            ?.isFieldCanBeNullable(context, widget.name) ??
        false;
  }

  Map<String, dynamic> toJsonViewAbstractForm(Map<String, dynamic>? map) {
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

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final Color backgroundColor = _backgroundColor.value ??
        expansionTileTheme.backgroundColor ??
        Colors.transparent;
    final ShapeBorder expansionTileBorder = _border.value ??
        const Border(
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Colors.transparent),
        );
    final Clip clipBehavior = expansionTileTheme.clipBehavior ?? Clip.antiAlias;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = _isExpanded
        ? localizations.expansionTileExpandedTapHint
        : localizations.expansionTileCollapsedTapHint;
    String? semanticsHint;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        semanticsHint = _isExpanded
            ? '${localizations.collapsedHint}\n ${localizations.expansionTileExpandedHint}'
            : '${localizations.expandedHint}\n ${localizations.expansionTileCollapsedHint}';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        break;
    }

    final Decoration decoration = ShapeDecoration(
      color: backgroundColor,
      shape: expansionTileBorder,
    );

    final Widget tile = Padding(
      padding: decoration.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Semantics(
            hint: semanticsHint,
            onTapHint: onTapHint,
            child: ListTileTheme.merge(
              iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
              textColor: _headerColor.value,
              child: ListTile(
                // leadingAndTrailingTextStyle: ,
                onTap: _handleTap,
                contentPadding: EdgeInsets.zero,
                // leading: widget.leading,
                title: getTitle(),

                trailing: getTrailing(),
                // minTileHeight: widget.minTileHeight,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment:
                  expansionTileTheme.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );

    const bool isShapeProvided = false;
    //todo check this
    //  widget.shape != null ||
    //     expansionTileTheme.shape != null ||
    //     widget.collapsedShape != null ||
    // expansionTileTheme.collapsedShape != null;

    //When we foucus this will hightlight color to the card
    // if (isShapeProvided) {
    //   return Material(
    //     clipBehavior: clipBehavior,
    //     color: backgroundColor,
    //     shape: expansionTileBorder,
    //     child: tile,
    //   );
    // }

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: tile,
      ),
    );
  }

  Widget? getTrailing() {
    if (!hasChildrens()) return null;
    return isNullable()
        ? ElevatedButton(
            // style: ,

            // iconAlignment: IconAlignment.end,

            // padding: EdgeInsets.zero,
            onPressed: () {
              _toggleExpansion(expand: false);
              _isNullPressed = true;
            },
            child: Text(
              "—",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            )
            // color: _isExpanded
            //     ? _iconColor.value
            //     : Theme.of(context).colorScheme.error,
            )
        : null;
  }

  bool hasAutoCompleteField() {
    return widget.viewAbstract.getMainFields(context: context).firstWhereOrNull(
          (v) {
            bool res = widget.viewAbstract
                .getTextInputTypeIsAutoCompleteViewAbstract(v);
            debugPrint("ExpansionEdit hasAutoCompleteField $res to field $v");
            if (res) {
              fieldThatHasAutoComplete = v;
            }
            return res;
          },
        ) !=
        null;
  }

  Widget getTitle() {
    if (hasChildrens()) {
      return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _toggleExpansion(expand: hasFocus);
            }
          },
          child: widget.viewAbstract.getFormMainControllerWidget(
              context: context,
              field: fieldThatHasAutoComplete,
              formKey: widget.formKey,
              parent: widget.viewAbstract.getParnet));
    } else {
      return const Text("TITL");
    }
  }

  List<Widget>? getChildrens() {
    if (hasChildrens()) {
      return widget.viewAbstract
          .getMainFields()
          .where((p) => p != fieldThatHasAutoComplete)
          .map((f) => widget.viewAbstract.getFormMainControllerWidget(
              context: context,
              field: f,
              formKey: widget.formKey,
              parent: widget.viewAbstract.getParnet))
          .toList();
    }
    return null;
  }

  bool hasChildrens() {
    if (hasAutoCompleteFieldValue) {
      return true;
    }
    return false;
  }

  FormBuilderTextField getTextField(String key) {
    return FormBuilderTextField(
      maxLines: 1,
      // controller: text,
      name: key,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "HINT",
          icon: Icon(
            Icons.access_alarms_outlined,
            color: _iconColor.value,
          )),
    );
  }

  TextEditingController text = TextEditingController();

  void _handleTap() {
    if (!hasChildrens()) return;
    _toggleExpansion();
  }

  void _toggleExpansion({bool? expand}) {
    if (expand == _isExpanded) return;

    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint = expand ?? _isExpanded
        ? localizations.expandedHint
        : localizations.collapsedHint;
    setState(() {
      _isExpanded = expand ?? !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {
        SemanticsService.announce(stateHint, textDirection);
        _timer?.cancel();
        _timer = null;
      });
    } else {
      SemanticsService.announce(stateHint, textDirection);
    }
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ExpansionTile

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _ExpansionTileDefaultsM3 extends ExpansionTileThemeData {
  _ExpansionTileDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get textColor => _colors.onSurface;

  @override
  Color? get iconColor => _colors.primary;

  @override
  Color? get collapsedTextColor => _colors.onSurface;

  @override
  Color? get collapsedIconColor => _colors.onSurfaceVariant;
}

// END GENERATED TOKEN PROPERTIES - ExpansionTile
