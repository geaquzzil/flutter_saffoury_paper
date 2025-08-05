// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
// import 'package:connectivity_listener/connectivity_listener.dart';
import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/view.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/slivers_widget/sliver_custom_scroll_draggable.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile_new.dart';
import 'package:flutter_view_controller/screens/web/web_shoping_cart.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'home/components/drawers/drawer_large_screen.dart';

/// WebSmothSceroll additional offset to users scroll input WEB WAS 150
const scrollOffset = 10;

///WebSmothSceroll animation duration WEB WAS 600
const animationDuration = 250;

const double kDefualtAppBar = 70;

const double kDefualtClipRect = 25;
//TODO sliver_tools https://github.com/Kavantix/hn_state_example/blob/master/lib/ui/pages/news/components/news_section.dart
//TODO
// Widget build(BuildContext context) {
//   return CustomScrollView(
//     slivers: [
//       SliverAppBar(),
//       Consumer<CustomerController>(
//         builder: (context, model, child) {
//           if (model.loading) {
//             return Loading();
//           }
//           else {
//             return MultiSliver(
//               children: [
//                 Header(),
//                 Saved(),
//                 Recommendations(),
//               ],
//             };
//           }
//         },
//       ),
//     ],
//   );
// }
mixin TickerWidget<T extends StatefulWidget> on State<T> {
  int getTickerSecond();

  Timer? _timer;

  void initTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(Duration(seconds: getTickerSecond()), (timer) {
      setState(() {});
    });
  }

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}
//TODO CarouselView
@Deprecated("To Develope ScrollController")
mixin BasePageWithTicker<T extends BasePage> on BasePageState<T> {
  ValueNotifier valueFirstPane = ValueNotifier(null);
  ValueNotifier valueSecondPane = ValueNotifier(null);

  ValueNotifierPane getTickerPane();

  getTickerPaneWidget({
    required bool firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  });

  int getTickerSecond();

  Timer? _timer;

  void initTimer() {
    if (_timer != null && _timer!.isActive) return;
    ValueNotifierPane p = getTickerPane();
    _timer = Timer.periodic(Duration(seconds: getTickerSecond()), (timer) {
      debugPrint("Ticker is active");
      switch (p) {
        case ValueNotifierPane.FIRST:
          valueFirstPane.value = Random().nextDouble();
          break;
        case ValueNotifierPane.SECOND:
          valueSecondPane.value = Random().nextDouble();
          break;
        case ValueNotifierPane.BOTH:
          valueFirstPane.value = Random().nextDouble();
          valueSecondPane.value = Random().nextDouble();
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  List<Widget>? getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    return [getWidgetFromBase(firstPane, tab: tab)];
  }

  Widget getWidgetFromBase(bool firstPane, {TabControllerHelper? tab}) {
    debugPrint("BasePageActionOnToolbarMixin getWidgetFromBase");
    ValueNotifierPane pane = getTickerPane();
    if (pane == ValueNotifierPane.NONE) {
      return getWidget(firstPane, tab: tab);
    }
    if (pane == ValueNotifierPane.BOTH) {
      return getValueListenableBuilder(firstPane, tab);
    }
    if (firstPane) {
      if (pane == ValueNotifierPane.FIRST) {
        return getValueListenableBuilder(firstPane, tab);
      } else {
        return getWidget(firstPane, tab: tab);
      }
    } else {
      if (pane == ValueNotifierPane.SECOND) {
        return getValueListenableBuilder(firstPane, tab);
      } else {
        return getWidget(firstPane, tab: tab);
      }
    }
  }

  Widget getValueListenableBuilder(bool firstPane, TabControllerHelper? tab) {
    return ValueListenableBuilder(
      valueListenable: firstPane ? valueFirstPane : valueSecondPane,
      builder: (context, value, child) {
        return getWidget(firstPane, tab: tab);
      },
    );
  }

  Widget getWidget(
    bool firstPane, {
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    return getTickerPaneWidget(
      firstPane: firstPane,
      tab: tab,
      secoundTab: secoundTab,
    );
  }
}
mixin BasePageWithThirdPaneMixinStatic<
  T extends BasePage,
  E extends ListToDetailsSecoundPaneHelper
>
    on BasePageState<T> {
  @override
  double getCustomPaneProportion() {
    return getThirdPane() == null ? .5 : 1 / 3;
  }

  Widget? getThirdPane();
  @override
  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: TowPaneExt(
        startPane: _secondWidget,
        customPaneProportion: .5,
        endPane: getThirdPane(),
      ),
      customPaneProportion: getCustomPaneProportion(),
    );
  }
}
mixin BasePageWithThirdPaneMixin<
  T extends BasePage,
  E extends ListToDetailsSecoundPaneHelper
>
    on BasePageState<T> {
  final ValueNotifier<E?> _valueNotifierSecondToThird = ValueNotifier(null);

  List<E> listOfStackedObject = [];
  void setThirdPane(E? value) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _valueNotifierSecondToThird.value = value;
    });
  }

  @override
  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _getSecondPaneWidgetMixin(),
      customPaneProportion: getCustomPaneProportion(),
    );
  }

  E? getPreviousPane(E? lastPane) {
    if (listOfStackedObject.length == 1 || listOfStackedObject.isEmpty) {
      return null;
    }
    if (lastPane == null) return null;
    int idx = listOfStackedObject.indexOf(lastPane);
    debugPrint(
      "BasePageWithThirdPaneMixin====> getPreviousPane total: ${listOfStackedObject.length} currentIndex: $idx previousIndex: ${idx - 1} ",
    );
    if (listOfStackedObject.length <= (idx - 1)) {
      return listOfStackedObject[idx - 1];
    }
    return null;
  }

  Widget getAppBarLeading(E? item) {
    E? previousPane = getPreviousPane(item);

    if (previousPane == null) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _valueNotifierSecondToThird.value = null;
        },
      );
    } else {
      return BackButton(
        onPressed: () {
          listOfStackedObject.remove(previousPane);
          _valueNotifierSecondToThird.value = previousPane
            ..shouldAddToThirdPaneList = false;
        },
      );
    }
  }

  AppBar getAppBarForThirdPane(E? selectedItem, Widget widget) {
    return AppBar(
      leading: getAppBarLeading(selectedItem),
      title: Text(selectedItem?.actionTitle ?? ""),
      //todo this flow not working
      actions: selectedItem?.getKey?.currentState
          ?.getAppbarActionsWhenThirdPane(),
    );
  }

  Widget wrapScaffoldInThirdPane({
    TabControllerHelper? tab,
    ListToDetailsSecoundPaneHelper? selectedItem,
  }) {
    Widget widget = getWidgetFromListToDetailsSecoundPaneHelper(
      selectedItem: selectedItem,
      tab: tab,
    );

    return Scaffold(
      appBar: getAppBarForThirdPane(selectedItem as E?, widget),
      body: widget,
    );
  }

  void checkValueToAddToList(E? value) {
    if (value == null) {
      listOfStackedObject.clear();
    } else {
      if (value.shouldAddToThirdPaneList) {
        listOfStackedObject.add(value);
      }
    }
  }

  bool canDoThirdPane() {
    return isLargeScreenFromCurrentScreenSize(context, width: getWidth);
  }

  Widget? _getSecondPaneWidgetMixin() {
    if (!isLargeScreenFromScreenSize(getCurrentScreenSize())) {
      return _secondWidget;
    }
    // return _secondWidget;
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint(
          "BasePageWithThirdPaneMixin constraints width : ${constraints.maxWidth} height: ${constraints.maxHeight}",
        );
        return ValueListenableBuilder(
          valueListenable: _valueNotifierSecondToThird,
          builder: (context, value, child) {
            bool showThirdPane = value != null;
            checkValueToAddToList(value);

            double width = showThirdPane
                ? constraints.maxWidth * 0.5
                : constraints.maxWidth;

            double height = constraints.maxHeight;

            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                    height: constraints.maxHeight,
                    width: width,
                    child: _secondWidget,
                  ),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: showThirdPane ? 1 : 0,
                              key: UniqueKey(),
                              child: const VerticalDivider(width: 1),
                            );
                          },
                          future: Future.delayed(
                            const Duration(milliseconds: 300),
                          ),
                        ),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          future: Future.delayed(
                            const Duration(milliseconds: 300),
                          ),
                          builder: (c, d) {
                            if (d.connectionState != ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              width: width - 1,
                              height: height,
                              child: AnimatedOpacity(
                                key: UniqueKey(),
                                duration: const Duration(milliseconds: 500),
                                opacity: showThirdPane ? 1 : 0,
                                curve: Curves.linear,
                                child: SlideInRight(
                                  duration: const Duration(milliseconds: 200),
                                  key: Key(value.actionTitle.toString()),
                                  // delay: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: wrapScaffoldInThirdPane(
                                    // tab:tab,
                                    selectedItem: value,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        );
      },
    );
    // return AnimatedContainer(duration: const Duration(milliseconds: 800),child: SizedBox(width: ,),);
  }
}

