import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

const Duration _kExpand = Duration(milliseconds: 200);

// /// Enables control over a single [ExpansionTile]'s expanded/collapsed state.
// ///
// /// It can be useful to expand or collapse an [ExpansionTile]
// /// programmatically, for example to reconfigure an existing expansion
// /// tile based on a system event. To do so, create an [ExpansionTile]
// /// with an [ExpansionTileController] that's owned by a stateful widget
// /// or look up the tile's automatically created [ExpansionTileController]
// /// with [ExpansionTileController.of]
// ///
// /// The controller's [expand] and [collapse] methods cause the
// /// the [ExpansionTile] to rebuild, so they may not be called from
// /// a build method.
// class ExpansionTileController {
//   /// Create a controller to be used with [ExpansionTile.controller].
//   ExpansionTileController();

//   _ExpansionTileState? _state;

//   /// Whether the [ExpansionTile] built with this controller is in expanded state.
//   ///
//   /// This property doesn't take the animation into account. It reports `true`
//   /// even if the expansion animation is not completed.
//   ///
//   /// See also:
//   ///
//   ///  * [expand], which expands the [ExpansionTile].
//   ///  * [collapse], which collapses the [ExpansionTile].
//   ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
//   bool get isExpanded {
//     assert(_state != null);
//     return _state!._isExpanded;
//   }

//   /// Expands the [ExpansionTile] that was built with this controller;
//   ///
//   /// Normally the tile is expanded automatically when the user taps on the header.
//   /// It is sometimes useful to trigger the expansion programmatically due
//   /// to external changes.
//   ///
//   /// If the tile is already in the expanded state (see [isExpanded]), calling
//   /// this method has no effect.
//   ///
//   /// Calling this method may cause the [ExpansionTile] to rebuild, so it may
//   /// not be called from a build method.
//   ///
//   /// Calling this method will trigger an [ExpansionTile.onExpansionChanged] callback.
//   ///
//   /// See also:
//   ///
//   ///  * [collapse], which collapses the tile.
//   ///  * [isExpanded] to check whether the tile is expanded.
//   ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
//   void expand() {
//     assert(_state != null);
//     if (!isExpanded) {
//       _state!._toggleExpansion();
//     }
//   }

//   /// Collapses the [ExpansionTile] that was built with this controller.
//   ///
//   /// Normally the tile is collapsed automatically when the user taps on the header.
//   /// It can be useful sometimes to trigger the collapse programmatically due
//   /// to some external changes.
//   ///
//   /// If the tile is already in the collapsed state (see [isExpanded]), calling
//   /// this method has no effect.
//   ///
//   /// Calling this method may cause the [ExpansionTile] to rebuild, so it may
//   /// not be called from a build method.
//   ///
//   /// Calling this method will trigger an [ExpansionTile.onExpansionChanged] callback.
//   ///
//   /// See also:
//   ///
//   ///  * [expand], which expands the tile.
//   ///  * [isExpanded] to check whether the tile is expanded.
//   ///  * [ExpansionTile.controller] to create an ExpansionTile with a controller.
//   void collapse() {
//     assert(_state != null);
//     if (isExpanded) {
//       _state!._toggleExpansion();
//     }
//   }

//   /// Finds the [ExpansionTileController] for the closest [ExpansionTile] instance
//   /// that encloses the given context.
//   ///
//   /// If no [ExpansionTile] encloses the given context, calling this
//   /// method will cause an assert in debug mode, and throw an
//   /// exception in release mode.
//   ///
//   /// To return null if there is no [ExpansionTile] use [maybeOf] instead.
//   ///
//   /// {@tool dartpad}
//   /// Typical usage of the [ExpansionTileController.of] function is to call it from within the
//   /// `build` method of a descendant of an [ExpansionTile].
//   ///
//   /// When the [ExpansionTile] is actually created in the same `build`
//   /// function as the callback that refers to the controller, then the
//   /// `context` argument to the `build` function can't be used to find
//   /// the [ExpansionTileController] (since it's "above" the widget
//   /// being returned in the widget tree). In cases like that you can
//   /// add a [Builder] widget, which provides a new scope with a
//   /// [BuildContext] that is "under" the [ExpansionTile]:
//   ///
//   /// ** See code in examples/api/lib/material/expansion_tile/expansion_tile.1.dart **
//   /// {@end-tool}
//   ///
//   /// A more efficient solution is to split your build function into
//   /// several widgets. This introduces a new context from which you
//   /// can obtain the [ExpansionTileController]. With this approach you
//   /// would have an outer widget that creates the [ExpansionTile]
//   /// populated by instances of your new inner widgets, and then in
//   /// these inner widgets you would use [ExpansionTileController.of].
//   static ExpansionTileController of(BuildContext context) {
//     final _ExpansionTileState? result =
//         context.findAncestorStateOfType<_ExpansionTileState>();
//     if (result != null) {
//       return result._tileController;
//     }
//     throw FlutterError.fromParts(<DiagnosticsNode>[
//       ErrorSummary(
//         'ExpansionTileController.of() called with a context that does not contain a ExpansionTile.',
//       ),
//       ErrorDescription(
//         'No ExpansionTile ancestor could be found starting from the context that was passed to ExpansionTileController.of(). '
//         'This usually happens when the context provided is from the same StatefulWidget as that '
//         'whose build function actually creates the ExpansionTile widget being sought.',
//       ),
//       ErrorHint(
//         'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
//         'context that is "under" the ExpansionTile. For an example of this, please see the '
//         'documentation for ExpansionTileController.of():\n'
//         '  https://api.flutter.dev/flutter/material/ExpansionTile/of.html',
//       ),
//       ErrorHint(
//         'A more efficient solution is to split your build function into several widgets. This '
//         'introduces a new context from which you can obtain the ExpansionTile. In this solution, '
//         'you would have an outer widget that creates the ExpansionTile populated by instances of '
//         'your new inner widgets, and then in these inner widgets you would use ExpansionTileController.of().\n'
//         'An other solution is assign a GlobalKey to the ExpansionTile, '
//         'then use the key.currentState property to obtain the ExpansionTile rather than '
//         'using the ExpansionTileController.of() function.',
//       ),
//       context.describeElement('The context used was'),
//     ]);
//   }

