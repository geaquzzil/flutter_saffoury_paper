// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../providers/actions/action_viewabstract_provider.dart';

enum ValueNotifierPane { FIRST, SECOND, BOTH }

mixin ActionOnToolbarSubPaneMixin<T extends StatefulWidget> on State<T> {
  ValueNotifier<ActionOnToolbarItem?> getOnActionAdd();
  ValueNotifier onChangeThatHasToAddAction();

  ///this determines which action to
  IconData getIconDataID();

  late ValueNotifier _notifier;

  @override
  void initState() {
    // TODO: implement initState

    _notifier = onChangeThatHasToAddAction();
    _notifier.addListener(onChangeListener);

    super.initState();
  }

  void onChangeListener() {
    if (_notifier is ValueNotifier<ViewAbstract?> ||
        _notifier is ValueNotifier<ViewAbstract>) {
      ViewAbstract? v = _notifier.value;
      if (v == null) {
        debugPrint("ActionOnToolbarSubPaneMixin is  null");
        return;
      }
      getOnActionAdd().value = ActionOnToolbarItem(
          title: v.getIDWithLabel(context),
          subObject: v,
          icon: getIconDataID());
    }
  }

  @override
  void dispose() {
    _notifier.removeListener(onChangeListener);
    super.dispose();
  }
}
mixin BasePageActionOnToolbarMixin<T extends StatefulWidget>
    on BasePageState<T> {
  GlobalKey<_ActionOnToolbarsasState> key =
      GlobalKey<_ActionOnToolbarsasState>();
  List<ActionOnToolbarItem> actions = [];
  ValueNotifier<ActionOnToolbarItem?> onActionAdd = ValueNotifier(null);

  ValueNotifierPane getValueNotifierPane();

  @override
  void initState() {
    onActionAdd.addListener(onActionAddListner);
    super.initState();
  }

  @override
  void dispose() {
    onActionAdd.removeListener(onActionAddListner);
    super.dispose();
  }

  void onActionAddListner() {
    key.currentState?.add(onActionAdd.value);
  }

  getActionFirstPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem});

  getActionSecondPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem});

  ActionOnToolbarItem onActionInitial();

  @override
  Widget? getBaseAppbar() {
    if (actions.isEmpty) {
      actions = [onActionInitial()];
    }
    debugPrint("BasePageActionOnToolbar mixin is called");
    return ActionOnToolbarsas(
      this,
      key: key,
    );
  }

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    return getWidgetFromBase(true, true, tab: tab);
  }

  @override
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(false, true, tab: tab);
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(false, false, tab: tab);
  }

  @override
  getFirstPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(true, false, tab: tab);
  }

  getWidgetFromBase(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab}) {
    ValueNotifierPane pane = getValueNotifierPane();
    if (pane == ValueNotifierPane.BOTH) {
      return getValueListenableBuilder(firstPane, isDesktop, tab);
    }
    if (firstPane) {
      if (pane == ValueNotifierPane.FIRST) {
        return getValueListenableBuilder(firstPane, isDesktop, tab);
      } else {
        return getWidget(firstPane, isDesktop, tab: tab, item: null);
      }
    } else {
      if (pane == ValueNotifierPane.SECOND) {
        return getValueListenableBuilder(firstPane, isDesktop, tab);
      } else {
        return getWidget(firstPane, isDesktop, tab: tab, item: null);
      }
    }
  }

  ValueListenableBuilder<ActionOnToolbarItem?> getValueListenableBuilder(
      bool firstPane, bool isDesktop, TabControllerHelper? tab) {
    return ValueListenableBuilder(
        valueListenable: onActionAdd,
        builder: (context, value, child) {
          return getWidget(firstPane, isDesktop, tab: tab, item: value);
        });
  }

  Widget getWidget(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? item}) {
    return firstPane
        ? getActionFirstPane(isDesktop,
            tab: tab, secoundTab: secoundTab, selectedItem: item)
        : getActionSecondPane(isDesktop,
            tab: tab, secoundTab: secoundTab, selectedItem: item);
  }
}

