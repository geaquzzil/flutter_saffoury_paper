import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class VOtherObjectRequest<T, E extends ViewAbstract>
    extends ViewAbstract<T> {
  E getResponseObject();
}

mixin VOtherObjectRequestList<T, E extends ViewAbstract>
    on VOtherObjectRequest<T, E> {
  Future<List<E>?> callApiE({
    required BuildContext context,
    OnResponseCallback? onResponse,
  }) {
    return getResponseObject().listCall<E>(
        context: context,
        option: getRequestOption(action: ServerActions.list),
        onResponse: onResponse);
  }
}

mixin VOtherObjectRequestSingle<T, E extends ViewAbstract>
    on VOtherObjectRequest<T, E> {
  Future<E?> callApiE({
    required BuildContext context,
    OnResponseCallback? onResponse,
  }) {
    return getResponseObject()
        .viewCall<E>(context: context, onResponse: onResponse);
  }
}