//   /// Finds the [ExpansionTile] from the closest instance of this class that
//   /// encloses the given context and returns its [ExpansionTileController].
//   ///
//   /// If no [ExpansionTile] encloses the given context then return null.
//   /// To throw an exception instead, use [of] instead of this function.
//   ///
//   /// See also:
//   ///
//   ///  * [of], a similar function to this one that throws if no [ExpansionTile]
//   ///    encloses the given context. Also includes some sample code in its
//   ///    documentation.
//   static ExpansionTileController? maybeOf(BuildContext context) {
//     return context
//         .findAncestorStateOfType<_ExpansionTileState>()
//         ?._tileController;
//   }
// }

class ExpansionTileCustomExpandToCard extends ExpansionTile {
  const ExpansionTileCustomExpandToCard({
    super.key,
    super.leading,
    required super.title,
    super.subtitle,
    super.onExpansionChanged,
    super.children = const <Widget>[],
    super.trailing,
    super.initiallyExpanded = false,
    super.maintainState = false,
    super.tilePadding,
    super.expandedCrossAxisAlignment,
    super.expandedAlignment,
    super.childrenPadding,
    super.backgroundColor,
    super.collapsedBackgroundColor,
    super.textColor,
    super.collapsedTextColor,
    super.iconColor,
    super.collapsedIconColor,
    super.shape,
    super.collapsedShape,
    super.clipBehavior,
    super.controlAffinity,
    super.controller,
    super.dense,
    super.visualDensity,
    super.minTileHeight,
    super.enableFeedback = true,
    super.enabled = true,
    super.expansionAnimationStyle,
  });

  @override
  State<ExpansionTile> createState() {
    return _ExpansionTileState();
  }
}

