import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
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
  Grades getSelfNewInstance() {
    return Grades();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"products": List<Product>.empty(), "products_count": 0});
  @override
  String getForeignKeyName() {
    return "GradeID";
  }

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

  @override
  List<Widget>? getCustomBottomWidget(BuildContext context,
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked}) {
    if (action == ServerActions.add ||
        action == ServerActions.edit ||
        action == ServerActions.list) {
      return null;
    }
    return [
      ListHorizontalApiAutoRestWidget(
        valueNotifier: onHorizontalListItemClicked,
        titleString: AppLocalizations.of(context)!
            .moreFromFormat(getMainHeaderTextOnly(context)),
        autoRest: AutoRest<Product>(
            range: 5,
            obj: Product()..setCustomMap(getSimilarCustomParams(context)),
            key: "similarProducts${getSimilarCustomParams(context)}"),
      ),
    ];
  }

  Map<String, String> getSimilarCustomParams(BuildContext context) {
    Map<String, String> hashMap = getCustomMap;
    hashMap["<${getForeignKeyName()}>"] = ("$iD");
    return hashMap;
  }
}
