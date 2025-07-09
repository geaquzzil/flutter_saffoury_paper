import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';

import '../../models/auto_rest.dart';

class ListMultiKeyProvider with ChangeNotifier {
  //TODO dispose this

  // ListMultiKeyProvider list= ListMultiKeyProvider();
  final Map<String, MultiListProviderHelper> _listMap = {};

  int getCount(String key) {
    return _listMap[key]?.getCount ?? 0;
  }

  List<T> getList<T>(String key) {
    return _listMap[key]?.getObjects.cast<T>() ?? [].cast<T>();
  }

  List getListNotViewAbstract(String key) {
    return _listMap[key]?.getObjects ?? [];
  }

  bool isLoading(String key) {
    return _listMap[key]?.isLoading ?? false;
  }

  int getPage(String key) {
    return _listMap[key]?.page ?? 0;
  }

  bool isHasError(String key) {
    debugPrint(
        "ListMultiKeyProvider isHasError key => $key  , hasError ${_listMap[key]?.hasError} object => ${_listMap[key].toString()} ");
    return _listMap[key]?.hasError ?? false;
  }

  void notifyAdd(ViewAbstract viewAbstract, {required BuildContext context}) {
    for (var i in _listMap.entries) {
      if (i.key == viewAbstract.getListableKey()) {
        _listMap.remove(i.key);
        notifyListeners();
        fetchList(i.key, viewAbstract: viewAbstract, context: context);
      }
    }
  }

