import 'package:flutter/material.dart';

class LargeScreenPageProvider with ChangeNotifier {
  CurrentPage _currentPage = CurrentPage.list;
  CurrentPage get getCurrentPage => _currentPage;

  void setCurrentPage(CurrentPage currentPage) {
    _currentPage = currentPage;
  }
}

enum CurrentPage { list, notifications, cart, settings }
