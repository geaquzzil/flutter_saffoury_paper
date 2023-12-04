import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'gsms.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class GSM extends ViewAbstract<GSM> {
  int? gsm;

  List<Product>? products;
  int? products_count;

  GSM() : super();

  @override
  GSM getSelfNewInstance() {
    return GSM();
  }

  @override
  GSM getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    int? gs = int.tryParse(value.toString());
    if (gs != null) {
      gsm = gs;
      return this;
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)}: Cannot convert value of gsm to => $value to a number");
    }
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"products": List<Product>.empty(), "products_count": 0, "gsm": 0};

  @override
  String getForeignKeyName() {
    return "GSMID";
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.view_headline;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return gsm == null ? "-" : gsm.toString();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.gsm;
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ['gsm'];
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {"gsm": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "gsm": TextInputType.number,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {"gsm": 4};

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "gsms";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "gsm": Icons.line_weight,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "gsm": AppLocalizations.of(context)!.gsm,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"gsm": true};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory GSM.fromJson(Map<String, dynamic> data) => _$GSMFromJson(data);

  Map<String, dynamic> toJson() => _$GSMToJson(this);

  @override
  GSM fromJsonViewAbstract(Map<String, dynamic> json) {
    return GSM.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getSortByFieldName() {
    return "gsm";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }
}
