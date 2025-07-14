import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

///is non editable view
abstract class VNonRequestable<T> extends ViewAbstract<T> {
  VNonRequestable() : super();

  @override
  RequestOptions? getRequestOption(
      {required ServerActions action,
      RequestOptions? generatedOptionFromListCall}) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return null;
  }
}
