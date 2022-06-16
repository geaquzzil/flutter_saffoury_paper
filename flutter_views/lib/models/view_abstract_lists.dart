import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';

abstract class ViewAbstractLists<T> extends ViewAbstractInputAndValidater<T> {
  List<Widget>? getPopupActionsList(BuildContext context) => null;
}
