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
  Size fromJsonViewAbstract(Map<String, dynamic> json) {
    return Size.fromJson(json);
  }

  @override
  String? getTableNameApi() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
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
  IconData getIconData(BuildContext context) {
    return Icons.add_card_rounded;
  }

  @override
  IconData getIconDataField(String label, BuildContext context) {
    switch (label) {
      case "width":
        return Icons.border_left_outlined;
      case "length":
        return Icons.border_top_outlined;
    }

    return Icons.add_card_rounded;
  }
}
