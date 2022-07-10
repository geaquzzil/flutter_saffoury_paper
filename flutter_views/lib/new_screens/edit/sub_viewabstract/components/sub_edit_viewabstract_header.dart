import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_master.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_trailing.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/sub_edit_viewabstract.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class EditSubViewAbstractHeader extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditSubViewAbstractHeader(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  State<EditSubViewAbstractHeader> createState() =>
      _EditSubViewAbstractHeaderState();
}

class _EditSubViewAbstractHeaderState extends State<EditSubViewAbstractHeader>
    with SingleTickerProviderStateMixin {
  late List<String> fields;
  final ColorTween _borderColorTween = ColorTween();
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
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
    fields = widget.viewAbstract.getFields();
    childrenPadding = EdgeInsets.all(20);
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
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
            children: fields.map((e) => buildWidget(e)).toList(),
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
    return context
        .watch<EditSubsViewAbstractControllerProvider>()
        .getIsNullable(widget.field);
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
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });

    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget buildWidget(String field) {
    dynamic fieldValue = widget.viewAbstract.getFieldValue(field);
    if (fieldValue is ViewAbstract) {
      fieldValue.setParent(widget.viewAbstract);
      // return Text("FDFD");
      return EditSubViewAbstractWidget(parent: fieldValue, field: field);
    } else {
      return EditControllerMasterWidget(
          viewAbstract: widget.viewAbstract, field: field);
    }
  }

  Widget? _buildTitle(BuildContext context, ViewAbstract? viewAbstractWatched) {
    return viewAbstractWatched == null
        ? widget.viewAbstract.getHeaderText(context)
        : viewAbstractWatched.getHeaderText(context);
  }

  Widget _buildLeadingIcon(BuildContext context) {
    String? url = widget.viewAbstract.getImageUrl(context);
    if (url != null) {
      return widget.viewAbstract.getCardLeadingImage(context);
    } else {
      return RotationTransition(
        turns: _iconTurns,
        child: Icon(widget.viewAbstract.getIconData()),
      );
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    ViewAbstract? viewAbstractWatched = context
        .watch<EditSubsViewAbstractControllerProvider>()
        .getViewAbstract(widget.viewAbstract.getFieldNameFromParent ?? "");
    return Card(
      child: Container(
        padding: _isExpanded ? const EdgeInsets.all(20) : null,
        decoration: BoxDecoration(
          color: expansionTileTheme.backgroundColor ?? Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
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
                leading: _buildLeadingIcon(context),
                title: _buildTitle(context, viewAbstractWatched),
                // subtitle: widget.subtitle,
                trailing: EditSubViewAbstractTrailingWidget(
                    view_abstract: widget.viewAbstract, field: widget.field),
              ),
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
