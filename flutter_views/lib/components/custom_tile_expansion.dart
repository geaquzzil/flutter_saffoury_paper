import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';

const Duration _kExpand = Duration(milliseconds: 200);

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

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  const ExpansionEdit({
    super.key,
    this.initiallyExpanded = false,
    this.controlAffinity,
    this.maintainState = false,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  });

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

  bool _isExpanded = false;
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
      ..end = RoundedRectangleBorder(
          side: BorderSide(
              width: 1,
              color: _iconColor.value ?? Theme.of(context).colorScheme.outline),
          borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)));
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

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getChildrens(),
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

  List<Widget> getChildrens() => [
        getTextField("s"),
        getTextField("sds"),
        getTextField("ss"),
      ];

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
                onTap: _handleTap,
                contentPadding: expansionTileTheme.tilePadding,
                leading: widget.leading,
                title: getTitle(),
                subtitle: widget.subtitle,
                trailing: widget.trailing ?? _buildTrailingIcon(context),
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

    final bool isShapeProvided =
        //todo check this
        //  widget.shape != null ||
        //     expansionTileTheme.shape != null ||
        //     widget.collapsedShape != null ||
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

  FormBuilderTextField getTextField(String key) {
    return FormBuilderTextField(
      maxLines: 1,
      // controller: text,
      name: key,
      decoration:
          const InputDecoration(border: InputBorder.none, hintText: "HINT"),
    );
  }

  TextEditingController text = TextEditingController();
  Widget getTitle() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _toggleExpansion(expand: hasFocus);
        }
      },
      child: getTextField("dsa"),
    );
  }

  void _handleTap() {
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