mixin BasePageSecoundPaneNotifierState<T extends BasePage> on BasePageState<T> {
  final ValueNotifier<SecondPaneHelper?> _onSecoundPaneChanged =
      ValueNotifier<SecondPaneHelper?>(null);

  ValueNotifier<SecondPaneHelper?> get getSecondPaneNotifier =>
      _onSecoundPaneChanged;
  // GlobalKey<ActionOnToolbarState> key = GlobalKey<ActionOnToolbarState>();
  SecondPaneHelper? _lastSecondPaneItem;
  SecondPaneHelper? get lastSecondPaneItem => this._lastSecondPaneItem;

  String onActionInitial();
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  });

  void notify(SecondPaneHelper? item) {
    debugPrint("notify");
    _onSecoundPaneChanged.value = item;
  }

  List<Widget>? getCustomViewWhenSecondPaneIsEmpty(
    ScrollController? controler,
    TabControllerHelper? tab,
  ) {
    return null;
  }

  bool enableAutomaticFirstPaneNullDetector() {
    return true;
  }

  void initSecToThirdPaneNotifier() {}
  bool isSelectForCard(dynamic value) {
    if (lastSecondPaneItem?.object is ViewAbstract) {
      return lastSecondPaneItem?.object.isEquals(value);
    }
    return false;
  }

  bool hasNotifierValue() {
    return _lastSecondPaneItem?.value != null;
  }

  dynamic geSelectedValue() {
    return lastSecondPaneItem?.value;
  }

  SecondPaneHelper getInitialAction() {
    return SecondPaneHelper(title: onActionInitial());
  }

  SecoundPaneHelperWithParentValueNotifier getSecoundPaneHelper() {
    return SecoundPaneHelperWithParentValueNotifier(
      onBuild: onBuild,
      parent: this,
      secPaneNotifier: getSecondPaneNotifier,
    );
  }

  @override
  bool isFirstPane({bool? firstPane}) {
    if (isMobile(context, maxWidth: getWidth)) {
      return _lastSecondPaneItem == null;
    }
    return super.isFirstPane(firstPane: firstPane);
  }

  @override
  bool isSecPane({bool? firstPane}) {
    if (isMobile(context, maxWidth: getWidth)) {
      return _lastSecondPaneItem != null;
    }
    return super.isSecPane(firstPane: firstPane);
  }

  @override
  Widget? getBaseAppbarTitle() {
    if (widget.parent == null) {
      return ActionOnToolbar(
        widget: this,
        actions: [getInitialAction()],
        // key: key,
      );
    }
    return null;
  }

  @override
  Widget getOnlyFirstPage() {
    _firstWidget = FadeInUp(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      key: Key(_lastSecondPaneItem.hashCode.toString()),
      child: super.getOnlyFirstPage(),
    );
    return _firstWidget;
  }

  bool canDoThirdPane() {
    return isLargeScreenFromCurrentScreenSize(context, width: getWidth);
  }

  bool isLargeScoso() {
    return isLargeScreenFromCurrentScreenSize(context, width: getWidth);
  }

  // Widget? _getSecondPaneWidgetMixin() {
  //   if (!isLargeScreenFromScreenSize(getCurrentScreenSize())) {
  //     return _secondWidget;
  //   }
  //   // return _secondWidget;
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       debugPrint(
  //           "BasePageWithThirdPaneMixin constraints width : ${constraints.maxWidth} height: ${constraints.maxHeight}");
  //       return ValueListenableBuilder(
  //         valueListenable: _onSecoundPaneChanged,
  //         builder: (context, value, child) {
  //           bool showThirdPane = value != null;
  //           // checkValueToAddToList(value);

  //           double width = showThirdPane
  //               ? constraints.maxWidth * 0.5
  //               : constraints.maxWidth;

  //           double height = constraints.maxHeight;

  //           return SizedBox(
  //             height: constraints.maxHeight,
  //             width: constraints.maxWidth,
  //             child: Row(
  //               children: [
  //                 AnimatedContainer(
  //                     duration: const Duration(milliseconds: 200),
  //                     curve: Curves.linear,
  //                     height: constraints.maxHeight,
  //                     width: width,
  //                     child: _secondWidget),
  //                 !showThirdPane
  //                     ? const SizedBox.shrink()
  //                     : FutureBuilder(
  //                         builder: (context, snapshot) {
  //                           if (snapshot.connectionState !=
  //                               ConnectionState.done) {
  //                             return const SizedBox.shrink();
  //                           }
  //                           return AnimatedOpacity(
  //                             duration: const Duration(milliseconds: 500),
  //                             opacity: showThirdPane ? 1 : 0,
  //                             key: UniqueKey(),
  //                             child: const VerticalDivider(
  //                               width: 1,
  //                             ),
  //                           );
  //                         },
  //                         future:
  //                             Future.delayed(const Duration(milliseconds: 300)),
  //                       ),
  //                 !showThirdPane
  //                     ? const SizedBox.shrink()
  //                     : FutureBuilder(
  //                         future:
  //                             Future.delayed(const Duration(milliseconds: 300)),
  //                         builder: (c, d) {
  //                           if (d.connectionState != ConnectionState.done) {
  //                             return const SizedBox.shrink();
  //                           }
  //                           return SizedBox(
  //                             width: width - 1,
  //                             height: height,
  //                             child: AnimatedOpacity(
  //                               key: UniqueKey(),
  //                               duration: const Duration(milliseconds: 500),
  //                               opacity: showThirdPane ? 1 : 0,
  //                               curve: Curves.linear,
  //                               child: SlideInRight(
  //                                 duration: const Duration(milliseconds: 200),
  //                                 key: Key(value.title.toString()),
  //                                 // delay: Duration(milliseconds: 1000),
  //                                 curve: Curves.fastLinearToSlowEaseIn,
  //                                 child: wrapScaffoldInThirdPane(
  //                                     // tab:tab,
  //                                     selectedItem: value),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       )
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  //   // return AnimatedContainer(duration: const Duration(milliseconds: 800),child: SizedBox(width: ,),);
  // }

  @override
  Widget getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: FadeInUp(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        key: Key(_lastSecondPaneItem.hashCode.toString()),
        child: _secondWidget,
      ),
      customPaneProportion: reverseCustomPane()
          ? 1 - getCustomPaneProportion()
          : getCustomPaneProportion(),
    );
  }

  @override
  void initState() {
    _onSecoundPaneChanged.addListener(onPaneChanged);

    // test = widget.valueNotifierIfThirdPane;
    // _lastSecondPaneItem = widget.selectedItem;///TODO
    super.initState();
  }

  @override
  void dispose() {
    _onSecoundPaneChanged.removeListener(onPaneChanged);
    super.dispose();
  }

  @override
  Widget? getAppbarLeading({bool? firstPane}) {
    debugPrint("getAppbarLeading $firstPane selected: $_lastSecondPaneItem");
    if (isMobile(context, maxWidth: getWidth)) {
      if (_lastSecondPaneItem != null) {
        if (firstPane == true) {
          return BackButton(
            onPressed: () {
              setState(() {
                _onSecoundPaneChanged.value = null;
                // _lastItem = null;

                forceBuildAppBar = false;
                pinToolbar = false;
              });
            },
          );
        }
      }
    } else {
      if (firstPane == false && _onSecoundPaneChanged.value != null) {
        return CloseButton(
          onPressed: () {
            setState(() {
              _onSecoundPaneChanged.value = null;
              // _lastItem = null;

              forceBuildAppBar = false;
              pinToolbar = false;
            });
          },
        );
      }
    }
    return super.getAppbarLeading(firstPane: firstPane);
  }

  void onSubPaneChanged() {}

  void onPaneChanged() {
    setState(() {
      _lastSecondPaneItem = _onSecoundPaneChanged.value;
      if (isMobile(context, maxWidth: getWidth)) {
        forceBuildAppBar = true;
        pinToolbar = false;
      }
    });
  }

  @override
  List<Widget>? getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    bool isMobile = isMobileFromWidth(getWidth);
    debugPrint("getPane getPane isMobile $isMobile forstPane $firstPane");
    if (enableAutomaticFirstPaneNullDetector() &&
        isSecPane(firstPane: firstPane) &&
        !hasNotifierValue() &&
        !isMobile &&
        tab == null) {
      debugPrint(
        "getPane getPane enableAutomaticFirstPaneNullDetector() &&  isSecPane(firstPane: firstPane) & !hasNotifierValue() &&",
      );
      List<Widget>? widgets = getCustomViewWhenSecondPaneIsEmpty(
        controler,
        tab,
      );
      if (widgets != null) return widgets;

      return [SliverFillRemaining(child: EmptyWidget.emptyPage(context))];
    }

    if (isMobileFromWidth(getWidth) && hasNotifierValue()) {
      debugPrint(
        "getPane getPane isMobileFromWidth(getWidth) && hasNotifierValue()",
      );

      return getAutomaticSecoundPane(
        firstPane: false,
        controler: controler,
        tab: tab,
      );
    }
    if (firstPane) {
      if (isMobileFromWidth(getWidth)) {
        List<Widget>? widgets = getCustomViewWhenSecondPaneIsEmpty(
          controler,
          tab,
        );

        return [
          ...getPaneNotifier(
                firstPane: firstPane,
                controler: controler,
                tab: tab,
              ) ??
              [],
          if (widgets != null) ...widgets,
        ];
      }
      return getPaneNotifier(
        firstPane: firstPane,
        controler: controler,
        tab: tab,
      );
    }
    return getAutomaticSecoundPane(
      firstPane: firstPane,
      controler: controler,
      tab: tab,
    );
  }

  List<Widget>? getAutomaticSecoundPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    if (_lastSecondPaneItem?.value is List<Widget>) {
      return _lastSecondPaneItem?.value;
    } else if (_lastSecondPaneItem?.value is ViewAbstract) {
      return [
        SliverFillRemaining(
          child: ViewNew(
            extras: _lastSecondPaneItem!.value,
            iD: _lastSecondPaneItem!.value.iD,
            tableName: _lastSecondPaneItem!.value.getTableNameApi(),
            onBuild: onBuild,
            key: _lastSecondPaneItem!.value.getKeyForWidget(
              context,
              ServerActions.view,
            ),
            parent: this,
          ),
        ),
      ];
    } else if (_lastSecondPaneItem?.value is BasePage) {
      return [
        SliverFillRemaining(
          child: (_lastSecondPaneItem!.value as BasePage)
            ..setParent = this
            ..setParentOnBuild = onBuild,
        ),
      ];
    } else {
      return getPaneNotifier(
        firstPane: firstPane,
        controler: controler,
        tab: tab,
        valueNotifier: _lastSecondPaneItem,
      );
    }
  }

  TabControllerHelper? findExtrasViaType(Type runtimeType) {
    return null;
  }
}
mixin BasePageThirdPaneNotifierState<T extends BasePageSecoundPaneNotifier>
    on BasePageSecoundPaneNotifierState {
  List<Widget>? getThirdPane();
  final ValueNotifier<ThirdToSecondPaneHelper?> _valueNotifierSecondToThird =
      ValueNotifier(null);

  List<ThirdToSecondPaneHelper> listOfStackedObject = [];
  void setThirdPane(ThirdToSecondPaneHelper? value) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _valueNotifierSecondToThird.value = value;
    });
  }

  @override
  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _getSecondPaneWidgetMixin(),
      customPaneProportion: getCustomPaneProportion(),
    );
  }

  ThirdToSecondPaneHelper? getPreviousPane(ThirdToSecondPaneHelper? lastPane) {
    if (listOfStackedObject.length == 1 || listOfStackedObject.isEmpty) {
      return null;
    }
    if (lastPane == null) return null;
    int idx = listOfStackedObject.indexOf(lastPane);
    debugPrint(
      "BasePageWithThirdPaneMixin====> getPreviousPane total: ${listOfStackedObject.length} currentIndex: $idx previousIndex: ${idx - 1} ",
    );
    if (listOfStackedObject.length <= (idx - 1)) {
      return listOfStackedObject[idx - 1];
    }
    return null;
  }

  Widget getAppBarLeading(ThirdToSecondPaneHelper? item) {
    ThirdToSecondPaneHelper? previousPane = getPreviousPane(item);

    if (previousPane == null) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _valueNotifierSecondToThird.value = null;
        },
      );
    } else {
      return BackButton(
        onPressed: () {
          listOfStackedObject.remove(previousPane);
          _valueNotifierSecondToThird.value = previousPane
            ..shouldAddToThirdPaneList = false;
        },
      );
    }
  }

  AppBar getAppBarForThirdPane(
    ThirdToSecondPaneHelper? selectedItem,
    Widget widget,
  ) {
    return AppBar(
      leading: getAppBarLeading(selectedItem),
      title: Text(selectedItem?.title ?? ""),
      //todo this flow not working
      // actions:
      //     selectedItem?.getKey?.currentState?.getAppbarActionsWhenThirdPane(),
    );
  }

  Widget wrapScaffoldInThirdPane({
    TabControllerHelper? tab,
    ThirdToSecondPaneHelper? selectedItem,
  }) {
    // Widget widget = getWidgetFromListToDetailsSecoundPaneHelper(
    //     selectedItem: selectedItem, tab: tab);

    return Scaffold(
      appBar: getAppBarForThirdPane(selectedItem, widget),
      body: widget,
    );
  }

  void checkValueToAddToList(ThirdToSecondPaneHelper? value) {
    if (value == null) {
      listOfStackedObject.clear();
    } else {
      if (value.shouldAddToThirdPaneList) {
        listOfStackedObject.add(value);
      }
    }
  }

  @override
  bool canDoThirdPane() {
    return isLargeScreenFromCurrentScreenSize(context, width: getWidth);
  }

  Widget? _getSecondPaneWidgetMixin() {
    if (!isLargeScreenFromScreenSize(getCurrentScreenSize())) {
      return _secondWidget;
    }
    // return _secondWidget;
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint(
          "BasePageWithThirdPaneMixin constraints width : ${constraints.maxWidth} height: ${constraints.maxHeight}",
        );
        return ValueListenableBuilder(
          valueListenable: _valueNotifierSecondToThird,
          builder: (context, value, child) {
            bool showThirdPane = value != null;
            checkValueToAddToList(value);

            double width = showThirdPane
                ? constraints.maxWidth * 0.5
                : constraints.maxWidth;

            double height = constraints.maxHeight;

            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                    height: constraints.maxHeight,
                    width: width,
                    child: _secondWidget,
                  ),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: showThirdPane ? 1 : 0,
                              key: UniqueKey(),
                              child: const VerticalDivider(width: 1),
                            );
                          },
                          future: Future.delayed(
                            const Duration(milliseconds: 300),
                          ),
                        ),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          future: Future.delayed(
                            const Duration(milliseconds: 300),
                          ),
                          builder: (c, d) {
                            if (d.connectionState != ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              width: width - 1,
                              height: height,
                              child: AnimatedOpacity(
                                key: UniqueKey(),
                                duration: const Duration(milliseconds: 500),
                                opacity: showThirdPane ? 1 : 0,
                                curve: Curves.linear,
                                child: SlideInRight(
                                  duration: const Duration(milliseconds: 200),
                                  key: Key(value.title.toString()),
                                  // delay: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: wrapScaffoldInThirdPane(
                                    // tab:tab,
                                    selectedItem: value,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        );
      },
    );
    // return AnimatedContainer(duration: const Duration(milliseconds: 800),child: SizedBox(width: ,),);
  }
}

