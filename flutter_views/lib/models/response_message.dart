import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_message.g.dart';

@JsonSerializable()
class ResponseMessage<T> extends ViewAbstract<T> {
  bool? login;
  bool? permission;
  int? response;
  ResponseMessage() : super();

  factory ResponseMessage.fromJson(Map<String, dynamic> data) =>
      _$ResponseMessageFromJson(data);

  Map<String, dynamic> toJson() => _$ResponseMessageToJson(this);
  @override
  T fromJsonViewAbstract(Map<String, dynamic> json) {
    return ResponseMessage.fromJson(json) as T;
  }

  @override
  IconData getFieldIconData(String label) {
    // TODO: implement getFieldIconData
    throw UnimplementedError();
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    return "";
  }

  @override
  List<String> getFields() {
    return [
      "login","permissions","response"
    ];
  }

  @override
  IconData getIconData() {
    return Icons.nat;
  }

  @override
  String? getTableNameApi() {
    return "";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
}
