import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/ext_utils.dart';

class FilterableProvider with ChangeNotifier {
  static const String SORTKEY = "sortByFieldName";
  static const String SORTKEYAD = "sortBy";
  Map<String, FilterableProviderHelper> _list = {};

  Map<String, FilterableProviderHelper> get getList => _list;

  void init(BuildContext context, ViewAbstract selectedViewAbstract,
      {Map<String, FilterableProviderHelper>? savedList}) {
    _list.clear();
    if (savedList != null) {
      _list = savedList;
    } else {
      if (selectedViewAbstract.isSortAvailable()) {
        _list[SORTKEY] = FilterableProviderHelper(
            field: SORTKEY,
            fieldNameApi: selectedViewAbstract.getSortByType().name,
            values: [selectedViewAbstract.getSortByFieldNameApi()],
            mainFieldName:
                selectedViewAbstract.getSortByType().getMainLabelText(context),
            mainValuesName: [
              selectedViewAbstract.getSortByType().getFieldLabelString(
                  context, selectedViewAbstract.getSortByType())
            ],
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

  void clearAll() {
    _list.clear();
    notifyListeners();
  }

  void clear({String? field}) {
    if (field != null) {
      _list.remove(field);
    }
    _list.clear();
  }

  void add(String field, String fieldNameApi, String value,
      String mainValueName, String mainFieldName) {
    if (_list.containsKey(field)) {
      _list[field]?.add(value, mainValueName);
      // return;
    } else {
      _list[field] = FilterableProviderHelper(
          mainFieldName: mainFieldName,
          mainValuesName: [mainValueName],
          field: field,
          fieldNameApi: fieldNameApi,
          values: [value]);
    }
    notifyListeners();
  }

  void addSortBy(BuildContext context, SortByType sort) {
    // _list[SORTKEY] = _list[SORTKEY]?.setKey(sort.name) ??
    //     FilterableProviderHelper(SORTKEY, sort.name, [],
    //         requestTheFirstValueOnly: true);

    _list[SORTKEY] = _list[SORTKEY]?.setKey(sort.name) ??
        FilterableProviderHelper(
            mainFieldName: sort.getMainLabelText(context),
            mainValuesName: [],
            field: SORTKEY,
            fieldNameApi: sort.name,
            requestTheFirstValueOnly: true,
            values: []);
    notifyListeners();
  }

  void addSortFieldName(
      BuildContext context, String value, String mainValueName) {
    // _list[SORTKEY] = _list[SORTKEY]?.setValue(value) ??
    //     FilterableProviderHelper(SORTKEY, SortByType.ASC.name, [value],
    //         requestTheFirstValueOnly: true);

    _list[SORTKEY] = _list[SORTKEY]?.setValue(value, mainValueName) ??
        FilterableProviderHelper(
            mainFieldName: SortByType.ASC.getMainLabelText(context),
            mainValuesName: [mainValueName],
            field: SORTKEY,
            fieldNameApi: SortByType.ASC.name,
            requestTheFirstValueOnly: true,
            values: [value]);
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

  void remove(String field, {String? value, String? mainValueName}) {
    if (value == null) {
      if (_list.containsKey(field)) {
        _list.remove(field);
        notifyListeners();
      }
    } else {
      if (_list.containsKey(field)) {
        _list[field]?.remove(value, mainValueName!);
        notifyListeners();
      }
    }
  }
}

class FilterableProviderHelper {
  String field;
  String fieldNameApi;

  String mainFieldName;
  List<String> mainValuesName = [];
  List<String> values = [];
  //converts the first value on the list to a string and remove the list on request
  bool? requestTheFirstValueOnly;

  FilterableProviderHelper(
      {required this.field,
      required this.fieldNameApi,
      required this.values,
      required this.mainFieldName,
      required this.mainValuesName,
      this.requestTheFirstValueOnly});

  FilterableProviderHelper setKey(String key) {
    fieldNameApi = key;
    return this;
  }

  FilterableProviderHelper setValue(String value, String mainValueName) {
    values.clear();
    values.add(value);
    mainValuesName.clear();
    mainValuesName.add(mainValueName);
    return this;
  }

  int getCount() {
    return values.length;
  }

  void add(String value, String mainValueName) {
    values.add(value);
    mainValuesName.add(mainValueName);
  }

  void remove(String value, String mainValueName) {
    values.remove(value);
    mainValuesName.remove(mainValueName);
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
    return "field:$field , fieldApi: $fieldNameApi ";
  }
}
