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
  T? getLastFilterableData() {
    return _filterData;
  }

  Future<T?> getServerData(ViewAbstract viewAbstract,
      {required BuildContext context}) async {
    _lastViewAbstract = viewAbstract;
    if (viewAbstract == _lastViewAbstract &&
        _requiredFiltter.isNotEmpty &&
        _filterData != null) {
      debugPrint(
          "setRequiredFilterList called with no process to do viewAbstract == _lastViewAbstract && _requiredFiltter.isNotEmpty _filterData!=null");
      return _filterData;
    }

    debugPrint("setRequiredFilterList called viewCAll");
    _filterData ??= await _filterOb.viewCall(context: context);
    debugPrint("setRequiredFilterList finish ");
    // debugPrint("setRequiredFilterList $_filterData");
    await setRequiredFilterList(viewAbstract);
    return _filterData;
  }

  Future<void> setRequiredFilterList(ViewAbstract viewAbstract) async {
    if (_filterData == null) {
      debugPrint("setRequiredFilterList called with no filter data");
      return;
    }
    if (viewAbstract == _lastViewAbstract && _requiredFiltter.isNotEmpty) {
      debugPrint(
          "setRequiredFilterList called with no process to do viewAbstract == _lastViewAbstract && _requiredFiltter.isNotEmpty");
      return;
    }
    _requiredFiltter.clear();

    List<String> fields = viewAbstract.getFilterableFields();
    List<String> filterFields = _filterData!.getFieldsDeclarations();
    List<String> sharedFields =
        fields.where((element) => filterFields.contains(element)).toList();

    debugPrint("setRequiredFilterList called with sharedFields $sharedFields");

    for (var field in sharedFields) {
      final res = _filterData?.getFieldValue(field);
      if (res != null) {
        _requiredFiltter[
            _lastViewAbstract.getMirrorNewInstanceViewAbstract(field)] = res;
      }
    }
    debugPrint(
        "setRequiredFilterList called with _filterData $_requiredFiltter");
  }
}
