import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_request_results.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CutRequest extends ViewAbstract<CutRequest> {
  // int? ProductID;
  // int? CustomerID;
  // int? EmployeeID;

  String? date;
  String? comments;
  double? quantity;
  CutStatus? cut_status;

  Product? products;
  Customer? customers;
  Employee? employees;

  List<CutRequestResult>? cut_request_results;
  int? cut_request_results_count;

  List<SizesCutRequest>? sizes_cut_requests;
  int? sizes_cut_requests_count;

  CutRequest() : super();

  @override
  List<String>? requireObjectsList() => ["cut_request_results"];
  @override
  List<String> getMainFields() => [
        "products",
        "customers",
        "employee",
        "date",
        "quantity",
        "cut_status",
        "comments"
      ];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
        "quantity": Icons.scale,
        "cut_status": Icons.reorder,
        "comments": Icons.comment
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "date": AppLocalizations.of(context)!.date,
        "quantity": AppLocalizations.of(context)!.quantity,
        "cut_status": AppLocalizations.of(context)!.status,
        "comments": AppLocalizations.of(context)!.comments,
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.cutRequest;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${getIDFormat(context)} : ${products?.getMainHeaderTextOnly(context)} ";

  @override
  IconData getMainIconData() => Icons.content_cut;

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "cut_requests";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"quantity": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() =>
      {"quantity": products?.getQuantity() ?? 1};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"quantity": 1};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "date": TextInputType.datetime,
        "quantitiy": TextInputType.number,
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"customers": true};

  @override
  Map<String, bool> isFieldRequiredMap() => {"quantity": true};

  factory CutRequest.fromJson(Map<String, dynamic> data) =>
      _$CutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$CutRequestToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CutRequest fromJsonViewAbstract(Map<String, dynamic> json) =>
      CutRequest.fromJson(json);
}

enum CutStatus { PENDING, PROCESSING, COMPLETED }

// enum CutStatus implements ViewAbstractEnum<CutStatus> {
//   PENDING,
//   PROCESSING,
//   COMPLETED;

//   @override
//   IconData getMainIconData() => Icons.stacked_line_chart_outlined;
//   @override
//   String getMainLabelText(BuildContext context) =>
//       AppLocalizations.of(context)!.status;

//   @override
//   String getFieldLabelString(BuildContext context, CutStatus field) {
//     switch (field) {
//       case PENDING:
//         return AppLocalizations.of(context)!.pending;
//       case PROCESSING:
//         return AppLocalizations.of(context)!.processing;
//       case COMPLETED:
//         return AppLocalizations.of(context)!.completed;
//     }
//   }

//   @override
//   List<CutStatus> getValues() {
//     return CutStatus.values;
//   }
// }
