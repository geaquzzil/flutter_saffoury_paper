import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListMultiKeyProvider with ChangeNotifier {
  Map<String, MultiListProviderHelper> listMap = {};

  int getCount(String key) {
    return listMap[key]?.getCount ?? 0;
  }

  List<ViewAbstract> getList(String key) {
    return listMap[key]?.getObjects ?? [];
  }

  bool isLoading(String key) {
    return listMap[key]?.isLoading ?? false;
  }

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> clear(String key) async {
    MultiListProviderHelper? multiListProviderHelper = listMap[key];
    multiListProviderHelper?.objects.clear();
    notifyListeners();
  }

  Future fetchList(String key, ViewAbstract viewAbstract) async {
    late MultiListProviderHelper? multiListProviderHelper;
    if (listMap.containsKey(key)) {
      multiListProviderHelper = listMap[key];
    } else {
      listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = listMap[key];
    }
    if (multiListProviderHelper!.isLoading) return;
    multiListProviderHelper.isLoading = true;
    notifyListeners();
    List? list = await viewAbstract.listCall(
        viewAbstract.getPageItemCount, multiListProviderHelper.page);
    multiListProviderHelper.isLoading = false;
    if (list != null) {
      multiListProviderHelper.objects.addAll(list as List<ViewAbstract>);
      multiListProviderHelper.page++;
      notifyListeners();
    }
  }
}

class MultiListProviderHelper {
  bool isLoading = false;
  bool isFetching = false;
  // All movies (that will be displayed on the Home screen)
  final List<ViewAbstract> objects = [];
  int page = 0;
  // Retrieve all movies
  List<ViewAbstract> get getObjects => objects;

  int get getCount => objects.length;
  MultiListProviderHelper();
}
