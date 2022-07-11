import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/test_var.dart';

class ListProvider with ChangeNotifier {
  bool isLoading = false;
  bool isFetching = false;
  // All movies (that will be displayed on the Home screen)
  final List<ViewAbstract> objects = [];
  int page = 0;
  // Retrieve all movies
  List<ViewAbstract> get getObjects => objects;

  int get getCount => objects.length;
  // Adding a movie to the favorites list
  void addToList(ViewAbstract movie) {
    objects.add(movie);
    notifyListeners();
  }

  // Removing a movie from the favorites list
  void removeFromList(ViewAbstract movie) {
    objects.remove(movie);
    notifyListeners();
  }

  Future fetchFakeList(ViewAbstract viewAbstract) async {
    debugPrint(
        "fetching list of objects from view $viewAbstract page is $page");
    isLoading = true;
    List? list = await viewAbstract.listCallFake();
    isLoading = false;
    objects.addAll(list as List<ViewAbstract>);
    page++;
    notifyListeners();
  }

  //TODO on publish use this method
  Future fetchList(ViewAbstract viewAbstract) async {
    if (isLoading) return;
    isLoading = true;
    List? list =
        await viewAbstract.listCall(viewAbstract.getPageItemCount, page);
    isLoading = false;
    if (list != null) {
      objects.addAll(list as List<ViewAbstract>);
      page++;
      notifyListeners();
    }
  }
}
