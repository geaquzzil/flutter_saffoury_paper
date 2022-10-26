import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import '../../models/auto_rest.dart';

class ListMultiKeyProvider with ChangeNotifier {
  // ListMultiKeyProvider list= ListMultiKeyProvider();
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

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> recall(String key, ViewAbstract t, ResponseType type) async {
    MultiListProviderHelper? multiListProviderHelper = listMap[key];
    multiListProviderHelper?.objects.clear();

    notifyListeners();
    switch (type) {
      case ResponseType.LIST:
        fetchList(key, t);
        break;
      case ResponseType.SINGLE:
        fetchView(key, t);
        break;
    }
  }

  Future fetchListSearch(
      String key, ViewAbstract viewAbstract, String query) async {
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
    List? list = await viewAbstract.search(
        viewAbstract.getPageItemCount, multiListProviderHelper.page, query);
    multiListProviderHelper.isLoading = false;
    if (list != null) {
      multiListProviderHelper.objects.addAll(list as List<ViewAbstract>);
      multiListProviderHelper.page++;
      notifyListeners();
    }
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

  Future fetchView(String key, ViewAbstract viewAbstract) async {
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
    dynamic list = await viewAbstract.callApi();
    multiListProviderHelper.isLoading = false;
    if (list != null) {
      multiListProviderHelper.objects.add(list);
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
