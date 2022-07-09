import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class EditSubsViewAbstractControllerProvider with ChangeNotifier {
  Map<String, ViewAbstractNullableController> _list = {};

  Map<String, ViewAbstractNullableController> get getList => _list;
  ViewAbstract? getViewAbstract(String field) {
    return _list[field]?.viewAbstract;
  }

  ViewAbstractNullableController? getViewAbstractNullableController(
      String field) {
    return _list[field];
  }

  bool getIsNullable(String field) {
    ViewAbstractNullableController? viewAbstract =
        getViewAbstractNullableController(field);
    return viewAbstract?.isNullableAlreadyFromParent ?? false;
  }

  void add(String field, ViewAbstract viewAbstract,
      bool isNullableAlreadyFromParent) {
    _list[field] = ViewAbstractNullableController(
        viewAbstract: viewAbstract,
        isNullableAlreadyFromParent: isNullableAlreadyFromParent);
  }

  void toggleIsNullable(String field) {
    ViewAbstractNullableController? viewAbstractNullableController =
        _list[field];
    if (viewAbstractNullableController != null) {
      viewAbstractNullableController.isNullableAlreadyFromParent =
          !viewAbstractNullableController.isNullableAlreadyFromParent;
      notifyListeners();
    }
  }

  void changeIsNullable(String field, bool isNullable) {
    ViewAbstractNullableController? viewAbstractNullableController =
        _list[field];
    if (viewAbstractNullableController != null) {
      viewAbstractNullableController.isNullableAlreadyFromParent = isNullable;
      notifyListeners();
    }
  }

  void clear() {
    _list.clear();
  }
}

class ViewAbstractNullableController {
  ViewAbstract viewAbstract;
  bool isNullableAlreadyFromParent;
  ViewAbstractNullableController(
      {required this.viewAbstract, required this.isNullableAlreadyFromParent});
}
