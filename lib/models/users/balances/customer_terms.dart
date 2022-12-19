import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';

import '../customers.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

//  {
//     "iD": 1036,
//     "OrderID": 577,
//     "termsDate": "2022-03-25 11:54:15"
//   },
@reflector
class CustomerTerms extends Customer
    implements CustomViewHorizontalListResponse<CustomerTerms> {
  //FIX ME ITS ALSOW declares on Customer
//    @com.saffoury.viewgenerator.Annotations.View(Type = Enums.ViewType.VIEW_TEXT, Priority = 0, MasterOnList = true)
//     int termsBreakCount;
  int? OrderID;

  String? termsDate;

  CustomerTerms() : super();
  CustomerTerms.init(int iD) {
    this.iD = iD;
  }

  @override
  CustomerTerms getSelfNewInstance() {
    return CustomerTerms();
  }

  @override
  String? getCustomAction() => "list_customers_terms";
  @override
  Map<String, String> get getCustomMap => {"iD": iD.toString()};

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

  @override
  double getCustomViewHeight() => 200;

  @override
  String getCustomViewKey() => "customer_terms$iD";

  @override
  Widget? getCustomViewListResponseWidget(
      BuildContext context, List<CustomerTerms> item) {
    return StorageInfoCardCustom(
        title: AppLocalizations.of(context)!.overDue,
        description: "${item.length}",
        trailing: const Text("Times"),
        svgSrc: Icons.date_range);
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.LIST;

  @override
  Widget? getCustomViewSingleResponseWidget(
      BuildContext context) {
    // TODO: implement getCustomViewSingleResponseWidget
    throw UnimplementedError();
  }

  @override
  void onCustomViewCardClicked(BuildContext context, CustomerTerms istem) {
    // TODO: implement onCustomViewCardClicked
  }
}
