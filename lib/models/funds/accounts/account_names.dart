import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_names.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class AccountName extends ViewAbstract<AccountName> {
  // int? TypeID;
  AccountNameType? account_names_types;
  String? name;
  AccountName() : super();
}

@JsonSerializable(explicitToJson: true)
@reflector
class AccountNameType extends ViewAbstract<AccountNameType> {
  String? type;
  String? typeAr;
  AccountNameType() : super();
}
