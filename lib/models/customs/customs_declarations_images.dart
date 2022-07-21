import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'customs_declarations_images.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CustomerDeclarationImages
    extends ViewAbstract<CustomerDeclarationImages> {
  // int? CustomerDeclarationID;
  String? image;
  String? comments;

  CustomsDeclaration? customs_declarations;

  CustomerDeclarationImages() : super();

  @override
  List<String> getMainFields() => ["customs_declarations", "image", "comments"];

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"image": Icons.image, "comments": Icons.notes};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "image": AppLocalizations.of(context)!.adsImages,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customs_clearnces;

  @override
  String getMainHeaderTextOnly(BuildContext context) => "$comments";

  @override
  IconData getMainIconData() => Icons.gavel_sharp;

  @override
  String? getSortByFieldName() => "comments";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => "customs_declarations_images";

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {
        "image": true,
      };

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"comments": TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  CustomerDeclarationImages fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
