import 'package:flutter_saffoury_paper/models/cities/manufactures.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

import 'countries.dart';

part 'countries_manufactures.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class CountryManufacture extends ViewAbstract<CountryManufacture> {
  // int? CountryID;
  // int? ManufacturerID;
  Country? countries;

  Manufacture? manufactures;

  CountryManufacture() : super();
}
