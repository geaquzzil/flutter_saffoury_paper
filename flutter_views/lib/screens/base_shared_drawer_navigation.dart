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

mixin BasePageActionOnToolbarMixin<T extends StatefulWidget>
    on BasePageState<T> {
  List<ActionOnToolbarItem> actions = [];

  onActionOnToolbarCalled(ActionOnToolbarItem? item);

  getActionDesktopFirstPane(
      {TabControllerHelper? tab, ActionOnToolbarItem? selectedItem});

  getActionDesktopSecondPane(
      {TabControllerHelper? tab, ActionOnToolbarItem? selectedItem});

  getActionFirstPane(
      {TabControllerHelper? tab, ActionOnToolbarItem? selectedItem});

  getActionSecondPane(
      {TabControllerHelper? tab, ActionOnToolbarItem? selectedItem});

  ActionOnToolbarItem onActionInitial();

  ValueNotifier<ActionOnToolbarItem?> onActionAdd = ValueNotifier(null);

  @override
  Widget? getBaseAppbar() {
    if (actions.isEmpty) {
      actions = [onActionInitial()];
    }
    debugPrint("BasePageActionOnToolbar mixin is called");
    return ActionOnToolbarsas(this);
  }

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    return    ValueListenableBuilder(
        valueListenable: _selectedValue,
        builder: (context, value, child) {
          return Center(
              child: getWidgetFromProfile(context, value, pinToolbar));
        },
      );
  }

  Widget getWidget(bool firstPane,bool isDesktop) {
  
  }


}

class ActionOnToolbarItem {
  String title;
  IconData? icon;
  String? path;
  GestureTapCallback? onPress;
  ActionOnToolbarItem(
      {required this.title, this.icon, this.path, this.onPress});
}

class ActionOnToolbarsas<T extends BasePageActionOnToolbarMixin>
    extends StatefulWidget {
  T widget;
  ActionOnToolbarsas(this.widget);

  @override
  State<ActionOnToolbarsas<T>> createState() => _ActionOnToolbarsasState<T>();
}

class _ActionOnToolbarsasState<T extends BasePageActionOnToolbarMixin>
    extends State<ActionOnToolbarsas<T>> {
  late List<ActionOnToolbarItem> _actions;
  void onActionAdd() {
    debugPrint("_ActionOnToolbarsasState onActionAdd called");
    if (widget.widget.onActionAdd.value != null) {
      _actions.add(widget.widget.onActionAdd.value!);
    }
    widget.widget.onActionOnToolbarCalled(widget.widget.onActionAdd.value);
    setState(() {});
  }

  @override
  void initState() {
    debugPrint("_ActionOnToolbarsasState init");
    _actions = widget.widget.actions;
    widget.widget.onActionAdd.addListener(onActionAdd);
    super.initState();
  }

  @override
  void dispose() {
    widget.widget.onActionAdd.removeListener(onActionAdd);
    super.dispose();
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
            getIconWithText(context, widget.widget.actions[index]),
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
          widget.widget.onActionOnToolbarCalled(item);
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
