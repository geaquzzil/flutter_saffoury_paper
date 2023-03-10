import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_tow_childs%20copy.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_dropdown.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../new_components/cards/clipper_card.dart';

class ExpansionTileCustom extends StatefulWidget {
  Widget? title;
  Widget? leading;
  Widget? subtitle;
  Widget? trailing;
  bool? hasError;
  bool? isEnabled;
  bool initiallyExpanded;
  bool wrapWithCardOrOutlineCard;
  bool useLeadingOutSideCard;
  List<Widget> children;
  bool padding;
  bool Function()? canExpand;
  bool isDeleteButtonClicked;
  void Function()? onTap;
  ExpansionTileCustom(
      {Key? key,
      this.title,
      this.leading,
      this.subtitle,
      this.trailing,
      this.isDeleteButtonClicked = false,
      this.useLeadingOutSideCard = true,
      this.padding = true,
      this.wrapWithCardOrOutlineCard = true,
      required this.children,
      this.initiallyExpanded = false,
      this.isEnabled = true,
      this.hasError,
      this.canExpand})
      : super(key: key);

  @override
  State<ExpansionTileCustom> createState() => EditSubViewAbstractHeaderState();
}

class EditSubViewAbstractHeaderState extends State<ExpansionTileCustom>
    with SingleTickerProviderStateMixin {
  final ColorTween _borderColorTween = ColorTween();
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: .85);
  late EdgeInsets childrenPadding;
  late bool hasError;
  final ColorTween _iconColorTween = ColorTween();
  late Animation<double> _iconTurns;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _iconColor;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    debugPrint("initState ExpanstionTileCustom ");
    super.initState();

    childrenPadding = EdgeInsets.all(widget.padding ? kDefaultPadding : 0);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    hasError = widget.hasError ?? false;
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      if (!canExpand(context)) {
        _controller.value = 0.0;
      } else {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    debugPrint("didChangeDependencies ExpanstionTileCustom ");
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _iconColorTween
      ..begin =
          expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = expansionTileTheme.iconColor ?? colorScheme.primary;
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    hasError = widget.hasError ?? false;
    if (_isExpanded) {
      if (!canExpand(context)) {
        _controller.value = 0.0;
      } else {
        _controller.value = 1.0;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
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
      child: result,
    );
  }

  void collapsedOnlyIfExpanded() {
    if (!_isExpanded) {
      if (!hasError) return;
      setState(() {
        hasError = false;
      });
    }
    setState(() {
      _isExpanded = false;
      hasError = false;
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
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  void setError(bool hasError) {
    setState(() {
      this.hasError = hasError;
    });
  }

  void manualExpand(bool expand, {bool? removeError}) {
    setState(() {
      _isExpanded = expand;
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
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  bool canExpand(BuildContext context) {
    if (widget.canExpand == null) {
      return true;
    }
    if (widget.canExpand!()) {
      if (widget.isDeleteButtonClicked) return false;
      return true;
    }
    return false;
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
      PageStorage.of(context).writeState(context, _isExpanded);
    });

    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final Color borderSideColor = _isExpanded
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
    if (widget.useLeadingOutSideCard) {
      return ListTile(
        leading: widget.leading,
        title: ClippedCard(
          wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
          borderSide: BorderSideColor.START,
          color: (hasError)
              ? Theme.of(context).colorScheme.error
              : borderSideColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTileTheme.merge(
                iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
                textColor: _iconColor.value,
                child: ListTile(
                    onTap: () => _handleTap(context),
                    // contentPadding: expansionTileTheme.tilePadding,
                    // leading: widget.leading,
                    title: widget.title,
                    subtitle: widget.subtitle,
                    trailing: widget.trailing ?? _buildIcon(context)),
              ),
              if (_isExpanded) Divider(),
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
    } else {
      return ClippedCard(
        wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
        borderSide: BorderSideColor.START,
        color:
            (hasError) ? Theme.of(context).colorScheme.error : borderSideColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTileTheme.merge(
              iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
              textColor: _iconColor.value,
              child: ListTile(
                  onTap: () => _handleTap(context),
                  // contentPadding: expansionTileTheme.tilePadding,
                  leading: widget.leading,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  trailing: widget.trailing ?? _buildIcon(context)),
            ),
            if (_isExpanded) Divider(),
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        ),
      );
    }
  }
}
