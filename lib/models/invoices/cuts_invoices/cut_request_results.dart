import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'cut_request_results.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CutRequestResult extends ViewAbstract<CutRequestResult> {
  // int? CutReqquestID;
  // int? ProductInputID;
  // int? ProductOutputID;

  CutRequest? cut_requests;
  ProductInput? products_inputs;
  ProductOutput? products_outputs;

  CutRequestResult() : super();

  @override
  CutRequestResult getSelfNewInstance() {
    return CutRequestResult();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "cut_requests": CutRequest(),
        "products_inputs": ProductInput(),
        "products_outputs": ProductOutput()
      };

  @override
  List<String> getMainFields({BuildContext? context}) => [
        "cut_requests",
        "products_inputs",
        "products_outputs",
      ];

  List<Product> getProducts() {
    return products_inputs?.getProductsFromDetailList() ?? [];
  }

  // List<

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.cutRequestResult;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${getIDFormat(context)}  ${cut_requests?.getMainHeaderTextOnly(context) ?? ""} ";

  @override
  IconData getMainIconData() => Icons.content_cut;

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "iD", type: SortByType.DESC);

  @override
  String? getTableNameApi() => "cut_request_results";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  factory CutRequestResult.fromJson(Map<String, dynamic> data) =>
      _$CutRequestResultFromJson(data);

  Map<String, dynamic> toJson() => _$CutRequestResultToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  CutRequestResult fromJsonViewAbstract(Map<String, dynamic> json) =>
      CutRequestResult.fromJson(json);
}
