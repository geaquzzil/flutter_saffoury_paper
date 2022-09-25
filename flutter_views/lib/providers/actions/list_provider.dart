import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

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

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> clear({ViewAbstract? viewAbstract}) async {
    objects.clear();
    if (viewAbstract != null) {
      debugPrint("clearing list and change viewAbstract to ${viewAbstract}");
      await fetchList(viewAbstract);
    } else {
      debugPrint("clearing list only");
      notifyListeners();
    }
  }

  // Removing a movie from the favorites list
  void removeFromList(ViewAbstract movie) {
    objects.remove(movie);
    notifyListeners();
  }

  Future fetchFakeList(ViewAbstract viewAbstract) async {
    try {
      isLoading = true;
      List? list = await viewAbstract.listCallFake();
      isLoading = false;
      objects.addAll(list as List<ViewAbstract>);
      page++;
      notifyListeners();
    } catch (e) {
      debugPrint("fetchFakeList ${e.toString()}");
    }
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