  Future<void> edit(ViewAbstract obj) async {
    _listMap.entries.forEach((i) async {
      var element = i.value;
      ViewAbstract? o = (element.getObjects.cast<ViewAbstract>())
          .firstWhereOrNull((element) => element.isEquals(obj));
      if (o != null) {
        int idx =
            element.getObjects.indexWhere((element) => element.isEquals(obj));
        element.getObjects[idx] = obj;
        debugPrint("ListMultiKeyProvider changed element ");
        _listMap[i.key]?.page = getPage(i.key);
        // element.objects.insert(0, o);
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
      (element).getObjects.removeWhere((element) => element.isEquals(obj));
    });

    notifyListeners();
  }

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> clear(String key) async {
    MultiListProviderHelper? multiListProviderHelper = _listMap[key];
    multiListProviderHelper?.getObjects.clear();
    multiListProviderHelper?.page = 0;

    notifyListeners();
  }

  ///clear all the objects list and load the other objects list from viewAbstract if not null
  Future<void> recall(String key, ViewAbstract t, ResponseType type,
      {required BuildContext context}) async {
    MultiListProviderHelper? multiListProviderHelper = _listMap[key];
    multiListProviderHelper?.getObjects.clear();
    multiListProviderHelper?.page = 0;
    multiListProviderHelper?.isLoading = false;

    notifyListeners();
    switch (type) {
      case ResponseType.LIST:
        fetchList(key, viewAbstract: t, context: context);
        break;
      case ResponseType.SINGLE:
        fetchView(key, viewAbstract: t, context: context);
        break;
      case ResponseType.NONE_RESPONSE_TYPE:
        break;
    }
  }

  void refresh(String key, ViewAbstract viewAbstract,
      {required BuildContext context}) {
    clear(key);
    fetchList(key, viewAbstract: viewAbstract, context: context);
  }

  Future<void> refreshIndicater(String key, ViewAbstract v,
      {required BuildContext context}) {
    clear(key);
    return fetchList(key, viewAbstract: v, context: context);
  }

  void addCardToRequest(String key, ViewAbstract viewAbstract) {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.hasError = false;
    multiListProviderHelper.setObjects = [
      ...multiListProviderHelper.getObjects,
      (viewAbstract)
    ];
    notifyListeners();
  }

  bool removeItemObjcet<T>(String key, T value) {
    return removeItem(key, (k) => k == value) != null;
  }

  T? removeItem<T>(String key, bool Function(T) test) {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    List<T>? list = multiListProviderHelper.getObjects.cast<T>();
    if (list.isEmpty) return null;

    T? res = list.firstWhereOrNull(test);
    if (res == null) return null;

    if (!list.remove(res)) {
      return null;
    }
    multiListProviderHelper.setObjects = [...list];
    notifyListeners();
    return res;
  }

  void initCustomList(String key, List<ViewAbstract> viewAbstract) {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.isLoading = false;
    multiListProviderHelper.hasError = false;

    multiListProviderHelper.setObjects = List.from(viewAbstract);
    // multiListProviderHelper.page++;
  }

  void addCustomList(String key, List<ViewAbstract> viewAbstract) async {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.isLoading = false;
    multiListProviderHelper.getObjects.addAll(viewAbstract);
    multiListProviderHelper.page++;
    notifyListeners();
  }

  void addCustomSingle(String key, ViewAbstract viewAbstract) async {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.isLoading = false;
    multiListProviderHelper.getObjects.add(viewAbstract);
    multiListProviderHelper.page++;
    notifyListeners();
  }

  MultiListProviderHelper getProviderObjcet(String key) {
    MultiListProviderHelper multiListProviderHelper;
    if (_listMap.containsKey(key)) {
      multiListProviderHelper = _listMap[key]!;
    } else {
      _listMap[key] = MultiListProviderHelper();
      multiListProviderHelper = _listMap[key]!;
    }
    return multiListProviderHelper;
  }

  Future fetchListOfObjectAutoRest(List<AutoRest> list,
      {required BuildContext context}) async {
    return fetchListOfObject(list.map((e) => e.obj).toList(),
        range: 5, context: context);
  }

  Future fetchListOfObject(List<ViewAbstract> list,
      {int? range, required BuildContext context}) async {
    ViewAbstract first = list[0];

    String key = first.getListableKeyWithoutCustomMap();

    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    if (multiListProviderHelper.isLoading) return;
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
          option: RequestOptions(countPerPage: range, page: 0),
          context: context);
      multiListProviderHelper.isLoading = false;

      if (list != null) {
        multiListProviderHelper.getObjects.addAll(list as List<ViewAbstract>);
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

  ///after clear search we should call this function
  void notifyNotSearchable(String key) {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.setObjects = multiListProviderHelper.getObjects;
    notifyListeners();
  }

  void fetchStaticList(String key, List<ViewAbstract> list) {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    multiListProviderHelper.isLoading = false;
    multiListProviderHelper.hasError = false;
    multiListProviderHelper.setObjects = list;
    multiListProviderHelper.isNoMoreItem = true;
    notifyListeners();
  }

  /// we request a query of options okey ?
  /// then we put ids in the request
  Future fetchTicker(String key,
      {AutoRest? autoRest,
      ViewAbstract? viewAbstract,
      AutoRestCustom? customAutoRest,
      int? customCount,
      int? customPage}) async {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> fetchList(String key,
      {AutoRest? autoRest,
      ViewAbstract? viewAbstract,
      AutoRestCustom? customAutoRest,
      RequestOptions? options,
      bool requiresFullFetsh = false,
      required BuildContext context}) async {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    if (multiListProviderHelper.isLoading) return;
    if (multiListProviderHelper.isNoMoreItem) return;
    multiListProviderHelper.hasError = false;
    multiListProviderHelper.isLoading = true;
    notifyListeners();
    try {
      debugPrint("listCall fetchList");

      ViewAbstractApi ob =
          customAutoRest as ViewAbstractApi? ?? viewAbstract as ViewAbstractApi;
      List? list = await ob.listCall(
          option: options?.copyWith(page: multiListProviderHelper.page),
          context: context);

      // if (customAutoRest != null) {
      //   list = await customAutoRest.listCall(
      //       option: RequestOptions(
      //           filterMap: filter ?? {},
      //           countPerPage: customCount,
      //           page: customPage ?? multiListProviderHelper.page),
      //       context: context);
      // } else {
      //   list = await viewAbstract!.listCall(
      //       context: context,
      //       option: RequestOptions(
      //           page: customPage ?? multiListProviderHelper.page,
      //           countPerPage: customCount ?? autoRest?.range,
      //           filterMap: filter ?? {}));
      // }

      multiListProviderHelper.isLoading = false;
      if (requiresFullFetsh) {
        multiListProviderHelper.isNoMoreItem = true;
      } else {
        multiListProviderHelper.isNoMoreItem = list?.isEmpty ?? false;
      }

      if (list != null) {
        multiListProviderHelper.getObjects.addAll(list);
        // multiListProviderHelper.page =
        //     customPage ?? multiListProviderHelper.page + 1;
        multiListProviderHelper.page = multiListProviderHelper.page + 1;
        notifyListeners();
      } else {
        multiListProviderHelper.isLoading = false;
        multiListProviderHelper.hasError = true;
        notifyListeners();
      }
    } on Exception catch (e, s) {
      debugPrint("listCall Exceptionsos $e");
      debugPrint("listCall Exceptionsos $s");
      multiListProviderHelper.isLoading = false;
      multiListProviderHelper.hasError = true;
      notifyListeners();
    }
  }

  Future fetchView(String key,
      {ViewAbstract? viewAbstract,
      AutoRestCustom? customAutoRest,
      required BuildContext context}) async {
    MultiListProviderHelper? multiListProviderHelper = getProviderObjcet(key);
    if (multiListProviderHelper.isLoading) return;

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
      list = await customAutoRest.viewCall(context: context);
    } else {
      list = await viewAbstract!.viewCall(context: context);
    }

    multiListProviderHelper.isLoading = false;
    if (list != null) {
      multiListProviderHelper.getObjects.add(list);
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
  List _objects = [];
  int page = 0;
  List get getObjects => _objects;
  set setObjects(List objects) {
    _objects = objects;
  }

  void addObject(object) {
    _objects.add(object);
  }

  int get getCount => _objects.length;
  MultiListProviderHelper();

  @override
  String toString() {
    return "MultiListProviderHelper => isLoading: $isLoading isFetching: $isFetching isNoMoreItem: $isNoMoreItem hasError:$hasError";
  }
}
