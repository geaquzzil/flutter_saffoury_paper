import 'package:flutter_view_controller/models/view_abstract_permissions.dart';

class BalanceDue {
  String? currency;
  double? sum;

  int? CashBoxID;

  BalanceDue();
  bool isDollar() {
    return currency == (r"S.Y.P");
  }

  @override
  String toString() {
    return "currency $currency sum $sum";
  }

  factory BalanceDue.fromJson(Map<String, dynamic> data) => BalanceDue()
    ..currency = data['currency'] as String?
    ..sum = convertToDouble(data['sum'])
    ..CashBoxID = data['CashBoxID'] as int?;

  Map<String, dynamic> toJson() => {};
}
