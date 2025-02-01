// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
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
  GlobalKey<ActionOnToolbarsasState> key = GlobalKey<ActionOnToolbarsasState>();
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

  Widget getActionPane(
      {required bool firstPane, TabControllerHelper? tab, E? selectedItem});

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
  List<Widget>? getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    return [
      SliverFillRemaining(
        child: getWidgetFromBase(firstPane, tab: tab),
      )
    ];
  }

  Widget getWidgetFromBase(bool firstPane, {TabControllerHelper? tab}) {
    debugPrint("BasePageActionOnToolbarMixin getWidgetFromBase");
    ValueNotifierPane pane = getValueNotifierPane();
    if (pane == ValueNotifierPane.NONE) {
      return getWidget(firstPane, tab: tab, item: null);
    }
    if (pane == ValueNotifierPane.BOTH) {
      return getValueListenableBuilder(firstPane, tab);
    }
    if (firstPane) {
      if (pane == ValueNotifierPane.FIRST) {
        return getValueListenableBuilder(firstPane, tab);
      } else {
        return getWidget(firstPane, tab: tab, item: null);
      }
    } else {
      if (pane == ValueNotifierPane.SECOND) {
        return getValueListenableBuilder(firstPane, tab);
      } else {
        return getWidget(firstPane, tab: tab, item: null);
      }
    }
  }

  Widget getValueListenableBuilder(bool firstPane, TabControllerHelper? tab) {
    if (_onActionAdd == null) {
      return getWidget(firstPane, tab: tab, item: null);
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
          return getWidget(firstPane, tab: tab, item: value);
        });
  }

  Widget getWidget(bool firstPane, {TabControllerHelper? tab, E? item}) {
    return getActionPane(firstPane: firstPane, tab: tab, selectedItem: item);
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
      ActionOnToolbarsasState<T, E>();
}

class ActionOnToolbarsasState<T extends BasePageActionOnToolbarMixin,
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

class ThirdToSecondPaneHelper extends SecondPaneHelper {
  bool shouldAddToThirdPaneList;
  ThirdToSecondPaneHelper(
      {required this.shouldAddToThirdPaneList,
      required super.title,
      super.value});
}

class SecondPaneHelper {
  String title;

  ///Value could be A dynamic object or [List<Widget>] or [BasePage] please make sure to pass the currect values
  dynamic value;
  GlobalKey<BasePageSecoundPaneNotifierState>? state;
  SecondPaneHelper({required this.title, this.value, this.state});
}

class SecoundPaneHelperWithParent {
  GlobalKey<BasePageSecoundPaneNotifierState> state;
  SecondPaneHelper? value;
  SecoundPaneHelperWithParent({
    required this.state,
    this.value,
  });
}

class ActionOnToolbar<T extends BasePageSecoundPaneNotifierState>
    extends StatefulWidget {
  List<SecondPaneHelper> actions;
  SecondPaneHelper? selectedItem;
  T widget;

  ActionOnToolbar(
      {required this.widget,
      required this.actions,
      super.key,
      this.selectedItem});

  @override
  State<ActionOnToolbar<T>> createState() => ActionOnToolbarState<T>();
}

