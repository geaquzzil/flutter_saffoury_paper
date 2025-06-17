import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';

class BetweenRequest {
  String field;
  List<FromToBetweenRequest> fromTo;
  BetweenRequest({required this.field, required this.fromTo});
}

class FromToBetweenRequest {
  String from;
  String to;
  FromToBetweenRequest({required this.from, required this.to});
}

class RequestOptions {
  int? page;
  int? countPerPage;
  int? countPerPageWhenSearch;
  int? limit;

  String? searchQuery;

  DateObject? date;
  SortFieldValue? sortBy;

  //>SizeID<:width:{from:200,to:300}
  Map<String, List<BetweenRequest>> betweenMap = {};

  // <SizeID>:20
  Map<String, dynamic> searchByField = {};
  //#SizeID#
  List<String> groupBy = [];
//&quantity&
  List<String> sumBy = [];
  Map<String, FilterableProviderHelper> filterMap = {};

  dynamic requestObjcets;
  dynamic requestLists;

  RequestOptions(
      {this.betweenMap = const {},
      this.countPerPage,
      this.countPerPageWhenSearch,
      this.date,
      this.filterMap = const {},
      this.groupBy = const [],
      this.limit,
      this.page,
      this.requestLists,
      this.requestObjcets,
      this.searchByField = const {},
      this.searchQuery,
      this.sortBy,
      this.sumBy = const []});

  RequestOptions copyWithObjcet({RequestOptions? option}) {
    return copyWith(
        betweenMap: option?.betweenMap,
        countPerPage: option?.countPerPage,
        countPerPageWhenSearch: option?.countPerPageWhenSearch,
        date: option?.date,
        filterMap: option?.filterMap,
        groupBy: option?.groupBy,
        limit: option?.limit,
        page: option?.page,
        requestLists: option?.requestLists,
        requestObjcets: option?.requestObjcets,
        searchByField: option?.searchByField,
        searchQuery: option?.searchQuery,
        sortBy: option?.sortBy,
        sumBy: option?.sumBy);
  }

  RequestOptions copyWith(
      {Map<String, List<BetweenRequest>>? betweenMap,
      int? countPerPage,
      int? countPerPageWhenSearch,
      DateObject? date,
      Map<String, FilterableProviderHelper>? filterMap,
      List<String>? groupBy,
      int? limit,
      int? page,
      dynamic requestLists,
      dynamic requestObjcets,
      Map<String, dynamic>? searchByField,
      String? searchQuery,
      SortFieldValue? sortBy,
      List<String>? sumBy}) {
    return RequestOptions(
        betweenMap: betweenMap ?? this.betweenMap,
        countPerPage: countPerPage ?? this.countPerPage,
        countPerPageWhenSearch:
            countPerPageWhenSearch ?? this.countPerPageWhenSearch,
        date: date ?? this.date,
        filterMap: filterMap ?? this.filterMap,
        groupBy: groupBy ?? this.groupBy,
        limit: limit ?? this.limit,
        page: page ?? this.page,
        requestLists: requestLists ?? this.requestLists,
        requestObjcets: requestObjcets ?? this.requestObjcets,
        searchByField: searchByField ?? this.searchByField,
        searchQuery: searchQuery ?? this.searchQuery,
        sortBy: sortBy ?? this.sortBy,
        sumBy: sumBy ?? this.sumBy);
  }

  Map<String, String> _getGroupBy() {
    return Map.fromEntries(groupBy.map(
      (e) => MapEntry('#$e#', "true"),
    ));
  }

  Map<String, String> _getSumBy() {
    return Map.fromEntries(sumBy.map(
      (e) => MapEntry('&$e&', "true"),
    ));
  }

  dynamic _getIsRequestObjcets() {
    switch (requestObjcets) {
      case List():
        return jsonEncode(requestObjcets);
      case bool():
        return requestObjcets;
      default:
        return null;
    }
  }

  dynamic _getIsRequestList() {
    switch (requestLists) {
      case List():
        return jsonEncode(requestLists);
      case bool():
        return requestLists;
      default:
        return null;
    }
  }

  Map<String, String> getFilterableMap() {
    if (filterMap.isEmpty) return {};
    debugPrint("getFilterableMap=> $filterMap");
    Map<String, String> bodyMap = {};
    filterMap.forEach((key, value) {
      bodyMap["<${filterMap[key]!.fieldNameApi}>"] = filterMap[key]!.getValue();
    });
    debugPrint("getFilterableMap bodyMap $bodyMap");
    return bodyMap;
  }

  Map<String, dynamic> getRequestParamsOnlyForings() {
    var list = _getIsRequestList();
    var objects = _getIsRequestObjcets();
    return {
      if (list != null) "forginList": list,
      if (objects != null) "forginObject": objects,
    };
  }

  Map<String, dynamic> getRequestParams() {
    return {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (countPerPage != null || countPerPageWhenSearch != null)
        'countPerPage': countPerPageWhenSearch ?? countPerPage,
      if (date != null) 'date': date.toString(),
      if (sortBy != null) ...sortBy!.getMap(),
      if (searchQuery != null) "searchQuery": searchQuery,
      ...getRequestParamsOnlyForings(),
      ..._getGroupBy(),
      ..._getSumBy(),
      ...betweenMap,
      ...searchByField,
      ...getFilterableMap()
    };
  }

  RequestOptions setPageAndCount(int page, {int? customCountPerPage}) {
    return copyWith(page: page, countPerPageWhenSearch: customCountPerPage);
  }

  RequestOptions addRequestObjcets(dynamic value) {
    requestObjcets = value;
    return this;
  }

  RequestOptions addRequestList(dynamic value) {
    requestLists = value;
    return this;
  }

  RequestOptions addDate(DateObject date) {
    this.date = date;
    return this;
  }

  ///value should bey array or val of int or string
  RequestOptions addSearchByField(String field, dynamic value) {
    String key = "<$field>";
    searchByField[key] = value;
    return this;
  }

  RequestOptions addFilterMap(Map<String, String> value) {
    searchByField.addAll(value);
    return this;
  }

  RequestOptions addSortBy(String field, SortByType type) {
    return this;
  }

  RequestOptions addSumBy(String field) {
    sumBy.add(field);
    return this;
  }

  RequestOptions addGroupBy(String field) {
    groupBy.add(field);
    return this;
  }

  RequestOptions addValueBetween(ViewAbstract child, BetweenRequest between) {
    String forignID = child.getForeignKeyName();
    String key = ">$forignID<";
    if (betweenMap.containsKey(key)) {
      List<BetweenRequest> list = betweenMap[key]!;
      list.add(between);
      betweenMap[key] = list;
    }
    betweenMap[key] = [between];
    return this;
  }
}
