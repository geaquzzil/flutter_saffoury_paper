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

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());

  factory BalanceDue.fromJson(Map<String, dynamic> data) => BalanceDue()
    ..currency = data['currency'] as String?
    ..sum = BalanceDue.convertToDouble(data['sum'])
    ..CashBoxID = data['CashBoxID'] as int?;

  Map<String, dynamic> toJson() => {};
}
