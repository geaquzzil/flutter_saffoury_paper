import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

abstract class BaseWithNameString<T> extends ViewAbstract<T> {
  String? name;

  BaseWithNameString() : super();

  @override
  List<String> getMainFields() => ["name"];

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      name ?? "not found for $T";

  @override
  String? getSortByFieldName() => "name";

  @override
  SortByType getSortByType() => SortByType.DESC;

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
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"name": TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"name": true};

  @override
  Map<String, IconData> getFieldIconDataMap() => {"name": getMainIconData()};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"name": getMainHeaderLabelTextOnly(context)};
}
