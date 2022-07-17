import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'quality.g.dart';

@JsonSerializable()
@reflector
class Quality extends ViewAbstract<Quality> {
  String? name;
  Quality() : super();
  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.auto_awesome_sharp;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return name ?? "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.quality;
  }

  @override
  List<String> getMainFields() {
    return ['name'];
  }

  @override
  Map<String, bool> isFieldRequiredMap() => {"name": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "name": TextInputType.text,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "name": 50,
      };

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  String? getTableNameApi() {
    return "qualities";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "name": Icons.auto_awesome_sharp,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "name": AppLocalizations.of(context)!.quality,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"name": true};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  factory Quality.fromJson(Map<String, dynamic> data) =>
      _$QualityFromJson(data);

  Map<String, dynamic> toJson() => _$QualityToJson(this);

  @override
  Quality fromJsonViewAbstract(Map<String, dynamic> json) {
    return Quality.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
   @override
  String getSortByFieldName() {
    return "name";
  }

  @override
  SortByType getSortByType() {
    return SortByType.DESC;
  }
}
