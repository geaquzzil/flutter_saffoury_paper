import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import '../../models/auto_rest.dart';

class ListMultiKeyProvider with ChangeNotifier {
  // ListMultiKeyProvider list= ListMultiKeyProvider();
  Map<String, MultiListProviderHelper> _listMap = {};

  int getCount(String key) {
    return _listMap[key]?.getCount ?? 0;
  }

  List<ViewAbstract> getList(String key) {
    return _listMap[key]?.getObjects ?? [];
  }

  bool isLoading(String key) {
    return _listMap[key]?.isLoading ?? false;
  }

  int getPage(String key) {
    return _listMap[key]?.page ?? 0;
  }

  bool isHasError(String key) {
    return _listMap[key]?.hasError ?? false;
  }

  void notifyAdd(ViewAbstract viewAbstract) {
    _listMap.entries.forEach((i) {
      if (i.key == viewAbstract.getListableKey()) {
        _listMap.remove(i.key);
        notifyListeners();
        fetchList(i.key, viewAbstract: viewAbstract);
      }
    });
  }

  Future<void> edit(ViewAbstract obj) async {
    _listMap.entries.forEach((i) async {
      var element = i.value;
      ViewAbstract? o =
          element.objects.firstWhereOrNull((element) => element.isEquals(obj));
      if (o != null) {
        int idx =
            element.objects.indexWhere((element) => element.isEquals(obj));
        element.objects[idx] = obj;
        debugPrint("ListMultiKeyProvider changed element ");
        _listMap[i.key]?.page = getPage(i.key);
        // element.objects.insert(0, o);
        debugPrint(
            "ListMultiKeyProvider changed element required list=> ${o.isRequiredObjectsListChecker()} ");
        _listMap[i.key]?.isLoading = true;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 500), () {
          _listMap[i.key]?.isLoading = false;
          notifyListeners();
// Here you can write your code
        });

        return;
      }
    });
  }

  Future<void> delete(ViewAbstract obj) async {
    await Future.forEach(_listMap.values, (element) {
      (element as MultiListProviderHelper)
          .objects
          .removeWhere((element) => element.isEquals(obj));
    });

    notifyListeners();
  }

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> clear(String key) async {
    MultiListProviderHelper? multiListProviderHelper = _listMap[key];
    multiListProviderHelper?.objects.clear();

    notifyListeners();
  }

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> recall(String key, ViewAbstract t, ResponseType type) async {
    MultiListProviderHelper? multiListProviderHelper = _listMap[key];
    multiListProviderHelper?.objects.clear();
    multiListProviderHelper?.page = 0;
    multiListProviderHelper?.isLoading = false;

    notifyListeners();
    switch (type) {
      case ResponseType.LIST:
        fetchList(key, viewAbstract: t);
        break;
      case ResponseType.SINGLE:
        fetchView(key, viewAbstract: t);
        break;
      case ResponseType.NONE_RESPONSE_TYPE:
        break;
    }
  }

  void refresh(String key, ViewAbstract viewAbstract) {
    clear(key);
    fetchList(key, viewAbstract: viewAbstract);
  }

  Future fetchListSearch(
      String key, ViewAbstract viewAbstract, String query) async {
    late MultiListProviderHelper? multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key];
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key];
    }
    if (multiListProviderHelper!.isLoading) return;
    if (multiListProviderHelper.isNoMoreItem) return;
    multiListProviderHelper.isLoading = true;
    notifyListeners();
    // await Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () {
    //     notifyListeners();
    //   },
    // );
    List? list = await viewAbstract.search(viewAbstract.getPageItemCountSearch,
        multiListProviderHelper.page, query);
    multiListProviderHelper.isLoading = false;
    multiListProviderHelper.objects.addAll(list as List<ViewAbstract>);
    multiListProviderHelper.page++;
    notifyListeners();
  }

  void addCustomList(String key, List<ViewAbstract> viewAbstract) async {
    late MultiListProviderHelper? multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key];
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key];
    }
    multiListProviderHelper!.isLoading = false;
    multiListProviderHelper.objects.addAll(viewAbstract);
    multiListProviderHelper.page++;
    notifyListeners();
  }

  void addCustomSingle(String key, ViewAbstract viewAbstract) async {
    late MultiListProviderHelper? multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key];
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key];
    }
    multiListProviderHelper!.isLoading = false;
    multiListProviderHelper.objects.add(viewAbstract);
    multiListProviderHelper.page++;
    notifyListeners();
  }

  Future fetchListOfObjectAutoRest(List<AutoRest> list) async {
    return fetchListOfObject(list.map((e) => e.obj).toList(), range: 5);
  }

  Future fetchListOfObject(List<ViewAbstract> list, {int? range}) async {
    ViewAbstract first = list[0];

    String key = first.getListableKeyWithoutCustomMap();

    late MultiListProviderHelper? multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key];
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key];
    }
    if (multiListProviderHelper!.isLoading) return;
    int page = getPage(key);
    multiListProviderHelper.isNoMoreItem = page > list.length - 1;
    if (multiListProviderHelper.isNoMoreItem) return;
    multiListProviderHelper.hasError = false;
    multiListProviderHelper.isLoading = true;
    ViewAbstract viewAbstract = list[page];
    notifyListeners();
    // await Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () {
    //     notifyListeners();
    //   },
    // );

    try {
      List? list = await viewAbstract.listCall(
          count: range ?? viewAbstract.getPageItemCount, page: 0);
      multiListProviderHelper.isLoading = false;

      if (list != null) {
        multiListProviderHelper.objects.addAll(list as List<ViewAbstract>);
        multiListProviderHelper.page = multiListProviderHelper.page + 1;
        notifyListeners();
      } else {
        multiListProviderHelper.isLoading = false;
        multiListProviderHelper.hasError = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Exception $e");
      multiListProviderHelper.isLoading = false;
      multiListProviderHelper.hasError = true;
      notifyListeners();
    }
  }

  Future fetchList(String key,
      {AutoRest? autoRest,
      ViewAbstract? viewAbstract,
      AutoRestCustom? customAutoRest,
      int? customCount,
      int? customPage}) async {
    MultiListProviderHelper multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key]!;
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key]!;
    }
    if (multiListProviderHelper.isLoading) return;
    if (multiListProviderHelper.isNoMoreItem) return;
    multiListProviderHelper.hasError = false;
    multiListProviderHelper.isLoading = true;
    notifyListeners();
    // await Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () {
    //     notifyListeners();
    //   },
    // );

    try {
      List? list;
      if (customAutoRest != null) {
        debugPrint("errrrrrrr s");
        list = await customAutoRest.listCall(
            count: customCount ?? customAutoRest.getPageItemCount,
            page: customPage ?? multiListProviderHelper.page);
      } else {
        list = await viewAbstract!.listCall(
            count:
                customCount ?? autoRest?.range ?? viewAbstract.getPageItemCount,
            page: customPage ?? multiListProviderHelper.page);
      }

      multiListProviderHelper.isLoading = false;
      multiListProviderHelper.isNoMoreItem = list?.isEmpty ?? false;
      if (list != null) {
        multiListProviderHelper.objects.addAll(list as List<ViewAbstract>);
        multiListProviderHelper.page =
            customPage ?? multiListProviderHelper.page + 1;
        notifyListeners();
      } else {
        multiListProviderHelper.isLoading = false;
        multiListProviderHelper.hasError = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Exceptionsos $e");
      multiListProviderHelper.isLoading = false;
      multiListProviderHelper.hasError = true;
      notifyListeners();
    }
  }

  Future fetchView(String key,
      {ViewAbstract? viewAbstract, AutoRestCustom? customAutoRest}) async {
    late MultiListProviderHelper? multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key];
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key];
    }
    if (multiListProviderHelper!.isLoading) return;

    multiListProviderHelper.isLoading = true;
    notifyListeners();
    // await Future.delayed(
    //   const Duration(milliseconds: 200),
    //   () {
    //     notifyListeners();
    //   },
    // );
    dynamic list;
    if (customAutoRest != null) {
      list = await customAutoRest.callApi();
    } else {
      list = await viewAbstract!.callApi();
    }

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
  bool isNoMoreItem = false;
  bool hasError = false;
  // All movies (that will be displayed on the Home screen)
  final List<ViewAbstract> objects = [];
  int page = 0;
  // Retrieve all movies
  List<ViewAbstract> get getObjects => objects;

  int get getCount => objects.length;
  MultiListProviderHelper();
}
