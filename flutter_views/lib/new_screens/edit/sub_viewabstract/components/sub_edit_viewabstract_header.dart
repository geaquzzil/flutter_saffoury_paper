import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_master.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/components/sub_edit_viewabstract_trailing.dart';
import 'package:flutter_view_controller/new_screens/edit/sub_viewabstract/sub_edit_viewabstract.dart';

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
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    childrenPadding = EdgeInsets.all(20);
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = false;
    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

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

  void _handleTap() {
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

  Widget? _buildTitle(BuildContext context) {
    return widget.viewAbstract.getHeaderText(context);
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

    return Container(
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
              onTap: _handleTap,
              contentPadding: expansionTileTheme.tilePadding,
              leading: _buildLeadingIcon(context),
              title: _buildTitle(context),
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
    );
  }
}
