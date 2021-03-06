import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'sizes.g.dart';

@JsonSerializable()
@reflector
class Size extends ViewAbstract<Size> {
  int? width;
  int? length;

  Size() : super();

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.type_specimen_outlined;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "$width X $length";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.size;
  }

  @override
  List<String> getMainFields() {
    return ['width', 'length'];
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {"width": true, "length": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "width": TextInputType.number,
        "length": TextInputType.number,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"width": 4, "length": 4, "purchasePrice": 8};

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "sizes";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "width": Icons.border_left,
        "length": Icons.border_top,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "width": AppLocalizations.of(context)!.width,
        "length": AppLocalizations.of(context)!.length,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() =>
      // {"width": true, "length": true};
      {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {"width": 10};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory Size.fromJson(Map<String, dynamic> data) => _$SizeFromJson(data);

  Map<String, dynamic> toJson() => _$SizeToJson(this);

  @override
  Size fromJsonViewAbstract(Map<String, dynamic> json) {
    return Size.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getSortByFieldName() {
    return "width";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }
}
