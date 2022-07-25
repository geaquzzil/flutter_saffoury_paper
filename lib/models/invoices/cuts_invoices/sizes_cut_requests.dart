import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'sizes_cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class SizesCutRequest extends ViewAbstract<SizesCutRequest> {
  // int? CutRequestID;
  // int? SizeID;

  CutRequest? cut_requests;
  Size? sizes;
  double? quantity;

  SizesCutRequest() : super();

  @override
  List<String> getMainFields() => ["sizes", "quantity"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {"quantity": Icons.scale};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"quantity": AppLocalizations.of(context)!.quantity};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoice;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.requestedSizeLabel;
  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      "${sizes?.getMainHeaderLabelTextOnly(context)}";
  @override
  IconData getMainIconData() => Icons.screen_rotation_alt_sharp;
  @override
  String? getSortByFieldName() => "iD";

  @override
  SortByType getSortByType() => SortByType.ASC;

  @override
  String? getTableNameApi() => "sizes_cut_requests";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"quantity": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"quantity": TextInputType.number};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

    factory SizesCutRequest.fromJson(Map<String, dynamic> data) =>
      _$SizesCutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$SizesCutRequestToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  SizesCutRequest fromJsonViewAbstract(Map<String, dynamic> json) =>
      SizesCutRequest.fromJson(json);
}