abstract class BasePageSecoundPaneNotifier<T> extends BasePage {
  // T? selectedItem;

  bool setToShowThirdPaneIfCan;

  @Deprecated("")
  ValueNotifier<SecondPaneHelper?>? valueNotifierIfThirdPane;

  BasePageSecoundPaneNotifier({
    super.buildDrawer,
    super.buildSecondPane,
    super.isFirstToSecOrThirdPane,
    this.setToShowThirdPaneIfCan = false,
    super.parent,
    super.forceHeaderToCollapse,
    this.valueNotifierIfThirdPane,
    super.onBuild,
    super.key,
  });
}

abstract class BasePage extends StatefulWidget {
  final bool buildDrawer;
  final bool buildSecondPane;
  final bool forceHeaderToCollapse;
  final bool fillFirstPaneToAnimateTheThirdPane;
  BasePageState? parent;
  ValueNotifier? onBuild;

  final bool isFirstToSecOrThirdPane;
  BasePage({
    super.key,
    this.buildDrawer = false,
    this.buildSecondPane = true,
    this.forceHeaderToCollapse = false,
    this.fillFirstPaneToAnimateTheThirdPane = false,
    this.parent,
    this.onBuild,
    this.isFirstToSecOrThirdPane = false,
  });

  set setParent(final parent) => this.parent = parent;
  set setParentOnBuild(final onBuild) => this.onBuild = onBuild;
  Key? get getKey => key;
}

