import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_saffoury_paper/models/users/users_actions/customer_by_employee_analysis.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_custom_view_horizontal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
part 'employees.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Employee extends User<Employee> {
  // int? ParentID;
  int? publish;

  Employee? employee;

  Employee() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "publish": 0,
          "employee": Employee(),
        });

  @override
  IconData getMainIconData() {
    return Icons.engineering;
  }

  @override
  String? getTableNameApi() {
    return "employees";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.employee;

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory Employee.fromJson(Map<String, dynamic> data) =>
      _$EmployeeFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Employee fromJsonViewAbstract(Map<String, dynamic> json) =>
      Employee.fromJson(json);

  @override
  Map<String, dynamic> getMirrorFieldsNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "publish": 0,
          "employee": Employee(),
        });

  @override
  List<TabControllerHelper> getCustomTabList(BuildContext context) {
    return [
      TabControllerHelper(AppLocalizations.of(context)!.size_analyzer, null,
          widget: Center(
            child: Text("sdad $iD"),
          )),
      TabControllerHelper(
        AppLocalizations.of(context)!.size_analyzer,
        null,
        widget: ListHorizontalCustomViewApiAutoRestWidget(
            // onResponseAddWidget: ((response) {
            //   CustomerByEmployeeAnanlysis i = response as ChartRecordAnalysis;
            //   double total = i.getTotalListAnalysis();
            //   return Column(
            //     children: [
            //       // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
            //       //     titleString: "TEST1 ",
            //       //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
            //       StorageInfoCardCustom(
            //           title: AppLocalizations.of(context)!.total,
            //           description: total.toCurrencyFormat(),
            //           trailing: "kg",
            //           svgSrc: Icons.monitor_weight),
            //       StorageInfoCardCustom(
            //           title: AppLocalizations.of(context)!.balance,
            //           description:
            //               customers?.balance?.toCurrencyFormat() ?? "0",
            //           trailing: "trailing",
            //           svgSrc: Icons.balance),
            //     ],
            //   );
            // }),
            titleString: "TEST1 ",
            autoRest: CustomerByEmployeeAnanlysis.init(iD)),
      ),

      //  ChartItem(
      //   autoRest: AutoRest<Order>(
      //     obj: Order()..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
      //     key: "CustomerByOrder$iD"),
      // ),
    ];
  }
}
