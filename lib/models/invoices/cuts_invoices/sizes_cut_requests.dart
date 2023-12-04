import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'sizes_cut_requests.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class SizesCutRequest extends ViewAbstract<SizesCutRequest> {
  // int? CutRequestID;
  // int? SizeID;

  CutRequest? cut_requests;
  ProductSize? sizes;
  double? quantity;

  SizesCutRequest() : super() {
    // sizes = ProductSize();
  }

  @override
  SizesCutRequest getSelfNewInstance() {
    return SizesCutRequest();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "cut_requests": CutRequest(),
        "sizes": ProductSize(),
        "quantity": 0.toDouble()
      };
  @override
  List<String> getMainFields({BuildContext? context}) => ["sizes", "quantity"];

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
      "${sizes?.getMainHeaderTextOnly(context)}";
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
  Map<String, double> getTextInputMaxValidateMap() {
    debugPrint(
        "getTextInputMaxValidateMap parent is ${parent.runtimeType}  quantity is ${(parent as CutRequest).quantity}");

    return {"quantity": (parent as CutRequest).quantity ?? 0};
  }

  @override
  List<Widget>? getCustomTopWidget(BuildContext context,
      {ServerActions? action}) {
    if (isNew()) {
      if (parent is CutRequest) {
        if ((parent as CutRequest).products == null) {
          [
            MaterialBanner(
                content: Text(AppLocalizations.of(context)!.errFieldNotSelected(
                    AppLocalizations.of(context)!.product)),
                actions: [])
          ];
        }
      }
    }
    return null;
  }

  int getMaxWidth() {
    return (parent as CutRequest).findMaxWidth();
  }

  int getMinWidth() {
    return (parent as CutRequest).findMinWidth();
  }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizesCutRequest &&
          runtimeType == other.runtimeType &&
          sizes?.width == other.sizes?.width;

  @override
  int get hashCode => sizes?.width.hashCode ?? super.hashCode;
}