class _ExpansionTileState extends State<ExpansionTileCustomExpandToCard>
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

  bool _isExpanded = false;
  late ExpansionTileController _tileController;
  Timer? _timer;

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

    _tileController = widget.controller ?? ExpansionTileController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _toggleExpansion() {
    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint =
        _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
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
    widget.onExpansionChanged?.call(_isExpanded);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // TODO(tahatesser): This is a workaround for VoiceOver interrupting
      // semantic announcements on iOS. https://github.com/flutter/flutter/issues/122101.
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

  void _handleTap() {
    _toggleExpansion();
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

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) !=
        ListTileControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) !=
        ListTileControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
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
    final Clip clipBehavior = widget.clipBehavior ??
        expansionTileTheme.clipBehavior ??
        Clip.antiAlias;
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
                enabled: widget.enabled,
                onTap: _handleTap,
                dense: widget.dense,
                visualDensity: widget.visualDensity,
                enableFeedback: widget.enableFeedback,
                contentPadding:
                    widget.tilePadding ?? expansionTileTheme.tilePadding,
                leading: widget.leading ?? _buildLeadingIcon(context),
                title: widget.title,
                subtitle: widget.subtitle,
                trailing: widget.trailing ?? _buildTrailingIcon(context),
                minTileHeight: widget.minTileHeight,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ??
                  expansionTileTheme.expandedAlignment ??
                  Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );

    final bool isShapeProvided = widget.shape != null ||
        expansionTileTheme.shape != null ||
        widget.collapsedShape != null ||
        expansionTileTheme.collapsedShape != null;

    if (isShapeProvided) {
      return Material(
        clipBehavior: clipBehavior,
        color: backgroundColor,
        shape: expansionTileBorder,
        child: tile,
      );
    }

    return DecoratedBox(
      decoration: decoration,
      child: tile,
    );
  }

  @override
  void didUpdateWidget(covariant ExpansionTileCustomExpandToCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = theme.useMaterial3
        ? _ExpansionTileDefaultsM3(context)
        : _ExpansionTileDefaultsM2(context);
    if (widget.collapsedShape != oldWidget.collapsedShape ||
        widget.shape != oldWidget.shape) {
      _updateShapeBorder(expansionTileTheme, theme);
    }
    if (widget.collapsedTextColor != oldWidget.collapsedTextColor ||
        widget.textColor != oldWidget.textColor) {
      _updateHeaderColor(expansionTileTheme, defaults);
    }
    if (widget.collapsedIconColor != oldWidget.collapsedIconColor ||
        widget.iconColor != oldWidget.iconColor) {
      _updateIconColor(expansionTileTheme, defaults);
    }
    if (widget.backgroundColor != oldWidget.backgroundColor ||
        widget.collapsedBackgroundColor != oldWidget.collapsedBackgroundColor) {
      _updateBackgroundColor(expansionTileTheme);
    }
    if (widget.expansionAnimationStyle != oldWidget.expansionAnimationStyle) {
      _updateAnimationDuration(expansionTileTheme);
      _updateHeightFactorCurve(expansionTileTheme);
    }
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ExpansionTileThemeData defaults = theme.useMaterial3
        ? _ExpansionTileDefaultsM3(context)
        : _ExpansionTileDefaultsM2(context);
    _updateAnimationDuration(expansionTileTheme);
    _updateShapeBorder(expansionTileTheme, theme);
    _updateHeaderColor(expansionTileTheme, defaults);
    _updateIconColor(expansionTileTheme, defaults);
    _updateBackgroundColor(expansionTileTheme);
    _updateHeightFactorCurve(expansionTileTheme);
    super.didChangeDependencies();
  }

  void _updateAnimationDuration(ExpansionTileThemeData expansionTileTheme) {
    _animationController.duration = widget.expansionAnimationStyle?.duration ??
        expansionTileTheme.expansionAnimationStyle?.duration ??
        _kExpand;
  }

  void _updateShapeBorder(
      ExpansionTileThemeData expansionTileTheme, ThemeData theme) {
    _borderTween
      ..begin = widget.collapsedShape ??
          expansionTileTheme.collapsedShape ??
          const Border(
            top: BorderSide(color: Colors.transparent),
            bottom: BorderSide(color: Colors.transparent),
          )
      ..end = widget.shape ??
          expansionTileTheme.shape ??
          Border(
            top: BorderSide(color: Colors.green),
            bottom: BorderSide(color: Colors.green),
          );
  }

  void _updateHeaderColor(ExpansionTileThemeData expansionTileTheme,
      ExpansionTileThemeData defaults) {
    _headerColorTween
      ..begin = widget.collapsedTextColor ??
          expansionTileTheme.collapsedTextColor ??
          defaults.collapsedTextColor
      ..end = widget.textColor ??
          expansionTileTheme.textColor ??
          defaults.textColor;
  }

  void _updateIconColor(ExpansionTileThemeData expansionTileTheme,
      ExpansionTileThemeData defaults) {
    _iconColorTween
      ..begin = widget.collapsedIconColor ??
          expansionTileTheme.collapsedIconColor ??
          defaults.collapsedIconColor
      ..end = widget.iconColor ??
          expansionTileTheme.iconColor ??
          defaults.iconColor;
  }

  void _updateBackgroundColor(ExpansionTileThemeData expansionTileTheme) {
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ??
          expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
  }

  void _updateHeightFactorCurve(ExpansionTileThemeData expansionTileTheme) {
    _heightFactorTween.curve = widget.expansionAnimationStyle?.curve ??
        expansionTileTheme.expansionAnimationStyle?.curve ??
        Curves.easeIn;
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ??
              expansionTileTheme.childrenPadding ??
              EdgeInsets.zero,
          child: Column(
            crossAxisAlignment:
                widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

class _ExpansionTileDefaultsM2 extends ExpansionTileThemeData {
  _ExpansionTileDefaultsM2(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colorScheme = _theme.colorScheme;

  @override
  Color? get textColor => _colorScheme.primary;

  @override
  Color? get iconColor => _colorScheme.primary;

  @override
  Color? get collapsedTextColor => _theme.textTheme.titleMedium!.color;

  @override
  Color? get collapsedIconColor => _theme.unselectedWidgetColor;
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
