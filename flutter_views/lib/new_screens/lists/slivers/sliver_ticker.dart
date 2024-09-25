import 'dart:async';

import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';

mixin SliverApiMixinTicker on SliverApiWithStaticMixin {
  int getTickerSecond();

  Timer? _timer;

  void initTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(Duration(seconds: getTickerSecond()), (timer) {
      setState(() {});
    });
  }

  @override
  bool canFetshList() {
    bool res = super.canFetshList();
    if (!res) return false;
    return true;
  }

  @override
  void fetshList({bool notifyNotSearchable = false}) {
    if (!canFetshList()) return;

    super.fetshList();
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
