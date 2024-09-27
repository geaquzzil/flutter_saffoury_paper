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

enum ValueNotifierPane { FIRST, SECOND, BOTH, NONE }

mixin ActionOnToolbarSubPaneMixin<T extends StatefulWidget,
    E extends ActionOnToolbarItem> on State<T> {
  ValueNotifier<E?>? getOnActionAdd();
  ValueNotifier? onChangeThatHasToAddAction();

  ///this determines which action to
  ///todo not that importanted
  IconData getIconDataID();

  ValueNotifier? _notifier;

  @override
  void initState() {
    _notifier = onChangeThatHasToAddAction();
    _notifier?.addListener(onChangeListener);

    super.initState();
  }

  void onChangeListener() {
    if (_notifier is ValueNotifier<ViewAbstract?> ||
        _notifier is ValueNotifier<ViewAbstract>) {
      ViewAbstract? v = _notifier?.value;
      if (v == null) {
        debugPrint("ActionOnToolbarSubPaneMixin is  null");
        return;
      }
      //TODO
      // getOnActionAdd()?.value = ActionOnToolbarItem(
      //     actionTitle: v.getIDWithLabel(context),
      //     subObject: v,
      //     icon: getIconDataID());
    }
  }

  @override
  void dispose() {
    _notifier?.removeListener(onChangeListener);
    super.dispose();
  }
}
mixin BasePageActionOnToolbarMixin<T extends BasePage,
    E extends ActionOnToolbarItem> on BasePageState<T> {
  GlobalKey<_ActionOnToolbarsasState> key =
      GlobalKey<_ActionOnToolbarsasState>();
  ValueNotifier<E?>? _onActionAdd;

  ValueNotifier<E?>? get getOnActionAdd => _onActionAdd;

  // CurrentScreenSize _lastScreenSize;

  ValueNotifierPane getValueNotifierPane();

  void addAction(E? item, {bool notifyListener = false}) {
    if (notifyListener) {
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        _onActionAdd?.value = item;
      });
    } else {
      key.currentState?.add(_onActionAdd?.value);
    }
  }

  @override
  void initState() {
    // _lastScreenSize=getCurrentScreenSize();
    initAction();
    _onActionAdd?.addListener(onActionAddListner);
    super.initState();
  }

  @override
  void dispose() {
    _onActionAdd?.removeListener(onActionAddListner);
    super.dispose();
  }

  void onActionAddListner() {
    key.currentState?.add(_onActionAdd?.value);
  }

  getActionPane(bool isDesktop,
      {required bool firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      E? selectedItem});

  E onActionInitial();

  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane == null) {
      if (!isLargeScreenFromCurrentScreenSize(context)) return null;
      debugPrint("BasePageActionOnToolbar mixin is called");
      return ActionOnToolbarsas(
        widget: this,
        actions: [onActionInitial()],
        key: key,
      );
    }
    return null;
  }

  @override
  getPane(
      {required bool firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(
        firstPane, isLargeScreenFromCurrentScreenSize(context),
        tab: tab ?? secoundTab);
  }

  getWidgetFromBase(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab}) {
    debugPrint("BasePageActionOnToolbarMixin getWidgetFromBase");
    ValueNotifierPane pane = getValueNotifierPane();
    if (pane == ValueNotifierPane.NONE) {
      return getWidget(firstPane, isDesktop, tab: tab, item: null);
    }
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

  Widget getValueListenableBuilder(
      bool firstPane, bool isDesktop, TabControllerHelper? tab) {
    if (_onActionAdd == null) {
      return getWidget(firstPane, isDesktop, tab: tab, item: null);
    }
    return ValueListenableBuilder(
        valueListenable: _onActionAdd!,
        builder: (context, value, child) {
          if (this is BasePageWithThirdPaneMixin) {
            debugPrint(
                "BasePageActionOnToolbarMixin is =>> BasePageWithThirdPaneMixin removing third pane");

            (this as BasePageWithThirdPaneMixin).setThirdPane(null);
          }
          debugPrint(
              "BasePageActionOnToolbarMixin getValueListenableBuilder called value $value");
          return getWidget(firstPane, isDesktop, tab: tab, item: value);
        });
  }

  Widget getWidget(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab, E? item}) {
    return getActionPane(isDesktop,
        firstPane: firstPane,
        tab: tab,
        secoundTab: secoundTab,
        selectedItem: item);
  }

  void initAction() {
    _onActionAdd = ValueNotifier(null);
  }
}

class ActionOnToolbarItem {
  String actionTitle;
  IconData? icon;
  String? path;
  GestureTapCallback? onPress;
  Object? mainObject;
  Object? subObject;
  ActionOnToolbarItem(
      {required this.actionTitle,
      this.icon,
      this.path,
      this.mainObject,
      this.onPress,
      this.subObject});
}

class ActionOnToolbarsas<T extends BasePageActionOnToolbarMixin,
    E extends ActionOnToolbarItem> extends StatefulWidget {
  List<E> actions;
  T widget;
  ActionOnToolbarsas({required this.widget, required this.actions, super.key});

  @override
  State<ActionOnToolbarsas<T, E>> createState() =>
      _ActionOnToolbarsasState<T, E>();
}

class _ActionOnToolbarsasState<T extends BasePageActionOnToolbarMixin,
    E extends ActionOnToolbarItem> extends State<ActionOnToolbarsas<T, E>> {
  late List<E> _actions;

  @override
  void initState() {
    debugPrint("_ActionOnToolbarsasState init");
    _actions = widget.actions;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ActionOnToolbarsas<T, E> oldWidget) {
    debugPrint(
        "_ActionOnToolbarsasState update new  ${widget.actions[0].actionTitle} current ${_actions[0].actionTitle}");
    if (widget.actions[0].actionTitle != _actions[0].actionTitle) {
      _actions = widget.actions;
    }
    super.didUpdateWidget(oldWidget);
  }

  void removeBeforeAdd() {}
  void add(E? item) {
    if (item == null) {
      return;
    }
    if (item.subObject != null) {
      _actions.add(item);
    } else {
      E i = _actions[0];
      _actions.clear();
      _actions = [i, item];
    }
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((s) {
        if (mounted) {
          setState(() {});
        }
      });
    }
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

  Widget getIconWithText(BuildContext context, E item) {
    return InkWell(
        onTap: () {
          int idx = _actions.indexWhere(
              (s) => s.actionTitle == item.actionTitle && s.icon == item.icon);

          debugPrint("_ActionOnToolbarsasState  idx = $idx ");
          if (idx == _actions.length - 1 ||
              (idx == 0 && _actions.length == 1)) {
            debugPrint("_ActionOnToolbarsasState return ");
            return;
          }
          widget.widget.addAction(_actions[idx]);
          setState(() {
            _actions = _actions.sublist(0, idx + 1);
            debugPrint("_ActionOnToolbarsasState  subList = $_actions ");
          });
        },
        child: OnHoverWidget(
            scale: false,
            builder: (isHovered) =>
                getB(item.icon, isHovered, context, item.actionTitle)));
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

@Deprecated("Use  BasePageActionOnToolbarMixin instead")
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
                separatorBuilder: (context, index) => const Center(
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
