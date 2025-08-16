import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/dashboard.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/size_config.dart';

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
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    var op = RequestOptions()
        .addDate(dateObject)
        .addRequestObjcets(true)
        // .addDate(DateObject(from: "2022-10-02", to: "2022-10-03"))
        .setDisablePaging();
    return op;
  }

  @override
  List<String>? getCustomAction() {
    return ["dashboard", "$iD"];
  }

  @override
  Widget? getDashboardAppbar(
    BuildContext context, {
    bool? firstPane,
    SecoundPaneHelperWithParentValueNotifier? basePage,
    TabControllerHelper? tab,
  }) {
    if (firstPane == false) {
      return basePage?.secPaneNotifier?.value?.title == null
          ? null
          : Text(basePage?.secPaneNotifier?.value?.title ?? "");
    }
    return DashboardHeader(
      object: this,
      date: dateObject ?? DateObject(),
      current_screen_size: findCurrentScreenSize(context),
      onPressePrint: () {
        printPage(context, secPaneNotifer: basePage);
      },
      onSelectedDate: (d) {
        if (d == null) return;
        dateObject = d;
        debitsDue = null;
        basePage?.refresh(extras: this, tab: tab);
        // getExtras().setDate(d);
        // refresh(extras: extras);
      },
    );
  }
}
