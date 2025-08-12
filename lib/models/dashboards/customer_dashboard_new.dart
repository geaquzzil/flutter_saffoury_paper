import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';

class CustomerDashboardNew extends Dashboard {
  CustomerDashboardNew() : super();

  CustomerDashboardNew.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    this.dateObject = dateObject;
  }

  @override
  String? getTableNameApi() {
    return "customers";
  }

  @override
  List<String>? getCustomAction() {
    return ["dashboard", "$iD"];
  }
}
