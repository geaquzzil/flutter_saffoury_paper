import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_tow_childs%20copy.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_dropdown.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class ExpansionTileCustom extends StatefulWidget {
  Widget? title;
  Widget? leading;
  Widget? subtitle;
  Widget? trailing;
  bool? hasError;
  bool initiallyExpanded;
  List<Widget> children;
  bool Function()? canExpand;
  ExpansionTileCustom(
      {Key? key,
      this.title,
      this.leading,
      this.subtitle,
      this.trailing,
      required this.children,
      this.initiallyExpanded = false,
      this.hasError,
      this.canExpand})
      : super(key: key);

  @override
  State<ExpansionTileCustom> createState() => _EditSubViewAbstractHeaderState();
}

class _EditSubViewAbstractHeaderState extends State<ExpansionTileCustom>
    with SingleTickerProviderStateMixin {
  final ColorTween _borderColorTween = ColorTween();
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: .85);
  late EdgeInsets childrenPadding;
  final ColorTween _iconColorTween = ColorTween();
  late Animation<double> _iconTurns;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _iconColor;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();

    childrenPadding = const EdgeInsets.all(20);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _iconColorTween
      ..begin =
          expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = expansionTileTheme.iconColor ?? colorScheme.primary;
    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    const bool shouldRemoveChildren = false;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: childrenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }

  bool canExpand(BuildContext context) {
    if (widget.canExpand == null) {
      return true;
    }
    return widget.canExpand!();
  }

  void _handleTap(BuildContext context) {
    if (!canExpand(context)) return;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });

    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Card(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 750),
        padding: _isExpanded
            ? const EdgeInsets.symmetric(horizontal: kDefaultPadding)
            : null,
        decoration: BoxDecoration(
          color: expansionTileTheme.backgroundColor ?? Colors.transparent,
          border: 
          
          
          Border(
            bottom: BorderSide(
                color: (widget.hasError ?? false)
                    ? Theme.of(context).colorScheme.onError
                    : borderSideColor,
                width: (widget.hasError ?? false) ? 3 : 0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTileTheme.merge(
              iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
              textColor: _iconColor.value,
              child: ListTile(
                  onTap: () => _handleTap(context),
                  contentPadding: expansionTileTheme.tilePadding,
                  leading: widget.leading,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  trailing: widget.trailing),
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
