import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class WebCategoryGridableInterface<T extends ViewAbstract> {
  T getWebCategoryGridableInterface(BuildContext context);
  String getWebCategoryGridableTitle(BuildContext context);
  String? getWebCategoryGridableDescription(BuildContext context);

  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context);
}
