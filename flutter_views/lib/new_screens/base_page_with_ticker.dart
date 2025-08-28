// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

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