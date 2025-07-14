import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

@Deprecated("Use ValueNotifier instead")
class ListScrollProvider with ChangeNotifier {
  ScrollDirection? _scrollDirection;

  ScrollDirection get getScrollDirection =>
      _scrollDirection ?? ScrollDirection.idle;

  set setScrollDirection(ScrollDirection direction) {
    _scrollDirection = direction;
    notifyListeners();
  }

  bool isScrollForward() {
    return getScrollDirection == ScrollDirection.forward;
  }

  bool isScrollBackward() {
    return getScrollDirection == ScrollDirection.reverse;
  }
}
