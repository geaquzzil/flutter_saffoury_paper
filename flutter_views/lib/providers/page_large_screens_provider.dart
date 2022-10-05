import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:provider/provider.dart';

class LargeScreenPageProvider with ChangeNotifier {
  CurrentPage _currentPage = CurrentPage.list;
  CurrentPage get getCurrentPage => _currentPage;
  String getCurrentPageTitle(BuildContext context) {
    switch (_currentPage) {
      case CurrentPage.cart:
        return "Shopping cart";
      case CurrentPage.list:
      default:
        return "${context.watch<DrawerViewAbstractProvider>().getTitle(context)}";
    }
    return "";
  }

  void setCurrentPage(CurrentPage currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }
}

enum CurrentPage { list, notifications, cart, settings,dashboard }
