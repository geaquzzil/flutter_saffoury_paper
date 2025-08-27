import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class ViewCardItem extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final ViewAbstract? object;
  final ValueNotifier<ViewAbstract>? valueNotifier;
  final ValueNotifier<SecondPaneHelper?>? secNotifier;
  final bool Function(ViewAbstract? object)? isSelectForListTile;
  final bool overrideTrailingToNull;
    final SecoundPaneHelperWithParentValueNotifier? state;
  const ViewCardItem({
    super.key,
    this.object,
    required this.title,
    required this.description,
    this.valueNotifier,
    this.secNotifier,
    this.state,
    this.overrideTrailingToNull = false,
    this.isSelectForListTile,
    required this.icon,
  });

  @override
  State<ViewCardItem> createState() => _ViewCardItemState();
}

class _ViewCardItemState extends State<ViewCardItem> {
  bool? _isSelectedForListTile;
  ViewAbstract? object;
  @override
  void initState() {
    super.initState();
    object = widget.object;
    _isSelectedForListTile = widget.isSelectForListTile?.call(object);
  }

  @override
  void didUpdateWidget(covariant ViewCardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelectedForListTile = widget.isSelectForListTile?.call(object);
    if (widget.object != object) {
      object = widget.object;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        object?.onCardClicked(context, secondPaneHelper: widget.state);
      },
      selected: _isSelectedForListTile ?? false,
      onLongPress: () => object?.onCardLongClickedView(context),
      title: getTextTitle(
        context,
        object?.getMainHeaderLabelTextOnly(context) ?? widget.title,
      ),
      subtitle: getTextSubTitle(
        context,
        object?.getMainHeaderTextOnly(context) ?? widget.description,
      ),
      leading: object != null
          ? Hero(tag: object!, child: Icon(widget.object?.getMainIconData()))
          : Icon(widget.icon),
      trailing: widget.overrideTrailingToNull
          ? null
          : object != null
          ? InkWell(
              onTap: () => object?.onCardTrailingClickedView(context),
              child: const Icon(Icons.arrow_forward_ios),
            )
          : null,
    );
  }

  Text getTextTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }

  Text getTextSubTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}
