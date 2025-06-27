import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

class FilterableData<T> extends VObject<T> {
  FilterableData() : super();

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, List<ViewAbstract>> filterableObjects = {};

  @override
  T fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  T getSelfNewInstance() {
    // TODO: implement getSelfNewInstance
    throw UnimplementedError();
  }

  @override
  RequestOptions? getRequestOption({required ServerActions action}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
