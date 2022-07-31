import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/v_non_view_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FilterableData<T> extends VObject<T> {
  FilterableData() : super();

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
}
