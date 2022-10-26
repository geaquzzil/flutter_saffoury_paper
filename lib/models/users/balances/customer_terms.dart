import 'package:flutter_view_controller/models/v_mirrors.dart';

import '../customers.dart';

@reflector
class CustomerTerms extends Customer {
  String? termsDate;

  //FIX ME ITS ALSOW declares on Customer
//    @com.saffoury.viewgenerator.Annotations.View(Type = Enums.ViewType.VIEW_TEXT, Priority = 0, MasterOnList = true)
//     int termsBreakCount;
  int? OrderID;

  CustomerTerms() : super();

  @override
  CustomerTerms fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerTerms.fromJson(json);

  factory CustomerTerms.fromJson(Map<String, dynamic> json) => CustomerTerms()
    ..iD = json['iD'] as int
    ..termsDate = json['termsDate'] as String?
    ..OrderID = json['OrderID'] as int?
    ..login = json['login'] as bool?
    ..permission = json['permission'] as bool?
    ..response = json['response'] as int?
    ..phone = json['phone'] as String?
    ..name = json['name'] as String?
    ..email = json['email'] as String?
    ..token = json['token'] as String?
    ..activated = json['activated'] as int?
    ..date = json['date'] as String?
    ..city = json['city'] as String?
    ..address = json['address'] as String?
    ..profile = json['profile'] as String?
    ..comments = json['comments'] as String?
    ..cash = json['cash'] as int?
    ..totalCredits = (json['totalCredits'] as num?)?.toDouble()
    ..totalDebits = (json['totalDebits'] as num?)?.toDouble()
    ..totalOrders = (json['totalOrders'] as num?)?.toDouble()
    ..totalPurchases = (json['totalPurchases'] as num?)?.toDouble()
    ..balance = (json['balance'] as num?)?.toDouble();

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Map<String, dynamic> toJson() => {};
}
