// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'package:flutter/material.dart';

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
