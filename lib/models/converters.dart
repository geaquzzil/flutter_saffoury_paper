import 'package:json_annotation/json_annotation.dart';

class JsonIntToString implements JsonConverter<String?, dynamic> {
  const JsonIntToString();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    return json.toString();
  }

  @override
  toJson(String? object) => object?.toString();
}

