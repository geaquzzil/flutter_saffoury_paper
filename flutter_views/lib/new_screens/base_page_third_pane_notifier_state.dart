// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';

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
