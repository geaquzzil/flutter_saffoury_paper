import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qualities.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Quality extends BaseWithNameString<Quality> {
  List<Product>? products;
  int? products_count;

  Quality() : super();
  @override
  Quality getSelfNewInstance() {
    return Quality();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"products": List<Product>.empty(), "products_count": 0});
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.quality;
  }

  @override
  IconData getMainIconData() => Icons.query_stats;
  @override
  String? getTableNameApi() => "qualities";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

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
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  String getForeignKeyName() {
    return "QualityID";
  }

  @override
  List<Widget>? getCustomBottomWidget(
    BuildContext context, {
    ServerActions? action,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
  }) {
    if (action == ServerActions.add ||
        action == ServerActions.edit ||
        action == ServerActions.list) {
      return null;
    }
    return [
      SliverApiMixinViewAbstractWidget(
        cardType: CardItemType.grid,
        scrollDirection: Axis.horizontal,
        toListObject: Product().getSelfInstanceWithSimilarOption(
          context: context,
          obj: this,
          copyWith: RequestOptions(countPerPage: 5),
        ),
      ),
    ];
  }
}
