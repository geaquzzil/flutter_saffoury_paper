import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'products_color.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductsColor extends ViewAbstract<ProductsColor> {
  String? top;
  String? middle;
  String? back;
  ProductsColor() : super();
  @override
  ProductsColor getSelfNewInstance() {
    return ProductsColor();
  }

  @override
  ProductsColor getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    if (value is Map) {
      String hexValidation = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\$";
      final alphanumeric = RegExp(hexValidation);
      bool topHex = alphanumeric.hasMatch(value['top']);
      bool middleHex = alphanumeric.hasMatch(value['middle']);
      bool bottomHex = alphanumeric.hasMatch(value['back']);
      int? widthMap = int.tryParse(value['width']);
      if (topHex == false || middleHex == false || bottomHex == false) {
        throw Exception(
            "${getMainHeaderLabelTextOnly(context)}: Cannot convert the value of top to =${value['top']} or the value of middle to =${value['middle']}  or the value of back to =${value['back']} to a hex color \nex:#f2f4f2");
      } else {
        top = value['top'];
        middle = value['middle'];
        back = value['back'];
        return this;
      }
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)}: ProductsColor.getSelfNewInstance is not a Map");
    }
  }

  @override
  String getForeignKeyName() {
    return "ProductColorID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      {"top": "", "middle": "", "back": ""};
  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.color_lens;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return iD.toString();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.productsColors;
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ['top', 'middle', 'back'];
  }

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"top": true, 'middle': true, 'back': true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "top": TextInputType.text,
        'middle': TextInputType.text,
        'back': TextInputType.text
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"top": 6, 'middle': 6, 'back': 6};

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "products_colors";
  }

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    return ViewAbstractControllerInputType.COLOR_PICKER;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"top": Icons.colorize, 'middle': Icons.colorize, 'back': Icons.colorize};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "top": AppLocalizations.of(context)!.top,
        "middle": AppLocalizations.of(context)!.middle,
        "back": AppLocalizations.of(context)!.back,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory ProductsColor.fromJson(Map<String, dynamic> data) =>
      _$ProductsColorFromJson(data);

  Map<String, dynamic> toJson() => _$ProductsColorToJson(this);

  @override
  ProductsColor fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductsColor.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getSortByFieldName() {
    return "top";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }

  @override
  Map<String, dynamic> getMirrorFieldsNewInstance() =>
      {"top": "", "middle": "", "back": ""};
}
