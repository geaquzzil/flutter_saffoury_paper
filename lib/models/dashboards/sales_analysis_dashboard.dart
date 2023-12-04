import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoices/invoice_master.dart';

part 'sales_analysis_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class SalesAnalysisDashboard extends ViewAbstract<SalesAnalysisDashboard> {
  DateObject? date;

  List<Product>? bestSellingSize;

  List<Product>? bestSellingGSM;

  List<Product>? bestSellingTYPE;

  List<Product>? bestProfitableType;

  List<GrowthRate>? totalSalesQuantity;
  List<GrowthRate>? totalSalesQuantityAnalysis;

  List<GrowthRate>? totalReturnsQuantity;
  List<GrowthRate>? totalReturnsQuantityAnalysis;

  List<GrowthRate>? totalNetSalesQuantity;
  List<GrowthRate>? totalNetSalesQuantityAnalysis;

  List<GrowthRate>? wastesQuantity;
  List<GrowthRate>? wastesQuantityAnalysis;

  List<GrowthRate>? profits;
  List<GrowthRate>? profitsAnalysis;

  List<AccountNamesBalance>? incomesDue;
  List<AccountNamesBalance>? spendingsDue;

  List<GrowthRate>? wastes;
  List<GrowthRate>? wastesAnalysis;
  List<GrowthRate>? netProfit;

  SalesAnalysisDashboard();

  @override
  SalesAnalysisDashboard getSelfNewInstance() {
    return SalesAnalysisDashboard();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  String? getSortByFieldName() {
    // TODO: implement getSortByFieldName
    throw UnimplementedError();
  }

  @override
  SortByType getSortByType() {
    // TODO: implement getSortByType
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }

  factory SalesAnalysisDashboard.fromJson(Map<String, dynamic> data) =>
      _$SalesAnalysisDashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$SalesAnalysisDashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  SalesAnalysisDashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      SalesAnalysisDashboard.fromJson(json);
}

class AccountNamesBalance {
  String? name;
  double? sum;

  AccountNamesBalance();

  factory AccountNamesBalance.fromJson(Map<String, dynamic> data) =>
      AccountNamesBalance()
        ..name = data['name'] as String?
        ..sum = InvoiceMaster.convertToDouble(data['sum']);

  Map<String, dynamic> toJson() => {};
}