abstract class BasePageApi extends BasePage {
  final int? iD;
  final String? tableName;
  final dynamic extras;
  BasePageApi({
    super.key,
    this.iD,
    this.tableName,
    required this.extras,
    super.buildDrawer,
    super.onBuild,
    super.parent,
    super.buildSecondPane,
    super.fillFirstPaneToAnimateTheThirdPane,
    super.forceHeaderToCollapse,
    super.isFirstToSecOrThirdPane,
  });
}

///Auto generate view
///[CurrentScreenSize.MOBILE] if this  is true
///
///
///
abstract class BasePageState<T extends BasePage> extends State<T>
    with TickerProviderStateMixin {
  dynamic _firstWidget;
  dynamic _secondWidget;
  late double _width;
  late double _height;

  late double _firstPaneWidth;
  late double _secPaneWidth;

  bool _isInitialization = true;
  bool pinToolbar = false;
  bool forceBuildAppBar = false;
  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  List<GlobalKey<BasePageState>?>? childs;

  ValueNotifier onBuild = ValueNotifier(null);

  List<Widget>? secondPaneWidgets;

  Widget? _drawerWidget;
  late bool buildDrawer;
  late bool _buildSecoundPane;
  bool isSelectedMode = false;

  bool _isTabInited = false;

  DrawerMenuControllerProvider get drawerMenuControllerProvider =>
      _drawerMenuControllerProvider;

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (_tabList == null) {
      _initBaseTab();
    }
    buildDrawer = widget.buildDrawer;
    _buildSecoundPane = widget.buildSecondPane;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _drawerMenuControllerProvider = context
        .read<DrawerMenuControllerProvider>();
    buildDrawer = widget.buildDrawer;
    _buildSecoundPane = widget.buildSecondPane;
    // _connectionListener.init(
    //   onConnected: () => debugPrint("BasePage CONNECTED"),
    //   onReconnected: () => debugPrint("BasePage RECONNECTED"),
    //   onDisconnected: () => debugPrint("BasePage  DISCONNECTED"),
    // );
    WidgetsBinding.instance.endOfFrame.then((_) {
      debugPrint("onBuildCalled $runtimeType");
      widget.onBuild?.value = Random()..nextInt(10000);
    });
    super.initState();
  }

  // The listener
  // final _connectionListener = ConnectionListener();

  final firstPaneScaffold = GlobalKey<ScaffoldMessengerState>();
  final secondPaneScaffold = GlobalKey<ScaffoldMessengerState>();
  final ValueNotifier<int> baseBottomSheetValueNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> firstPaneBottomSheetValueNotifier =
      ValueNotifier<int>(0);
  final ValueNotifier<int> secoundPaneBottomSheetValueNotifier =
      ValueNotifier<int>(0);
  late CurrentScreenSize _currentScreenSize;
  TabController? _tabBaseController;
  int currentBaseTabIndex = 0;
  List<TabControllerHelper>? _tabList;
  ValueNotifier<int> onTabSelectedSecondPane = ValueNotifier<int>(0);

  List<Widget>? getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  });
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  });

  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  });

  Widget? getFloatingActionButton({bool? firstPane, TabControllerHelper? tab});
  Widget? getBottomNavigationBar({bool? firstPane, TabControllerHelper? tab}) {
    return null;
  }

  Future<void>? getPaneIsRefreshIndicator({required bool firstPane});

  //FIXME What if firstPane==null and it has widget
  Widget? getAppbarTitle({bool? firstPane, TabControllerHelper? tab});
  Widget? getAppbarLeading({bool? firstPane}) {
    return null;
  }

  bool isPaneScaffoldOverlayColord(bool firstPane);
  bool setPaneBodyPaddingHorizontal(bool firstPane);

  bool setPaneBodyPaddingVertical(bool firstPane) {
    return false;
  }

  bool setClipRect(bool? firstPane);

  double get getWidth => this._width;

  double get getHeight => this._height;
  double get firstPaneWidth => this._firstPaneWidth;
  double get secPaneWidth => this._secPaneWidth;

  DrawerMenuItem? lastDrawerItemSelected;

  bool isDesktopPlatform() => isDesktop(context);

  List<TabControllerHelper>? initTabBarList({
    bool? firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  List<TabControllerHelper> _getTabBarList() {
    return _tabList!;
  }

  bool _hasTabBarList() {
    return _tabList != null;
  }

  PreferredSizeWidget? getTabBarWidget() {
    if (!_hasTabBarList()) {
      debugPrint("getTabBarWidget !has tabBarList pane ");
      return null;
    }

    return TabBar(
      controller: _tabBaseController,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(80.0),
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      // labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
      isScrollable: true,
      //  firstPane != null,
      tabs: _getTabBarList(),
    );
  }

  ///set padding to content view pased on the screen size
  ///if this is [true] then we add divider between panes
  ///if this is [false] then we check for second pane if no second pane then we add padding automatically
  ///todo tab not working here it will execute globaley
  bool setMainPageSuggestionPadding();

  bool setHorizontalDividerWhenTowPanes();

  bool _hasHorizontalDividerWhenTowPanes() {
    if (_secondWidget != null) {
      return setHorizontalDividerWhenTowPanes();
    }
    return false;
  }

  bool reverseCustomPane() {
    return false;
  }

  bool forceDisabledActions() {
    return false;
  }

  double getCustomPaneProportion() {
    {
      CurrentScreenSize s = getCurrentScreenSize();
      debugPrint("getCustomPaneProportion called");
      // if ( return 0.5;
      if (s == CurrentScreenSize.MOBILE ||
          s == CurrentScreenSize.SMALL_TABLET ||
          MediaQuery.of(context).hinge != null) {
        return 0.5;
      }
      if (SizeConfig.isMediumFromScreenSize(context, width: getWidth)) {
        return 0.5;
      } else {
        double defualtWidth = 0;
        if (s case CurrentScreenSize.DESKTOP) {
          defualtWidth = kDesktopWidth;
          return .3;
        } else if (s case CurrentScreenSize.LARGE_TABLET) {
          defualtWidth = kLargeTablet;
        } else if (s case CurrentScreenSize.MOBILE) {
          return .5;
        } else if (s case CurrentScreenSize.SMALL_TABLET) {
          return .5;
        }

        double sss = max(defualtWidth - _width, _width - defualtWidth);
        debugPrint(
          " current width $_width  defualt width $defualtWidth   VALUE=$sss  ",
        );

        return sss > 250 ? 0.3 : 0.5;
      }
    }
  }

  List<Widget>? getAppbarActions({bool? firstPane}) {
    return null;
  }

  List<Widget>? getAppbarActionsWhenThirdPane() {
    return null;
  }

  Widget? getBaseAppbarTitle() {
    return getAppbarTitle(firstPane: null);
  }

  ///generate all toolbars for the base and first pane and second pane
  ///if [customAppBar] is null then generates the base toolbar
  ///else if [customAppBar] is not null then generates the app bar based on the panes
  AppBar? generateBaseAppbar() {
    List<Widget>? actions = getAppbarActions(firstPane: null);
    Widget? title = getBaseAppbarTitle();
    bool isEmpty = forceDisabledActions() || actions?.isEmpty == true;
    if (actions == null && title == null) return null;
    return AppBar(
      surfaceTintColor: Colors.transparent,
      // elevation: 10,
      // toolbarHeight: 100,
      forceMaterialTransparency: true,
      actions: isEmpty || widget.isFirstToSecOrThirdPane
          ? [Container()]
          : [...actions ?? [], ...getSharedAppBarActions],
      automaticallyImplyLeading: false,

      // backgroundColor: ElevationOverlay.overlayColor(context, 1),
      title: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: title,
      ),
      leading: widget.isFirstToSecOrThirdPane
          ? null
          : hideHamburger(context)
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _drawerMenuControllerProvider.controlStartDrawerMenu();
              },
            ),
      bottom: getTabBarWidget(),
    );
  }

  List<Widget> get getSharedAppBarActions {
    return [
      if (context.read<AuthProvider<AuthUser>>().hasNotificationWidget())
        NotificationPopupWidget(),
      if (context.read<AuthProvider<AuthUser>>().hasNotificationWidget())
        const SizedBox(width: kDefaultPadding / 2),
      const DrawerLanguageButton(),
      const SizedBox(width: kDefaultPadding / 2),
      const ProfilePicturePopupMenu(),
      const SizedBox(width: kDefaultPadding / 2),
      ElevatedButton.icon(
        // statesController: WidgetStatesController(),
        label: const Icon(Icons.settings),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          context.read<DrawerMenuControllerProvider>().change(
            context,
            SettingPageNew(),
            // SettingAndProfileWeb(),
            DrawerMenuControllerProviderAction.custom_widget,
          );
        },
      ),
    ];
  }

  bool isFirstPane({bool? firstPane}) {
    return firstPane != null && firstPane == true;
  }

  bool isSecPane({bool? firstPane}) {
    return !isFirstPane(firstPane: firstPane);
  }

  ///by default this is hidden when scrolling
  Widget getSliverAppBar(
    Widget widget, {
    bool pinned = false,
    bool floating = true,
    double height = kDefualtAppBar,
  }) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: SliverAppBarDelegatePreferedSize(
        shouldRebuildWidget: true,
        child: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: widget,
        ),
      ),
    );
  }

  // Widget checkTogetTabbarSliver(bool firstPane) {
  //   if (firstPane) {
  //     return getTabbarSliver(_tabListFirstPane!, _tabControllerFirstPane!);
  //   } else {
  //     return getTabbarSliver(_tabListSecondPane!, _tabControllerSecondPane!);
  //   }
  // }

  // Widget getTabbarSliver(
  //     List<TabControllerHelper> tabs, TabController tabController) {
  //   return SliverSafeArea(
  //     sliver: SliverPadding(
  //       padding: EdgeInsets.zero,
  //       sliver: SliverPersistentHeader(
  //           pinned: true,
  //           delegate: SliverAppBarDelegatePreferedSize(
  //               wrapWithSafeArea: true,
  //               child: ColoredTabBar(
  //                 useCard: false,
  //                 color: Theme.of(context).colorScheme.surface.withOpacity(.9),
  //                 cornersIfCard: 80.0,
  //                 // color: Theme.of(context).colorScheme.surfaceVariant,
  //                 child: TabBar(
  //                   dividerColor: Colors.transparent,
  //                   tabs: tabs,
  //                   isScrollable: true,
  //                   controller: tabController,
  //                 ),
  //               ))),
  //     ),
  //   );
  // }

  // ScrollController getScrollController(bool firstPane,
  //     {TabControllerHelper? tab}) {
  //   if (tab != null) {
  //     return firstPane
  //         ? tab.scrollFirstPaneController
  //         : tab.scrollSecoundPaneController;
  //   }
  //   return firstPane
  //       ? _scrollFirstPaneController
  //       : _scrollSecoundPaneController;
  // }

  // Widget? _getScrollContent(widget, Widget? appBar, bool firstPane,
  //     {TabControllerHelper? tab}) {
  //   dynamic body = widget;
  //   bool isPaneIsSliver = isPanesIsSliver(firstPane, tab: tab);
  //   debugPrint(
  //       "BasePage IsPanel isSliver started=> firstPane $firstPane ,isPaneIsSliver:$isPaneIsSliver body : $body");

  //   if (isPaneIsSliver) {
  //     List<Widget> list = body;

  //     if (SizeConfig.isDesktopOrWebPlatform(context)) {
  //       body = ResponsiveScroll(
  //         controller: getScrollController(firstPane, tab: tab),
  //         animationDuration: animationDuration,
  //         scrollOffset: scrollOffset,
  //         child: getCustomScrollView(firstPane, tab, appBar, list),
  //       );
  //     } else {
  //       return getCustomScrollView(firstPane, tab, appBar, list);
  //     }
  //   }

  //   return body;
  // }

  // Widget getCustomScrollView(bool firstPane, TabControllerHelper? tab,
  //     Widget? appBar, List<Widget> list) {
  //   return SafeArea(
  //     child: CustomScrollView(
  //       physics: const BouncingScrollPhysics(
  //         parent: AlwaysScrollableScrollPhysics(),
  //       ),
  //       controller: getScrollController(firstPane, tab: tab),
  //       slivers: [
  //         if (appBar != null) getSliverAppBar(appBar),
  //         if (_hasTabBarList(firstPane: firstPane))
  //           checkTogetTabbarSliver(firstPane),
  //         ...list
  //       ],
  //     ),
  //   );
  // }

  ///setting appbar but when is sliver then we added to CustomScrollView Sliver
  // Widget? _setSubAppBar(widget, bool firstPane,
  //     {TabControllerHelper? tab, TabControllerHelper? sec}) {
  //   Widget? appBarBody =
  //       getAppbarTitle(firstPane: firstPane, tab: tab, secoundTab: sec);
  //   Widget? body = _getScrollContent(widget, appBarBody, firstPane, tab: tab);
  //   debugPrint("BasePage getScrollContent finished");
  //   Widget scaffold = Scaffold(
  //     // key: firstPane ? firstPaneScaffold : secondPaneScaffold,
  //     backgroundColor: isPaneScaffoldOverlayColord(firstPane, tab: tab)
  //         ? ElevationOverlay.overlayColor(context, 0)
  //         : null,
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  //     floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
  //     floatingActionButton: getFloatingActionButton(
  //         firstPane: firstPane, tab: tab, secoundTab: sec),
  //     appBar: isPanesIsSliver(firstPane, tab: tab)
  //         ? null
  //         : generateToolbar(firstPane: firstPane, tab: tab, sec: sec),
  //     body: Padding(
  //       padding: setPaneBodyPadding(firstPane, tab: tab)
  //           ? const EdgeInsets.all(kDefaultPadding / 2)
  //           : EdgeInsets.zero,
  //       child: body,
  //     ),
  //   );

  //   if (setPaneClipRect(firstPane, tab: tab)) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(kBorderRadius),
  //       child: scaffold,
  //     );
  //   }
  //   return scaffold;
  // }

  Widget _getBorderDecoration(Widget widget) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: .5, color: Theme.of(context).dividerColor),
        ),
      ),
      child: widget,
    );
  }

  void _initBaseTab() {
    if (_isTabInited) return;
    _isTabInited = true;
    _tabList = initTabBarList();

    /// Here you can have your context and do what ever you want
    if (_hasTabBarList()) {
      _tabBaseController = TabController(vsync: this, length: _tabList!.length);
      _tabBaseController!.addListener(_tabControllerChangeListener);
    }
  }

  @override
  void dispose() {
    // _connectionListener.dispose();
    if (_hasTabBarList()) {
      _tabBaseController!.removeListener(_tabControllerChangeListener);
      _tabBaseController!.dispose();
    }
    super.dispose();
  }

  CurrentScreenSize getCurrentScreenSize() {
    return _currentScreenSize;
  }

  void addFramPost(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  void setSideMenuClosed() {
    addFramPost((p0) {
      context.read<DrawerMenuControllerProvider>().setSideMenuIsClosed();
    });
  }

  void setSideMenuOpen() {
    addFramPost((p0) {
      context.read<DrawerMenuControllerProvider>().setSideMenuIsOpen();
    });
  }

  void reset() {
    _secondWidget = null;
    _firstWidget = null;
    _width = 0;
    _height = 0;
  }

  Widget wrapBuildWidget(Widget buildWidget) {
    return buildWidget;
  }

  @override
  Widget build(BuildContext context) {
    _initBaseTab();

    return wrapBuildWidget(
      ScreenHelperSliver(
        forceSmallView:
            !_buildSecoundPane || widget.fillFirstPaneToAnimateTheThirdPane,
        requireAutoPadding: setMainPageSuggestionPadding(),
        onChangeLayout: (w, h, c) {
          debugPrint("ScreenHelperSliver build width:$w");
          reset();
          _width = w;
          _height = h;
          _currentScreenSize = c;
          if (canBuildDrawer()) {
            _drawerWidget =
                _generateCustomDrawer() ??
                DrawerLargeScreens(size: _currentScreenSize);
          }
          _firstPaneWidth =
              (reverseCustomPane()
                  ? 1 - getCustomPaneProportion()
                  : getCustomPaneProportion()) *
              _width;

          _secPaneWidth = _width - _firstPaneWidth;

          debugPrint(
            "BasePage firstPane is w=>$_firstPaneWidth  h=> $_secPaneWidth",
          );
        },
        mobile: (w, h) {
          return getOnlyFirstPage();
        },
        smallTablet: (w, h) {
          return _getMainWidget();
        },
        largeTablet: (w, h) {
          return _getMainWidget();
        },
        desktop: (w, h) {
          return _getMainWidget();
        },
      ),
    );
  }

  Widget getOnlyFirstPage() {
    _firstWidget = getScaffoldForPane(firstPane: true);
    return _firstWidget;
  }

  Widget getWidgetFromListToDetailsSecoundPaneHelper({
    TabControllerHelper? tab,
    ListToDetailsSecoundPaneHelper? selectedItem,
  }) {
    if (selectedItem == null) {
      return ListView(
        children: [
          // EditNew(
          //   viewAbstract: context
          //       .read<DrawerMenuControllerProvider>()
          //       .getObjectCastViewAbstract,
          // )
        ],
      );
      // return const Padding(
      //   padding: EdgeInsets.all(20),
      //   child: Column(
      //     children: [
      //       ExpansionEdit(
      //         title: Text("dsadassa"),
      //         leading: Icon(Icons.one_x_mobiledata_outlined),
      //       ),
      //       ExpansionEdit(
      //         isNullable: true,
      //         title: Text("dsadassa"),
      //         leading: Icon(Icons.abc),
      //       ),
      //       ExpansionEdit(
      //         title: Text("dsadassa"),
      //         leading: Icon(Icons.accessible_forward_sharp),
      //       ),
      //     ],
      //   ),
      // );
    }
    int iD = selectedItem.viewAbstract?.iD ?? -1;
    String tableName = selectedItem.viewAbstract?.getTableNameApi() ?? "";
    debugPrint(
      "ListToDetailsSecoundPane is _isInitialization $_isInitialization",
    );
    Widget currentWidget;
    if (!_isInitialization) {
      debugPrint("ListToDetailsSecoundPane is initial call addAction");
      if (this is BasePageActionOnToolbarMixin) {
        (this as BasePageActionOnToolbarMixin).addAction(
          selectedItem,
          notifyListener: false,
        );
      }
    } else {
      _isInitialization = false;
    }
    switch (selectedItem.action) {
      case ServerActions.custom_widget:
        currentWidget = selectedItem.customWidget!;
        break;
      case ServerActions.add:
        currentWidget = BaseEditNewPage(
          viewAbstract: context
              .read<DrawerMenuControllerProvider>()
              .getObjectCastViewAbstract
              .getNewInstance(),
        );
        break;
      case ServerActions.edit:
        currentWidget = BaseEditNewPage(
          viewAbstract: selectedItem.viewAbstract!,
        );
        break;
      case ServerActions.view:
        currentWidget = BaseViewNewPage(
          // actionOnToolbarItem: getOnActionAdd,
          // key: widget.key,
          viewAbstract: selectedItem.viewAbstract!,
        );
        break;
      case ServerActions.print:
        selectedItem.setKey = GlobalKey<BasePageStateWithApi>();
        currentWidget = PdfPageNew(
          key: selectedItem.getKey,
          buildSecondPane: false,
          isFirstToSecOrThirdPane: true,
          iD: iD,
          tableName: tableName,
          extras: selectedItem.viewAbstract! as PrintableMaster,
        );
        // currentWidget = const Text("dsadaz");
        break;
      case ServerActions.delete_action:
      case ServerActions.call:
      case ServerActions.file:
      case ServerActions.list_reduce_size:
      case ServerActions.search:
      case ServerActions.search_by_field:
      case ServerActions.search_viewabstract_by_field:
      case ServerActions.notification:
      case ServerActions.file_export:
      case ServerActions.file_import:
      case ServerActions.list:
        currentWidget = Container();
    }
    ViewAbstract? secoundPaneViewAbstract = selectedItem.viewAbstract;
    if (secoundPaneViewAbstract != null && tab?.widget != null) {
      return tab!.widget!;
    }
    // if (selectedItem.subObject != null) {
    //   if (this is BasePageWithThirdPaneMixin)
    //     (this as BasePageWithThirdPaneMixin).setThirdPane(currentWidget);
    // }
    return currentWidget;
  }

  void setChilds(List<Widget>? list) {
    childs ??= list
        ?.whereType<SliverFillRemaining>()
        .map((l) {
          debugPrint(
            "BasePage setChilds =>where type is SliverFillRemaining child=> runtimeType ${l.child.runtimeType}",
          );
          if (l.child is BasePage) {
            debugPrint("BasePage setChilds => setting custom and parent");
            if ((l.child as BasePage).getKey != null) {
              return (l.child as BasePage).getKey as GlobalKey<BasePageState>?;
            }

            return null;
          }
        })
        .where((c) => c != null)
        .toList();

    if (childs?.isEmpty == true) {
      childs = null;
    }

    debugPrint("BasePage setChilds results = $childs");
  }

  GlobalKey<BasePageState> getKeyForChild() {
    if (childs != null) {
      return childs![0]!;
    }
    GlobalKey<BasePageState> child = GlobalKey<BasePageState>();
    childs = [child];

    debugPrint("getKeyForChilds $childs");
    return child;
  }

  List<Widget>? beforeGetPaneWidget({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    if (!firstPane) {
      secondPaneWidgets = getPane(firstPane: firstPane, tab: tab);
      setChilds(secondPaneWidgets);
      return secondPaneWidgets;
    }
    return getPane(firstPane: firstPane, controler: controler, tab: tab);
  }

  // void _setupPaneTabBar(bool firstPane, {TabControllerHelper? tab}) {
  //   if (firstPane) {
  //     _tabListFirstPane = initTabBarList(firstPane: firstPane, tab: tab);
  //     if (_hasTabBarList(firstPane: firstPane)) {
  //       _tabControllerFirstPane =
  //           TabController(vsync: this, length: _tabListFirstPane!.length);
  //       _tabControllerFirstPane!
  //           .addListener(_tabControllerChangeListenerFirstPane);
  //     }
  //   } else {
  //     _tabListSecondPane = initTabBarList(firstPane: firstPane, tab: tab);
  //     if (_hasTabBarList(firstPane: firstPane)) {
  //       _tabControllerSecondPane =
  //           TabController(vsync: this, length: _tabListSecondPane!.length);

  //       _tabControllerSecondPane!
  //           .addListener(_tabControllerChangeListenerSecondPane);
  //     }
  //   }
  // }

  // Widget getTowPanes({TabControllerHelper? tab, TabControllerHelper? sec}) {
  //   debugPrint("BasePage getTowPanes width=$getWidth ");
  //   if (isMobile(context, maxWidth: getWidth)) {
  //     debugPrint("BasePage getTowPanes isMobile");
  //     _firstWidget = beforeGetPaneWidget(firstPane: true, tab: tab);
  //     _firstWidget = _setSubAppBar(_firstWidget, true)!;
  //     return _firstWidget;
  //   }
  //   _setupPaneTabBar(false, tab: tab);
  //   _setupPaneTabBar(true, tab: tab);
  //   if (isDesktop(context, maxWidth: getWidth)) {
  //     if (_hasTabBarList(firstPane: true)) {
  //       _firstWidget = TabBarView(
  //           controller: _tabControllerFirstPane,
  //           children: _getTabBarList(firstPane: true)!
  //               .map((e) => beforeGetPaneWidget(firstPane: true, tab: e))
  //               .toList()
  //               .cast());
  //     } else {
  //       _firstWidget = beforeGetPaneWidget(firstPane: true, tab: tab);
  //     }

  //     _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);

  //     if (_hasTabBarList(firstPane: false)) {
  //       _secondWidget = TabBarView(
  //           controller: _tabControllerSecondPane,
  //           children: _getTabBarList(firstPane: false)!
  //               .map((e) {
  //                 debugPrint("getPane tab:$tab secondpane $e");
  //                 return beforeGetPaneWidget(
  //                     firstPane: false, tab: tab, secoundTab: e);
  //               })
  //               .toList()
  //               .cast());
  //     } else {
  //       _secondWidget =
  //           beforeGetPaneWidget(firstPane: false, tab: tab, secoundTab: sec);
  //     }
  //     _secondWidget = _setSubAppBar(_secondWidget, false, sec: sec, tab: tab);
  //   } else {
  //     _firstWidget =
  //         beforeGetPaneWidget(firstPane: true, tab: tab, secoundTab: sec);
  //     _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);
  //     if (_buildSecoundPane) {
  //       _secondWidget =
  //           beforeGetPaneWidget(firstPane: false, tab: tab, secoundTab: tab);
  //       _secondWidget = _setSubAppBar(_secondWidget, false, tab: tab, sec: sec);
  //     }
  //   }
  //   if (_secondWidget == null) {
  //     return _firstWidget!;
  //   }

  //   if (_hasHorizontalDividerWhenTowPanes()) {
  //     _firstWidget = _getBorderDecoration(_firstWidget!);
  //   }

  //   return getPaneExt();
  // }
  
  Widget getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _secondWidget,
      customPaneProportion: reverseCustomPane()
          ? 1 - getCustomPaneProportion()
          : getCustomPaneProportion(),
    );
  }

  SizedBox? getEndDrawer() {
    Widget? customEnd = getCustomEndDrawer();
    bool isLarge = isLargeScreenFromScreenSize(getCurrentScreenSize());
    double width = isLarge ? MediaQuery.of(context).size.width * .4 : 500;
    return SizedBox(
      width: width,
      child: Card(child: customEnd ?? const WebShoppingCartDrawer()),
    );
  }

  Map<String, List<DrawerMenuItem>>? getCustomDrawer() {
    return null;
  }

  Widget? _generateCustomDrawer() {
    Map<String, List<DrawerMenuItem>>? drawer = getCustomDrawer();
    return drawer == null
        ? null
        : DrawerLargeScreens(
            customItems: drawer,
            size: findCurrentScreenSize(context),
          );
  }

  List<TabControllerHelper>? getPaneTabControllerHelper({
    required bool firstPane,
  }) {
    return null;
  }

  Widget? getCustomEndDrawer() {
    return null;
  }

  String? getScrollKey({required bool firstPane}) {
    return null;
  }

  bool canBuildDrawer() {
    //this overrides if small screen then set the default drawer
    if (!isLargeScreenFromCurrentScreenSize(context, width: getWidth)) {
      return true;
    }
    return getCustomDrawer() != null || buildDrawer;
  }

  Widget getScaffoldBodyForPane({required bool firstPane}) {
    List<TabControllerHelper>? tabs = getPaneTabControllerHelper(
      firstPane: firstPane,
    );
    if (tabs != null) {
      tabs = [
        TabControllerHelper(AppLocalizations.of(context)!.home, isMain: true),

        ...tabs,
      ];
    }
    return SliverCustomScrollViewDraggable(
      onRefresh: getPaneIsRefreshIndicator(firstPane: firstPane),
      physics: const AlwaysScrollableScrollPhysics(),
      forceHeaderToCollapse: widget.forceHeaderToCollapse,
      scrollKey: getScrollKey(firstPane: firstPane),
      tabs: tabs,
      actions: getAppbarActions(firstPane: firstPane),
      appBarLeading: getAppbarLeading(firstPane: firstPane),
      title: getAppbarTitle(firstPane: firstPane),
      forceBuildAppBar: forceBuildAppBar,
      pinToolbar: pinToolbar,
      slivers: const [],
      builder: (scrollController, tab) {
        return SliverCustomScrollViewDraggableHelper(
          widget: beforeGetPaneWidget(
            firstPane: firstPane,
            tab: tab == null
                ? null
                : tab.isMain
                ? null
                : tab,
            controler: scrollController,
          )!,
          headerWidget: getPaneDraggableHeader(
            firstPane: firstPane,
            tab: tab == null
                ? null
                : tab.isMain
                ? null
                : tab,
          ),
          expandHeaderWidget: getPaneDraggableExpandedHeader(
            firstPane: firstPane,
            tab: tab == null
                ? null
                : tab.isMain
                ? null
                : tab,
          ),
        );
      },
    );
  }

  Widget? getScaffoldForPane({required bool firstPane}) {
    Widget scaffold = Scaffold(
      backgroundColor: isPaneScaffoldOverlayColord(firstPane)
          ? ElevationOverlay.overlayColor(context, 4)
          : firstPane
          ? Theme.of(context).colorScheme.surface
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: getFloatingActionButton(firstPane: firstPane),
      bottomNavigationBar: getBottomNavigationBar(firstPane: firstPane),
      body: Padding(
        padding: setPaneBodyPaddingHorizontal(firstPane)
            ? EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2,
                vertical: setPaneBodyPaddingVertical(firstPane)
                    ? kDefaultPadding / 2
                    : 0,
              )
            : EdgeInsets.zero,
        child: getScaffoldBodyForPane(firstPane: firstPane),
      ),
    );

    if (setClipRect(firstPane)) {
      return Padding(
        padding: EdgeInsets.only(bottom: kDefaultPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kDefualtClipRect),
          child: scaffold,
        ),
      );
    }
    return scaffold;
  }

  Widget _getMainWidget() {
    bool isLarge =
        isDesktop(context, maxWidth: getWidth) ||
        isTablet(context, maxWidth: getWidth);
    bool isCustomDrawer = getCustomDrawer() != null;

    Widget body = Scaffold(
      endDrawer: getEndDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: getFloatingActionButton(firstPane: null, tab: null),
      bottomNavigationBar: getBottomNavigationBar(),
      key: widget.isFirstToSecOrThirdPane
          ? null
          : _drawerMenuControllerProvider.getStartDrawableKey,
      drawer: canBuildDrawer() ? _drawerWidget : null,
      appBar: generateBaseAppbar(),
      body: (isCustomDrawer)
          ? Selector<DrawerMenuControllerProvider, DrawerMenuItem?>(
              builder: (__, v, ___) {
                lastDrawerItemSelected = v;
                return getMainPanIfHasTabBarList();
              },
              selector: (p0, p1) => p1.getLastDrawerMenuItemClicked,
            )
          : getMainPanIfHasTabBarList(),
    );

    if ((isLarge && buildDrawer) || (isLarge && isCustomDrawer)) {
      body = Row(
        children: [
          _drawerWidget!,
          // const VerticalDivider(
          //   width: 1,
          //   thickness: 1,
          // ),
          Expanded(child: body),
        ],
      );
    }

    if (setClipRect(null)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kDefualtClipRect),
        child: body,
      );
    }
    return body;
  }

  Widget getMainPanIfHasTabBarList() {
    if (!_hasTabBarList()) {
      return getMainPanes();
    }
    return TabBarView(
      controller: _tabBaseController,
      children: _getTabBarList().map((e) => getMainPanes(baseTap: e)).toList(),
    );
  }

  Widget getMainPanes({TabControllerHelper? baseTap}) {
    _firstWidget = getScaffoldForPane(firstPane: true);
    _secondWidget = getScaffoldForPane(firstPane: false);
    if (_hasHorizontalDividerWhenTowPanes()) {
      _firstWidget = _getBorderDecoration(_firstWidget!);
    }

    return getPaneExt();
  }

  Widget getSelectorBodyIsLarge(bool isLarge, Widget currentWidget) {
    if (!buildDrawer || !isLarge) {
      return currentWidget;
    }
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        debugPrint("drawer selector $isOpen");
        return AnimatedContainer(
          key: UniqueKey(),
          height: _height,
          width:
              (_width -
                  (isOpen ? kDrawerOpenWidth : kDefaultClosedDrawer)
                      .toNonNullable()) -
              0,
          duration: const Duration(milliseconds: 100),
          child: currentWidget,
        );
      },
      selector: (p0, p1) => p1.getSideMenuIsOpen,
    );
  }

  void _tabControllerChangeListener() {
    currentBaseTabIndex = _tabBaseController!.index;
    debugPrint("_tabController $currentBaseTabIndex");
  }

  void changeTabIndex(int index) {
    debugPrint("_tabController $index");
    if (!_hasTabBarList()) return;
    debugPrint("_tabController $index");
    currentBaseTabIndex = index;
    _tabBaseController!.index = index;
  }
}

