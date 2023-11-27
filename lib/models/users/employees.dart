import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_saffoury_paper/models/users/users_actions/customer_by_employee_analysis.dart';
import 'package:flutter_saffoury_paper/models/users/warehouse_employees.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
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
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
part 'employees.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class Employee extends User<Employee> {
  // int? ParentID;
  int? publish;

  Employee? employee;

  List<WarehouseEmployee>? warehouse_employees;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Warehouse? warehouse;

  Employee() : super() {
    warehouse_employees = [];
  }

  // @override
  // void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
  //   super.onBeforeGenerateView(context);
  //   if (action == ServerActions.edit && isNew()) {
  //     employees =
  //         context.read<AuthProvider<AuthUser>>().getSimpleUser as Employee;
  //   }
  // }

  @override
  Employee getSelfNewInstance() {
    return Employee();
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return super.getMainFields(context: context)..addAll(["warehouse"]);
  }

  @override
  String getForeignKeyName() {
    return "EmployeeID";
  }

  @override
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.list: ["warehouse_employees"]
      };

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "publish": 0,
          "employee": Employee(),
          "warehouse": Warehouse(),
          "warehouse_employees": List<WarehouseEmployee>.empty()
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
  void onMultiChipSaved(
      BuildContext context, String field, List? selectedList) {
    debugPrint("onMultiChipSaved warehouse_employees $selectedList");
    warehouse_employees?.forEach((element) {
      element.delete = true;
    });
    if (selectedList?.isEmpty ?? true) {
      debugPrint("onMultiChipSaved employee is empty");
    } else {
      List<Warehouse> selectedWarehouse = selectedList!.cast<Warehouse>();
      warehouse_employees ??= [];
      for (var element in selectedWarehouse) {
        warehouse_employees!.add(WarehouseEmployee()
          ..employees = copyWithReduceSize() as Employee
          ..warehouse = element);
      }
      debugPrint("onMultiChipSaved warehouse_employees $warehouse_employees");
    }
  }

  @override
  List getMultiChipInitalValue(BuildContext context, String field) {
    return warehouse_employees?.map((e) => e.warehouse).toList() ??
        List<Warehouse>.empty();
  }

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "warehouse") {
      return ViewAbstractControllerInputType.MULTI_CHIPS_API;
    }
    return super.getInputType(field);
  }

  @override
  List<TabControllerHelper> getCustomTabList(BuildContext context,
      {ServerActions? action}) {
    return [
      TabControllerHelper(
        AppLocalizations.of(context)!.sales_analysis,
        slivers: [
          SliverFillRemaining(
            child: ListHorizontalCustomViewApiAutoRestWidget(
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

                autoRest: CustomerByEmployeeAnanlysis.init(iD)),
          )
        ],
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