class ActionOnToolbarState<T extends BasePageSecoundPaneNotifierState>
    extends State<ActionOnToolbar<T>> {
  late List<SecondPaneHelper> _actions;
  SecondPaneHelper? _selectedItem;
  @override
  void initState() {
    debugPrint("_ActionOnToolbarsasState init");
    _actions = widget.actions;
    widget.widget.getSecondPaneNotifier.addListener(onPaneChange);
    widget.widget.onBuild.addListener(onBuild);
    super.initState();
  }

  @override
  void dispose() {
    widget.widget.getSecondPaneNotifier.removeListener(onPaneChange);

    // widget.widget.test?.removeListener(onSubPaneChanged);
    super.dispose();
  }

  void onPaneChange() {
    add(widget.widget.getSecondPaneNotifier.value);
  }

  @override
  void didUpdateWidget(covariant ActionOnToolbar<T> oldWidget) {
    if (widget.actions[0].title != _actions[0].title) {
      _actions = widget.actions;
    }
    if (_selectedItem != widget.selectedItem) {
      _selectedItem = widget.selectedItem;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _addSubPane(SecoundPaneHelperWithParent item) {
    if (item.value == null) {
      SecondPaneHelper i = _actions[0];
      SecondPaneHelper i2 = _actions[1];
      _actions.clear();
      _actions = [i, i2];
    } else {
      SecondPaneHelper itemToAdd = item.value!..state = item.state;
      // if (item.subObject != null) {
      //   _actions.add(item);
      // } else {
      if (_actions.length == 2) {
        _actions.add(itemToAdd);
      } else {
        SecondPaneHelper i = _actions[0];
        SecondPaneHelper i2 = _actions[1];
        _actions.clear();
        _actions = [i, i2, itemToAdd];
      }
    }
    // }
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((s) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void removeBeforeAdd() {}
  void add(SecondPaneHelper? item) {
    if (item == null) {
      return;
    }
    // if (item.subObject != null) {
    //   _actions.add(item);
    // } else {
    SecondPaneHelper i = _actions[0];
    _actions.clear();
    _actions = [i, item];
    // }
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((s) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void onBuild() {
    // setState(() {});
    debugPrint("_ActionOnToolbarsasState onBuildCalled");
    widget.widget.childs?.forEach((o) {
      debugPrint("_ActionOnToolbarsasState currentState ${o?.currentState}");
      debugPrint(
          "_ActionOnToolbarsasState curentState ${(o as GlobalKey<BasePageSecoundPaneNotifierState>).currentState?.getSecondPaneNotifier}");
      (o).currentState?.getSecondPaneNotifier.addListener(() {
        debugPrint("_ActionOnToolbarsasState addListinerer");
        _addSubPane(SecoundPaneHelperWithParent(
            state: o, value: o.currentState!.getSecondPaneNotifier.value));
      });
    });
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

  GlobalKey<BasePageSecoundPaneNotifierState>? getKey(String? title) {
    if (title == null) return null;
    return widget.widget.childs?.firstWhereOrNull((i) {
      if (i is GlobalKey<BasePageSecoundPaneNotifierState>) {
        return i.currentState?.onActionInitial() == title;
      }
      return false;
    }) as GlobalKey<BasePageSecoundPaneNotifierState>;
  }

  ButtonStyle getStyle() {
    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return 10;
        }
        if (states.contains(WidgetState.hovered)) {
          return 5;
        }
        return 0;
      }),
      // padding: WidgetStateProperty.all(EdgeInsets.zero),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      // surfaceTintColor:
      //     WidgetStateProperty.all(const Color.fromRGBO(0, 0, 0, 0)),
      shape: WidgetStateProperty.all(const CircleBorder()),
      //  side: ,
      // shape:  WidgetStateProperty.all(),
      iconColor: WidgetStateProperty.all(Colors.orange),
      textStyle: WidgetStateProperty.resolveWith((states) {
        TextStyle? style = Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Theme.of(context).colorScheme.surface);
        double? large = Theme.of(context).textTheme.titleLarge?.fontSize;
        if (states.contains(WidgetState.pressed)) {
          return style?.copyWith(fontSize: large == null ? 12 : large - 1);
        }
        // if (states.contains(WidgetState.hovered)) {
        //   return style?.copyWith(fontSize: large == null ? 12 : large - 2);
        // }
        return style;
      }),
    );
  }

  Widget getIconWithText(BuildContext context, SecondPaneHelper item) {
    return TextButton(
        style: getStyle(),
        onPressed: () {
          int idx = _actions.indexWhere((s) => s.title == item.title);

          debugPrint("_ActionOnToolbarsasState  idx = $idx ");
          if (idx == _actions.length - 1 ||
              (idx == 0 && _actions.length == 1)) {
            if (idx == _actions.length - 1) {
              getKey(_actions[idx].title)?.currentState?.notify(null);
              setState(() {
                _actions = _actions.sublist(0, idx + 1);
                debugPrint("_ActionOnToolbarsasState  subList = $_actions ");
              });
            }

            debugPrint("_ActionOnToolbarsasState return ");
            return;
          }

          if (item.state != null) {
            debugPrint("_ActionOnToolbarsasState item.state != null");
            item.state?.currentState?.notify(_actions[idx]);
          } else {
            if (idx != 0) {}
            widget.widget.notify(_actions[idx]);
          }
          final key = getKey(_actions[idx].title);
          if (key != null) {
            key.currentState?.notify(null);
            // return;
          }

          setState(() {
            _actions = _actions.sublist(0, idx + 1);
            debugPrint("_ActionOnToolbarsasState  subList = $_actions ");
          });
        },
        child: Text(item.title));
  }
}
