import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ControllerViewAbstractAsOneField extends StatefulWidget {
  ViewAbstract viewAbstract;
  ViewAbstract parent;
  Widget children;
  bool wrapWithCardOrOutlineCard;
  bool padding;
  ControllerViewAbstractAsOneField({
    super.key,
    required this.viewAbstract,
    required this.parent,
    this.wrapWithCardOrOutlineCard = true,
    required this.children,
    this.padding = false,
  });

  @override
  State<ControllerViewAbstractAsOneField> createState() =>
      _ControllerViewAbstractAsOneField();
}

class _ControllerViewAbstractAsOneField
    extends State<ControllerViewAbstractAsOneField>
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
  late bool initiallyExpanded;
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
    initiallyExpanded = widget.viewAbstract.isEditing();
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    debugPrint("dispose ExpanstionTileCustom ");
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

    initiallyExpanded = widget.viewAbstract.isEditing();
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        initiallyExpanded;

    if (_isExpanded) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        final ExpansionTileThemeData expansionTileTheme =
            ExpansionTileTheme.of(context);
        final Color borderSideColor = _isExpanded
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent;
        return ListTile(
          iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
          textColor: _iconColor.value,
          leading: SizedBox(
              width: 25,
              height: 25,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: widget.viewAbstract.getCardLeadingImage(context))),
          title: ClippedCard(
            wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
            borderSide: BorderSideColor.START,
            //todo color: (widget.hasError ?? false)
            //     ? Theme.of(context).colorScheme.onError
            //     : borderSideColor,

            color: borderSideColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTileTheme.merge(
                    minVerticalPadding: 10,
                    selectedTileColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(_controller.value * 10),
                    iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
                    textColor: _iconColor.value,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      onTap: () => _handleTap(context),
                      // leadingAndTrailingTextStyle: ,
                      // contentPadding: expansionTileTheme.tilePadding,

                      title: AnimatedSwitcher(
                        transitionBuilder: (Widget child,
                                Animation<double> animation) =>
                            FadeTransition(opacity: animation, child: child),
                        duration: const Duration(milliseconds: 200),
                        child: !_isExpanded
                            ? Text(
                                widget.viewAbstract
                                    .getMainHeaderTextOnly(context),
                                key: UniqueKey(),
                              )
                            : const Column(
                                children: [
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: 'Username'),
                                    // cursorHeight: 20,
                                  ),
                                  // for (int i = 0; i < 5; i++)
                                  //   TextField(
                                  //     decoration: InputDecoration(
                                  //         hintText: 'Username $i'),
                                  //     // cursorHeight: 20,
                                  //   ),
                                ],
                              ),
                      ),

                      // subtitle: _isExpanded
                      //     ? null
                      //     : widget.viewAbstract.getMainLabelText(context),
                      trailing: !_isExpanded
                          ? null
                          : IconButton(
                              onPressed: () => _handleTap(context),
                              icon: const Icon(Icons.minimize_outlined),
                              color: Theme.of(context).colorScheme.error,
                            ),
                    )),
              ],
            ),
          ),
        );
      },
      // child: result,
    );
    // return Card(
    //   child: ListTile(
    //     leading: SizedBox(
    //         width: 25,
    //         height: 25,
    //         child: widget.viewAbstract.getCardLeadingImage(context)),
    //     title: AnimatedSwitcher(
    //         duration: Duration(milliseconds: 500),
    //         child: !_isExpanded
    //             ? widget.viewAbstract.getMainHeaderText(context)
    //             : Column(
    //                 key: UniqueKey(),
    //                 children: widget.children,
    //               )),
    //     onTap: () => _handleTap(context),
    //     subtitle: widget.viewAbstract.getMainLabelText(context),
    //     trailing: _isExpanded
    //         ? null
    //         : Icon(
    //             Icons.minimize,
    //             color: Colors.red,
    //           ),
    //   ),
    // );

    // final bool closed = !_isExpanded && _controller.isDismissed;
    // final Widget result = Offstage(
    //   offstage: closed,
    //   child: TickerMode(
    //     enabled: !closed,
    //     child: Padding(
    //       padding: childrenPadding,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: widget.children,
    //       ),
    //     ),
    //   ),
    // );

    // return AnimatedBuilder(
    //   animation: _controller.view,
    //   builder: _buildChildren,
    //   child: result,
    // );
  }

  void collapsedOnlyIfExpanded() {
    if (!_isExpanded) return;
    setState(() {
      _isExpanded = false;
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

  void manualExpand(bool expand) {
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

  void _handleTap(BuildContext context) {
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

  // Widget _buildChildren(BuildContext context, Widget? child) {
  //   final ExpansionTileThemeData expansionTileTheme =
  //       ExpansionTileTheme.of(context);
  //   final Color borderSideColor = _isExpanded
  //       ? Theme.of(context).colorScheme.primary
  //       : Colors.transparent;
  //   {
  //     return ClippedCard(
  //       wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
  //       borderSide: BorderSideColor.START,
  //       //todo color: (widget.hasError ?? false)
  //       //     ? Theme.of(context).colorScheme.onError
  //       //     : borderSideColor,

  //       color: borderSideColor,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           ListTileTheme.merge(
  //             iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
  //             textColor: _iconColor.value,
  //             child: ListTile(
  //                 onTap: () => _handleTap(context),
  //                 // contentPadding: expansionTileTheme.tilePadding,
  //                 leading: widget.leading,
  //                 title: widget.title,
  //                 subtitle: widget.subtitle,
  //                 trailing: widget.trailing ?? _buildIcon(context)),
  //           ),
  //           if (_isExpanded) Divider(),
  //           ClipRect(
  //             child: Align(
  //               alignment: Alignment.center,
  //               heightFactor: _heightFactor.value,
  //               child: child,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
}
