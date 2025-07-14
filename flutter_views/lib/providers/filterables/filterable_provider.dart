// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FilterableProvider with ChangeNotifier {
  Map<String, FilterableProviderHelper> _list = {};

  Map<String, FilterableProviderHelper> get getList => _list;
  set setInitialList(value) => _list = value;

  void init(BuildContext context, ViewAbstract selectedViewAbstract,
      {Map<String, FilterableProviderHelper>? savedList}) {
    if (savedList != null) {
      debugPrint("savedList is not emppty $savedList");
      _list = savedList;
    } else {
      _list.clear();
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

  bool isSelected(String field, String value) {
    if (_list.containsKey(field)) {
      return _list[field]?.isSelected(value) ?? false;
    }
    return false;
  }

  int getCount({String? field, bool? requireCountWithSort}) {
    debugPrint("getCount => $field  is ${_list[field]}");
    if (field != null) {
      return _list[field]?.getCount() ?? 0;
    }
    return _list.length;
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

  static Map<String, FilterableProviderHelper> removeStatic(
      Map<String, FilterableProviderHelper> list, String field,
      {String? value, String? mainValueName}) {
    if (value == null) {
      debugPrint(
          "onFilterable  value == null $value contains key ${list.containsKey(field)}");
      if (list.containsKey(field)) {
        list.remove(field);
      }
    } else {
      debugPrint(
          "onFilterable value $value mainValueName $mainValueName contains key ${list.containsKey(field)}");
      if (list.containsKey(field)) {
        list[field]?.remove(value, mainValueName!);
        if (list[field]?.deleteKey() == true) {
          list.remove(field);
        }
      }
    }
    return list;
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

  factory FilterableProviderHelper.fromJson(Map<String, dynamic> data) =>
      FilterableProviderHelper(
          field: data['field'] as String,
          fieldNameApi: data['fieldNameApi'] as String,
          requestTheFirstValueOnly: data['requestTheFirstValueOnly'] as bool?,
          mainFieldName: data['mainFieldName'] as String,
          mainValuesName:
              (data['mainValuesName'] as List<dynamic>).cast<String>(),
          values: (data['values'] as List<dynamic>).cast<String>());
  // ..field = data['field'] as String
  // ..fieldNameApi = data['fieldNameApi'] as String
  // ..requestTheFirstValueOnly = data['requestTheFirstValueOnly'] as bool?
  // ..mainFieldName = data['mainFieldName'] as String
  // ..mainValuesName =
  //     (data['mainValuesName'] as List<dynamic>).cast<String>()
  // ..values = (data['values'] as List<dynamic>).cast<String>();

  Map<String, dynamic> toJson() => {
        'field': field,
        'fieldNameApi': fieldNameApi,
        'requestTheFirstValueOnly': requestTheFirstValueOnly,
        'mainFieldName': mainFieldName,
        'mainValuesName': mainValuesName,
        'values': values
      };

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

  bool deleteKey() {
    debugPrint(
        "onFilterable deleteKey ${values.isEmpty} ${mainFieldName.isEmpty} ");
    return values.isEmpty || mainFieldName.isEmpty;
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
    return toJson().toString();
  }
}
