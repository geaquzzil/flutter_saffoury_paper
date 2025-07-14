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

  @override
  String toString() => 'BetweenRequest(field: $field, fromTo: $fromTo)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'field': field});
    result.addAll({'fromTo': fromTo.map((x) => x.toMap()).toList()});

    return result;
  }

  factory BetweenRequest.fromMap(Map<String, dynamic> map) {
    return BetweenRequest(
      field: map['field'] ?? '',
      fromTo: List<FromToBetweenRequest>.from(
          map['fromTo']?.map((x) => FromToBetweenRequest.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BetweenRequest.fromJson(String source) =>
      BetweenRequest.fromMap(json.decode(source));
}

class FromToBetweenRequest {
  String from;
  String to;
  FromToBetweenRequest({required this.from, required this.to});

  @override
  String toString() => 'FromToBetweenRequest(from: $from, to: $to)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'from': from});
    result.addAll({'to': to});

    return result;
  }

  factory FromToBetweenRequest.fromMap(Map<String, dynamic> map) {
    return FromToBetweenRequest(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FromToBetweenRequest.fromJson(String source) =>
      FromToBetweenRequest.fromMap(json.decode(source));
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

  @override
  String toString() => getKey();
  String getKey() {
    debugPrint("getSelfInstanceWithSimilarOption key $searchByField");
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
    debugPrint("addSearchByField $runtimeType field:$field value=> $value");
    if (value != null) {
      String key = "<$field>";
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

  RequestOptions setBetween(String field, dynamic value) {
    if (value == null) return this;
    String key = ">$field<";
    betweenMap ??= {};
    if (betweenMap?.containsKey(key) ?? false) {
      List<BetweenRequest> list = betweenMap?[key]!;
      list.add(value);
      betweenMap?[key] = list.map((e) => e.toJson()).toList();
    }
    // if (value is List<List<BetweenRequest>>) {
    String jsonString = jsonEncode(value
        .map((innerList) => innerList
            .map((item) => item is BetweenRequest ? item.toMap() : item)
            .toList())
        .toList());

    betweenMap?[key] = jsonString;
    return this;
  }

  RequestOptions addValueBetween(ViewAbstract child, BetweenRequest between) {
    return setBetween(child.getForeignKeyName(), [between]);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (page != null) {
      result.addAll({'page': page});
    }
    if (countPerPage != null) {
      result.addAll({'countPerPage': countPerPage});
    }
    if (countPerPageWhenSearch != null) {
      result.addAll({'countPerPageWhenSearch': countPerPageWhenSearch});
    }
    if (limit != null) {
      result.addAll({'limit': limit});
    }
    if (searchQuery != null) {
      result.addAll({'searchQuery': searchQuery});
    }
    if (date != null) {
      result.addAll({'date': date!.toMap()});
    }
    if (sortBy != null) {
      result.addAll({'sortBy': sortBy!.toMap()});
    }
    if (betweenMap != null) {
      result.addAll({'betweenMap': betweenMap});
    }
    if (searchByField != null) {
      result.addAll({'searchByField': searchByField});
    }
    if (groupBy != null) {
      result.addAll({'groupBy': groupBy});
    }
    if (sumBy != null) {
      result.addAll({'sumBy': sumBy});
    }
    if (filterMap != null) {
      result.addAll({'filterMap': filterMap});
    }
    result.addAll({'requestObjcets': requestObjcets});
    result.addAll({'requestLists': requestLists});

    return result;
  }

  factory RequestOptions.fromMap(Map<String, dynamic> map) {
    return RequestOptions(
      page: map['page']?.toInt(),
      countPerPage: map['countPerPage']?.toInt(),
      countPerPageWhenSearch: map['countPerPageWhenSearch']?.toInt(),
      limit: map['limit']?.toInt(),
      searchQuery: map['searchQuery'],
      date: map['date'] != null ? DateObject.fromMap(map['date']) : null,
      sortBy:
          map['sortBy'] != null ? SortFieldValue.fromMap(map['sortBy']) : null,
      betweenMap: Map<String, dynamic>.from(map['betweenMap']),
      searchByField: Map<String, dynamic>.from(map['searchByField']),
      groupBy: List<String>.from(map['groupBy']),
      sumBy: List<String>.from(map['sumBy']),
      filterMap: Map<String, FilterableProviderHelper>.from(map['filterMap']),
      requestObjcets: map['requestObjcets'],
      requestLists: map['requestLists'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestOptions.fromJson(String source) =>
      RequestOptions.fromMap(json.decode(source));
}
