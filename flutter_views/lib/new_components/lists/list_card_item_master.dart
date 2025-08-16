import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class ListCardItemMaster<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  final String? searchQuery;
  final void Function(T object)? onTap;
  final void Function()? onLongTap;
  final void Function()? onTralingTap;
  final void Function(MenuItemBuild? item)? onPopMenuTap;
  final SecoundPaneHelperWithParentValueNotifier? state;
  final SliverApiWithStaticMixin? stateForToggle;
  final bool? isSelectMoodEnabled;
  final void Function(T object, bool isSelected)? isSelectForSelection;
  final bool Function(T? object)? isSelectForListTile;

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? traling;

  const ListCardItemMaster({
    super.key,
    required this.object,
    this.state,
    this.stateForToggle,
    this.searchQuery,
    this.isSelectForListTile,
    this.isSelectMoodEnabled,
    this.isSelectForSelection,
    this.onTap,
    this.onLongTap,
    this.onTralingTap,
    this.onPopMenuTap,
    this.title,
    this.subtitle,
    this.leading,
    this.traling,
  });

  @override
  State<StatefulWidget> createState() =>
      ListCardItemMasterState<T, ListCardItemMaster<T>>();
}

class ListCardItemMasterState<
  T extends ViewAbstract,
  E extends ListCardItemMaster<T>
>
    extends State<E> {
  late T object;

  String? _searchQuery;

  bool? _isSelectedForListTile;

  String? get searchQuery => this._searchQuery;
  bool? get isSelectedForListTile => this._isSelectedForListTile;

  @override
  void initState() {
    super.initState();
    object = widget.object;
    _searchQuery = widget.searchQuery;
    _isSelectedForListTile = widget.isSelectForListTile?.call(object);
  }

  @override
  void didUpdateWidget(covariant E oldWidget) {
    _isSelectedForListTile = widget.isSelectForListTile?.call(object);
    if (widget.object != object) {
      object = widget.object;
    }
    if (widget.searchQuery != _searchQuery) {
      _searchQuery = widget.searchQuery;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget cardItem = getListTile();
    if (widget.isSelectMoodEnabled ?? false) {
      return getSelectMoodWidget();
    }
    if (isLargeScreen(context)) {
      return cardItem;
    }

    return Dismissible(
      key: UniqueKey(),
      direction: object.getDismissibleDirection(),
      background: object.getDismissibleBackground(context),
      secondaryBackground: object.getDismissibleSecondaryBackground(context),
      onDismissed: (direction) =>
          object.onCardDismissedView(context, direction),
      child: cardItem,
    );
  }

  bool isListTileSelected() {
    return _isSelectedForListTile ?? false;
  }

  Widget getSelectMoodWidget() {
    return CheckboxListTile.adaptive(
      controlAffinity: ListTileControlAffinity.leading,
      value: object.selected,
      onChanged: (value) {
        debugPrint("CheckboxListTile changed  => $value");
        if ((widget.object.getParent?.hasPermissionFromParentSelectItem(
                  context,
                  widget.object,
                ) ??
                true) ==
            false) {
          return;
        }
        widget.isSelectForSelection?.call(widget.object, value ?? false);
        setState(() {
          widget.object.isSelected = value ?? false;
        });
      },
      selected: object.isSelected,
      //todo set tile color on theme
      // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
      // onTap: () => widget.object.onCardClicked(context),
      // onLongPress: () => widget.object.onCardLongClicked(context),
      title: getListTile(),
    );
  }

  void onTap() {
    if (widget.onTap != null) {
      widget.onTap?.call(object);
    } else {
      object.onCardClicked(context, secondPaneHelper: widget.state);
    }
  }

  void onLongPress() {
    if (widget.onLongTap != null) {
      widget.onLongTap?.call();
    } else {
      widget.stateForToggle?.toggleSelectedMood();
    }
  }

  Widget getTitle() {
    return widget.title ??
        (object.getMainHeaderText(context, searchQuery: _searchQuery));
  }

  Widget? getSubtitle() {
    return widget.subtitle ??
        (object.getMainSubtitleHeaderText(context, searchQuery: _searchQuery));
  }

  Widget getLeading() {
    return widget.leading ?? object.getCardLeading(context);
  }

  Widget? getTrailing() {
    return widget.traling ??
        object.getCardTrailing(context, secPaneHelper: widget.state);
  }

  Widget getListTile() {
    bool hasThreeLine = object.getMainSubtitleHeaderText(context) is Column;
    return ListTile(
      // isThreeLine: hasThreeLine,
      selected: isListTileSelected(),
      onTap: () {
        onTap();
      },
      onLongPress: () {
        onLongPress();
      },
      title: getTitle(),
      subtitle: getSubtitle(),
      leading: getLeading(),
      trailing: getTrailing(),
    );
  }
}
