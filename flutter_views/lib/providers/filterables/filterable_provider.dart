import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

class FilterableProvider with ChangeNotifier {
  static const String SORTKEY = "sortByFieldName";
  Map<String, FilterableProviderHelper> _list = {};

  Map<String, FilterableProviderHelper> get getList => _list;

  void init(ViewAbstract selectedViewAbstract,
      {Map<String, FilterableProviderHelper>? savedList}) {
    _list.clear();
    if (savedList != null) {
      _list = savedList;
    } else {
      if (selectedViewAbstract.isSortAvailable()) {
        _list[SORTKEY] = FilterableProviderHelper(
            SORTKEY,
            selectedViewAbstract.getSortByType().name,
            [selectedViewAbstract.getSortByFieldNameApi()],
            requestTheFirstValueOnly: true);
      }
    }
    notifyListeners();
  }

  Map getFilterableMapApi() {
    Map<String, dynamic> map = <String, dynamic>{};
    for (var entry in _list.entries) {
      {
        map[entry.value.getKey()] = entry.value.getValue();
      }
    }
    return map;
  }

  void clear({String? field}) {
    if (field != null) {
      _list.remove(field);
    }
    _list.clear();
  }

  void add(String field, String fieldNameApi, String value) {
    if (_list.containsKey(field)) {
      _list[field]?.add(value);
      // return;
    } else {
      _list[field] = FilterableProviderHelper(field, fieldNameApi, [value]);
    }
    notifyListeners();
  }

  void addSortBy(SortByType sort) {
    _list[SORTKEY] = _list[SORTKEY]?.setKey(sort.name) ??
        FilterableProviderHelper(SORTKEY, sort.name, [],
            requestTheFirstValueOnly: true);
    notifyListeners();
  }

  void addSortFieldName(String value) {
    _list[SORTKEY] = _list[SORTKEY]?.setValue(value) ??
        FilterableProviderHelper(SORTKEY, SortByType.ASC.name, [value],
            requestTheFirstValueOnly: true);
    notifyListeners();
  }

  bool isSelected(String field, String value) {
    if (_list.containsKey(field)) {
      return _list[field]?.isSelected(value) ?? false;
    }
    return false;
  }

  int getCount(String field) {
    debugPrint("getCount => $field  is ${_list[field]}");
    return _list[field]?.getCount() ?? 0;
  }

  void remove(String field, {String? value}) {
    if (value == null) {
      if (_list.containsKey(field)) {
        _list.remove(field);
        notifyListeners();
      }
    } else {
      if (_list.containsKey(field)) {
        _list[field]?.remove(value);
        notifyListeners();
      }
    }
  }
}

class FilterableProviderHelper {
  String field;
  String fieldNameApi;
  List<String> values = [];
  //converts the first value on the list to a string and remove the list on request
  bool? requestTheFirstValueOnly;
  FilterableProviderHelper(this.field, this.fieldNameApi, this.values,
      {this.requestTheFirstValueOnly});

  FilterableProviderHelper setKey(String key) {
    fieldNameApi = key;
    return this;
  }

  FilterableProviderHelper setValue(String value) {
    values.clear();
    values.add(value);
    return this;
  }

  int getCount() {
    return values.length;
  }

  void add(String value) {
    values.add(value);
  }

  void remove(String value) {
    values.remove(value);
  }

  String getKey() {
    return fieldNameApi;
  }

  dynamic getValue() {
    bool reqFirstValue = requestTheFirstValueOnly ?? false;
    return reqFirstValue ? values[0] : jsonEncode(values);
  }

  bool isSelected(String value) {
    return values.firstWhereOrNull((v) => v == value) != null;
  }

  @override
  String toString() {
    return values.toString();
  }
}
