import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sizes.g.dart';

@JsonSerializable()
@reflector
class Size extends ViewAbstract<Size> {
  String? width;
  String? length;

  Size() : super();

  @override
  String getHeaderTextOnly(BuildContext context) {
    // TODO: implement getHeaderTextOnly
    return "${width}x$length";
  }

  @override
  Size fromJsonViewAbstract(Map<String, dynamic> json) {
    return Size.fromJson(json);
  }

  @override
  String? getTableNameApi() {
    return "sizes";
  }

  @override
  String? getDrawerGroupName() {
    // TODO: implement getDrawerGroupName
    return "products";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getLabelTextOnly(BuildContext context) {
    // TODO: implement getLabelTextOnly
    return "sizes";
  }

  factory Size.fromJson(Map<String, dynamic> data) => _$SizeFromJson(data);

  Map<String, dynamic> toJson() => _$SizeToJson(this);

  @override
  String getFieldLabel(String label, BuildContext context) {
    return label;
  }

  @override
  List<String> getFields() {
    return ["width", "length"];
  }

  @override
  IconData getIconData() {
    return Icons.border_all;
  }

  @override
  int? getTextInputMaxLength(String field) {
    return 4;
  }

  @override
  Map<String, TextInputType?> getMap() => {
        "width": TextInputType.number,
        "length": TextInputType.number,
      };
  @override
  bool getTextInputTypeIsAutoComplete(String field) {
    return true;
  }

  @override
  bool isFieldRequired(String field) {
    return field == "width";
  }

  @override
  IconData getFieldIconData(String label) {
    switch (label) {
      case "width":
        return Icons.border_left_outlined;
      case "length":
        return Icons.border_top_outlined;
    }

    return Icons.add_card_rounded;
  }
}
