import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
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

  //>SizeID<:width:{from:200,to:300},length:{from:800,to:900}
  //>SizeID<:[[{width:{from:200,to:300},length:{from:800,to:900}],[],[]}]
  Map<String, dynamic>? betweenMap;

  // <SizeID>:20
  Map<String, dynamic>? searchByField;
  //#SizeID#
  List<String>? groupBy;
//&quantity&
  List<String>? sumBy;
  Map<String, FilterableProviderHelper>? filterMap;

  dynamic requestObjcets;
  dynamic requestLists;

  RequestOptions(
      {this.betweenMap,
      this.countPerPage = 20,
      this.countPerPageWhenSearch = 20,
      this.date,
      this.filterMap,
      this.groupBy,
      this.limit,
      this.page = 0,
      this.requestLists,
      this.requestObjcets,
      this.searchByField,
      this.searchQuery,
      this.sortBy,
      this.sumBy});

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
      {Map<String, dynamic>? betweenMap,
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
    if (groupBy == null) return {};
    return Map.fromEntries(groupBy!.map(
      (e) => MapEntry('#$e#', "true"),
    ));
  }

  Map<String, String> _getSumBy() {
    if (sumBy == null) return {};
    return Map.fromEntries(sumBy!.map(
      (e) => MapEntry('&$e&', "true"),
    ));
  }

  bool isSearchServerAction() {
    return searchQuery != null;
  }

  ServerActions getServerAction() {
    if (isSearchServerAction()) {
      return ServerActions.search;
    }
    return ServerActions.list;
  }

  dynamic _getIsRequestObjcets() {
    switch (requestObjcets) {
      case List():
        return jsonEncode(requestObjcets);
      case bool():
        return "$requestObjcets";
      default:
        return null;
    }
  }

  dynamic _getIsRequestList() {
    switch (requestLists) {
      case List():
        return jsonEncode(requestLists);
      case bool():
        return "$requestLists";
      default:
        return null;
    }
  }

  Map<String, String> getFilterableMap() {
    if (filterMap?.isEmpty ?? true) return {};
    debugPrint("getFilterableMap=> $filterMap");
    Map<String, String> bodyMap = {};
    filterMap?.forEach((key, value) {
      bodyMap["<${filterMap?[key]!.fieldNameApi}>"] =
          filterMap?[key]!.getValue();
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

  String getKey() {
    return "${getRequestParams()}";
  }

  Map<String, dynamic> getRequestParams() {
    return {
      if (page != null) 'page': "$page",
      if (limit != null) 'limit': "$limit",
      if (countPerPage != null || countPerPageWhenSearch != null)
        'countPerPage': countPerPageWhenSearch != null
            ? "$countPerPageWhenSearch"
            : "$countPerPage",
      if (date != null) 'date': date.toString(),
      if (sortBy != null) ...sortBy!.getMap(),
      if (searchQuery != null) "searchQuery": searchQuery,
      ...getRequestParamsOnlyForings(),
      ..._getGroupBy(),
      ..._getSumBy(),
      if (betweenMap != null) ...betweenMap!,
      if (searchByField != null) ...searchByField!,
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

  RequestOptions addDate(DateObject? date) {
    if (date != null) {
      this.date = date;
    }
    return this;
  }

  ///value should bey array or val of int or string
  RequestOptions addSearchByField(String field, dynamic value) {
    String key = "<$field>";
    if (value != null) {
      searchByField ??= {};
      value = "$value";
      searchByField![key] = value;
    }
    return this;
  }

  RequestOptions addFilterMap(Map<String, String> value) {
    searchByField ??= {};
    searchByField!.addAll(value);
    return this;
  }

  RequestOptions addSortBy(String field, SortByType type) {
    sortBy = SortFieldValue(field: field, type: type);
    return this;
  }

  RequestOptions addSumBy(String? field) {
    if (field == null) return this;

    sumBy ??= [];
    sumBy!.add(field);
    return this;
  }

  RequestOptions addGroupBy(String? field) {
    if (field == null) return this;
    groupBy ??= [];
    groupBy!.add(field);
    return this;
  }

  RequestOptions addBetween(String field, dynamic value) {
    if (value == null) return this;
    String key = ">$field<";
    betweenMap ??= {};
    if (betweenMap?.containsKey(key) ?? false) {
      List<BetweenRequest> list = betweenMap?[key]!;
      list.add(value);
      betweenMap?[key] = list;
    }
    betweenMap?[key] = [value];
    return this;
  }

  RequestOptions addValueBetween(ViewAbstract child, BetweenRequest between) {
    return addBetween(child.getForeignKeyName(), between);
  }
}
