import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FilterableProvider with ChangeNotifier {
  Map<String, FilterableProviderHelper> _list = {};



  

  void init(ViewAbstract selectedViewAbstract,
      {Map<String, FilterableProviderHelper>? savedList}) {
    _list.clear();
    if (savedList != null) {
      _list = savedList;
    } else {
      if (selectedViewAbstract.isSortAvailable()) {
        _list["sortByFieldName"] = FilterableProviderHelper(
            "sortByFieldName",
            selectedViewAbstract.getSortByType().name,
            [selectedViewAbstract.getSortByFieldNameApi()],
            requestTheFirstValueOnly: true);

      }
    }
    notifyListeners();
  }

  void clear() {
    _list.clear();
  }

  void add(String field, String fieldNameApi, String value) {
    if (_list.containsKey(field)) {
      _list[field]?.add(value);
      return;
    }
    _list[field] = FilterableProviderHelper(field, fieldNameApi, [value]);
    notifyListeners();
  }

  bool isSelected(String field, String value) {
    if (_list.containsKey(field)) {
      return _list[field]?.isSelected(value) ?? false;
    }
    return false;
  }

  void remove(String field) {
    _list.remove(field);
    notifyListeners();
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

  void add(String value) {
    values.add(value);
  }

  void remove(String value) {
    values.remove(value);
  }

  bool isSelected(String value) {
    return values.firstWhereOrNull((v) => v == value) != null;
  }
}
