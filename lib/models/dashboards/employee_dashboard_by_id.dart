import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';

class EmployeeDashboardByID extends Dashboard {
  EmployeeDashboardByID() : super();

  EmployeeDashboardByID.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    this.dateObject = dateObject;
  }

  @override
  String? getTableNameApi() {
    return "employees";
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    var op = RequestOptions()
        .addDate(dateObject).addRequestObjcets(true)
        // .addDate(DateObject(from: "2022-10-02", to: "2022-10-03"))
        .setDisablePaging();
    return op;
  }

  @override
  List<String>? getCustomAction() {
    return ["dashboard", "$iD"];
  }
}
