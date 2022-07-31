import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'grades.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Grades extends BaseWithNameString<Grades> {
  List<Product>? products;
  int? products_count;
  Grades() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.grade;
  }

  @override
  IconData getMainIconData() => Icons.grade;
  @override
  String? getTableNameApi() => "grades";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

  factory Grades.fromJson(Map<String, dynamic> data) => _$GradesFromJson(data);

  Map<String, dynamic> toJson() => _$GradesToJson(this);

  @override
  Grades fromJsonViewAbstract(Map<String, dynamic> json) {
    return Grades.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;
}