enum ConnectionStateExtension {
  /// Not currently connected to any asynchronous computation.
  ///
  /// For example, a [FutureBuilder] whose [FutureBuilder.future] is null.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  ///
  /// For example, a [Stream] that has returned at least one value, but is not
  /// yet done.
  active,

  /// Connected to a terminated asynchronous computation.
  done,

  error;

  ConnectionStateExtension? getFromConnectionState(ConnectionState c) {
    return ConnectionStateExtension.values.firstWhereOrNull(
      (n) => c.name == n.name,
    );
  }
}

extension Connection on ConnectionState {
  ConnectionStateExtension? getFromConnectionState() {
    return ConnectionStateExtension.values.firstWhereOrNull(
      (n) => name == n.name,
    );
  }
}

abstract class BasePageStateWithApi<T extends BasePageApi>
    extends BasePageState<T> {
  final refreshListener = ValueNotifier<bool>(true);

  late ValueNotifier<ConnectionStateExtension> _connectionState;

  int? _iD;
  String? _tableName;
  dynamic _extras;
  dynamic _lastExtras;

  bool _isLoading = false;
  int? get iD => this._iD;
  dynamic get getLastExtras => this._lastExtras;
  String? get getTableName => this._tableName;
  int? get getID => this._iD;

  bool get getIsLoading => this._isLoading;

  ValueNotifier<ConnectionStateExtension> get getConnectionState =>
      _connectionState;

  ConnectionStateExtension? overrideConnectionState(
    BasePageWithApiConnection type,
  ) {
    return null;
  }

  @override
  void initState() {
    _iD = widget.iD;
    _tableName = widget.tableName;
    _extras = widget.extras;
    _extras ??= context.read<AuthProvider<AuthUser>>().getNewInstance(
      _tableName ?? "",
    );
    _connectionState = ValueNotifier(
      overrideConnectionState(BasePageWithApiConnection.init) ??
          ConnectionStateExtension.none,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    _iD = widget.iD;
    _tableName = widget.tableName;
    _extras = widget.extras;

    _extras ??= context.read<AuthProvider<AuthUser>>().getNewInstance(
      _tableName ?? "",
    );
    _connectionState = ValueNotifier(
      overrideConnectionState(BasePageWithApiConnection.didUpdate) ??
          ConnectionStateExtension.none,
    );
    super.didUpdateWidget(oldWidget);
  }

  Future<dynamic>? getOverrideCallApiFunction(
    BuildContext context, {
    TabControllerHelper? tab,
  });
  ServerActions getServerActions();

  dynamic getExtras({TabControllerHelper? tab}) {
    if (_hasTabBarList()) {
      if (tab != null) {
        debugPrint("getExtras _hasTabBarList");
        dynamic result = _getTabBarList().firstWhere(
          (element) => element.extras.runtimeType == tab.extras.runtimeType,
        );
        if (result == null) {
          throw Exception("Could not find tab");
        }
        return result.extras;
      }
      return _getTabBarList()[currentBaseTabIndex].extras;
    }
    debugPrint("getExtras not has ");
    return _extras;
  }

  TabControllerHelper? findExtrasViaTypeList(
    List<TabControllerHelper>? list,
    bool Function(TabControllerHelper) test,
  ) {
    if (list != null) {
      return list.firstWhereOrNull(test);
    } else {
      return _extras;
    }
  }

  int findExtrasIndexFromTabList(
    List<TabControllerHelper>? list,
    bool Function(TabControllerHelper) test,
  ) {
    if (list != null) {
      return list.indexWhere(test);
    } else {
      return -1;
    }
  }

  //todo check return type if not tab bar then return extras ??
  TabControllerHelper? findExtrasViaType(Type extra) {
    if (_hasTabBarList()) {
      return findExtrasViaTypeList(
        _getTabBarList(),
        (e) => e.extras.runtimeType == extra,
      );
    } else {
      return _extras;
    }
  }

  int findExtrasIndexFromTab(Type extra) {
    if (_hasTabBarList()) {
      return findExtrasIndexFromTabList(
        _getTabBarList(),
        (element) => element.extras.runtimeType == extra,
      );
    } else {
      return -1;
    }
  }

  int findExtrasIndexFromTabSecoundPane(Type extra) {
    if (_hasTabBarList()) {
      return findExtrasIndexFromTabList(
        _getTabBarList(),
        (element) => element.extras.runtimeType == extra,
      );
    } else {
      return -1;
    }
  }

  bool isExtrasIsDashboard({TabControllerHelper? tab}) {
    return getExtras(tab: tab) is DashableInterface;
  }

  DashableInterface getExtrasCastDashboard({TabControllerHelper? tab}) {
    return getExtras(tab: tab) as DashableInterface;
  }

  ViewAbstract getExtrasCast({TabControllerHelper? tab}) {
    return getExtras(tab: tab) as ViewAbstract;
  }

  void setExtras({
    int? iD,
    String? tableName,
    dynamic ex,
    TabControllerHelper? tabH,
  }) {
    _isLoading = false;
    if (_hasTabBarList()) {
      TabControllerHelper tab = tabH ?? _getTabBarList()[currentBaseTabIndex];
      tab.extras = ex;
      tab.iD = iD;
      tab.tableName = tableName;
      debugPrint("setExtras _hasTabBarList ${tab.extras} ");
      if (tabH != null) {
        _getTabBarList()[_getTabBarList().indexWhere(
              (element) =>
                  element.extras.runtimeType == tabH.extras.runtimeType,
            )] =
            tab;
      } else {
        _getTabBarList()[currentBaseTabIndex] = tab;
      }
    } else {
      debugPrint("setExtras not has $ex ");
      this._extras = ex;
      this._iD = iD;
      this._tableName = tableName;
    }
  }

  void refresh({
    int? iD,
    String? tableName,
    dynamic extras,
    TabControllerHelper? tab,
  }) {
    debugPrint("refresh basePage $extras");

    setExtras(iD: iD, tableName: tableName, ex: extras, tabH: tab);
    setState(() {});
  }

  // @override
  // generateToolbar({Widget? customAppBar}) {
  //   if (_isLoading) {
  //     return null;
  //   }
  //   return super.generateToolbar(customAppBar: customAppBar);
  // }
  List<SliverFillRemaining> getLoadingWidget(
    bool firstPane, {
    TabControllerHelper? tab,
  }) {
    Widget loading = const Center(child: CircularProgressIndicator());

    return [SliverFillRemaining(child: loading)];
  }

  @override
  beforeGetPaneWidget({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    if (_isLoading) return getLoadingWidget(true, tab: tab);
    var shouldWaitWidget;
    if (isExtrasIsDashboard()) {
      shouldWaitWidget = getExtrasCastDashboard(tab: tab)
          .getDashboardShouldWaitBeforeRequest(
            context,
            //TODO  i cant pass the secound pane helper here
            // basePage: getSecoundPaneHelper(),TODO
            firstPane: firstPane,
            tab: tab,
          );
    }
    return shouldWaitWidget ??
        super.beforeGetPaneWidget(
          firstPane: firstPane,
          controler: controler,
          tab: tab,
        );
  }

  void initStateAfterApiCalled() {}
  @override
  Widget getMainPanes({TabControllerHelper? baseTap}) {
    debugPrint("getBody _getTowPanes TabController ");
    dynamic ex = getExtras(tab: baseTap);
    _isLoading = !getExtrasCast(
      tab: baseTap,
    ).shouldGetFromApi(ServerActions.view, getLastExtras);
    // debugPrint("getBody _isLoading  $_isLoading ");
    if (ex != null && !_isLoading) {
      _connectionState.value =
          overrideConnectionState(BasePageWithApiConnection.build) ??
          ConnectionStateExtension.none;
      initStateAfterApiCalled();
      return super.getMainPanes(baseTap: baseTap);
    }
    return FutureBuilder<dynamic>(
      future:
          getOverrideCallApiFunction(context, tab: baseTap) ??
          getExtrasCast(tab: baseTap).viewCall(
            context: context,
            customID: getID,
            lastObject: getLastExtras,
          ),
      builder: (context, snapshot) {
        _connectionState.value =
            overrideConnectionState(BasePageWithApiConnection.future) ??
            (snapshot.connectionState.getFromConnectionState()) ??
            ConnectionStateExtension.error;

        debugPrint("BasePageApi FutureBuilder started");
        if (snapshot.hasError) {
          debugPrint("BasePageApi FutureBuilder hasError ${snapshot.error}");
          return getErrorWidget();
        } else if (snapshot.connectionState == ConnectionState.done) {
          debugPrint(
            "BasePageApi FutureBuilder done snape data ${snapshot.data.runtimeType}",
          );
          _isLoading = false;
          if (snapshot.data != null) {
            _lastExtras = ex;
            setExtras(ex: snapshot.data);
            initStateAfterApiCalled();
            if (ex is ViewAbstract) {
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //   context.read<ListMultiKeyProvider>().edit(ex);
              // });
            }
            return super.getMainPanes(baseTap: baseTap);
          } else {
            debugPrint("BasePageApi FutureBuilder !done");
            return EmptyWidget.error(
              context,
              onSubtitleClicked: () {
                setState(() {});
              },
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint("BasePageApi FutureBuilder waiting");
          _isLoading = true;
          return super.getMainPanes(baseTap: baseTap);
        } else {
          debugPrint("BasePageApi FutureBuilder !TOTODO");
          return const Text("TOTODO");
        }
      },
    );
  }

  Widget getErrorWidget() {
    _isLoading = false;
    return EmptyWidget(
      lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
      onSubtitleClicked: () {
        setState(() {});
      },
      title: AppLocalizations.of(context)!.cantConnect,
      subtitle: AppLocalizations.of(context)!.cantConnectRetry,
    );
  }
}

enum BasePageWithApiConnection { init, didUpdate, build, future }
