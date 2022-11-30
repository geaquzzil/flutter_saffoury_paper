import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FilterableListApiProvider<T extends FilterableData> with ChangeNotifier {
  T? _filterData;
  late T _filterOb;
  final Map<ViewAbstract, List<dynamic>> _requiredFiltter = {};

  Map<ViewAbstract, List<dynamic>> get getRequiredFiltter => _requiredFiltter;
  late ViewAbstract _lastViewAbstract;

  FilterableListApiProvider.initialize(T filterOb) {
    _filterOb = filterOb;
  }
  Future<T?> getServerData(ViewAbstract viewAbstract) async {
    _lastViewAbstract = viewAbstract;
    _filterData ??= await _filterOb.viewCall(0);
    await setRequiredFilterList(viewAbstract);
    return _filterData;
  }

  Future<void> setRequiredFilterList(ViewAbstract viewAbstract) async {
    if (_filterData == null) {
      debugPrint("setRequiredFilterList called with no filter data");
      return;
    }
    _requiredFiltter.clear();

    List<String> fields = viewAbstract.getFilterableFields();
    List<String> filterFields = _filterData!.getFieldsDeclarations();
    List<String> sharedFields =
        fields.where((element) => filterFields.contains(element)).toList();

    debugPrint("setRequiredFilterList called with sharedFields $sharedFields");

    for (var field in sharedFields) {
      _requiredFiltter[
              _lastViewAbstract.getMirrorNewInstanceViewAbstract(field)] =
          _filterData?.getFieldValue(field);
    }
    debugPrint(
        "setRequiredFilterList called with _filterData $_requiredFiltter");
  }
}