class ActionOnToolbarItem {
  String title;
  IconData? icon;
  String? path;
  GestureTapCallback? onPress;
  Object? subObject;
  ActionOnToolbarItem(
      {required this.title,
      this.icon,
      this.path,
      this.onPress,
      this.subObject});
}

class ActionOnToolbarsas<T extends BasePageActionOnToolbarMixin>
    extends StatefulWidget {
  T widget;
  ActionOnToolbarsas(this.widget, {super.key});

  @override
  State<ActionOnToolbarsas<T>> createState() => _ActionOnToolbarsasState<T>();
}

class _ActionOnToolbarsasState<T extends BasePageActionOnToolbarMixin>
    extends State<ActionOnToolbarsas<T>> {
  late List<ActionOnToolbarItem> _actions;

  @override
  void initState() {
    debugPrint("_ActionOnToolbarsasState init");
    _actions = widget.widget.actions;
    super.initState();
  }

  void removeBeforeAdd() {}
  void add(ActionOnToolbarItem? item) {
    if (item == null) {
      return;
    }
    if (item.subObject != null) {
      _actions.add(item);
    } else {
      ActionOnToolbarItem i = _actions[0];
      _actions.clear();
      _actions = [i, item];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Center(
          child: Icon(
            Icons.arrow_right_outlined,
          ),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _actions.length,
        itemBuilder: (context, index) =>
            getIconWithText(context, _actions[index]),
      ),
    );
  }

  Widget getIconWithText(BuildContext context, ActionOnToolbarItem item) {
    return InkWell(
        onTap: () {
          int idx = _actions
              .indexWhere((s) => s.title == item.title && s.icon == item.icon);

          debugPrint("_ActionOnToolbarsasState  idx = $idx ");
          if (idx == _actions.length - 1 ||
              (idx == 0 && _actions.length == 1)) {
            debugPrint("_ActionOnToolbarsasState return ");
            return;
          }
          widget.widget.onActionAdd.value = _actions[idx];
          setState(() {
            _actions = _actions.sublist(0, idx + 1);
            debugPrint("_ActionOnToolbarsasState  subList = $_actions ");
          });
        },
        child: OnHoverWidget(
            scale: false,
            builder: (isHovered) =>
                getB(item.icon, isHovered, context, item.title)));
  }

  Widget getB(
      IconData? icon, bool isHovered, BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: isHovered
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class BaseSharedActionDrawerNavigation extends StatelessWidget {
  const BaseSharedActionDrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    List<ListToDetailsSecoundPaneHelper?> stack =
        context.watch<ActionViewAbstractProvider>().getStackedActions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
                separatorBuilder: (context, index) => Center(
                      child: Icon(
                        Icons.arrow_right_outlined,
                      ),
                    ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                // scrollDirection: Axis.horizontal,
                itemCount: stack.length,
                // scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  debugPrint("generate navigate icon index : $index");
                  dynamic v = stack[index];
                  if (v == null) {
                    return getIconWithText(context, Icons.home, "Home");
                  }
                  ViewAbstract? viewAbstract = v!.viewAbstract;
                  if (viewAbstract == null) {
                    return getIconWithText(context, Icons.home, "Home");
                  } else {
                    return getIconWithText(
                        context,
                        viewAbstract.getMainIconData(),
                        viewAbstract.getMainHeaderLabelTextOnly(context));
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget getIconWithText(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: OnHoverWidget(
          scale: false,
          builder: (isHovered) => getB(icon, isHovered, context, title)),
    );
  }

  Widget getB(
      IconData icon, bool isHovered, BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: isHovered
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_right_outlined,
            color: isHovered
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
        Text(
          title,
          style: TextStyle(
              color: isHovered
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }
}
