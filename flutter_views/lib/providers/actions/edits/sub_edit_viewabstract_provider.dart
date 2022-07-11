import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class EditSubsViewAbstractControllerProvider with ChangeNotifier {
  final Map<String, ViewAbstractNullableController> _list = {};

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

  bool getIsNew(String field) {
    ViewAbstractNullableController? viewAbstract =
        getViewAbstractNullableController(field);
    return viewAbstract?.isNew ?? false;
  }

  void change(String field, ViewAbstract viewAbstract,
      bool isNullableAlreadyFromParent) {
    _list[field] = ViewAbstractNullableController(
        viewAbstract: viewAbstract,
        isNullableAlreadyFromParent: isNullableAlreadyFromParent,
        isNew: viewAbstract.isNew());
    notifyListeners();
  }

  void add(String field, ViewAbstract viewAbstract,
      bool isNullableAlreadyFromParent) {
    _list[field] = ViewAbstractNullableController(
        viewAbstract: viewAbstract,
        isNullableAlreadyFromParent: isNullableAlreadyFromParent,
        isNew: viewAbstract.isNew());
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

  void toggleIsNew(String field, ViewAbstract newViewAbstract) {
    ViewAbstractNullableController? viewAbstractNullableController =
        getViewAbstractNullableController(field);

    bool isNullableAlreadyFromParent =
        viewAbstractNullableController?.isNullableAlreadyFromParent ?? false;

    _list[field] = ViewAbstractNullableController(
        viewAbstract: newViewAbstract,
        isNullableAlreadyFromParent: isNullableAlreadyFromParent,
        isNew: newViewAbstract.isNew());

    notifyListeners();
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
  bool isNew;
  ViewAbstractNullableController(
      {required this.viewAbstract,
      required this.isNullableAlreadyFromParent,
      required this.isNew});
}
