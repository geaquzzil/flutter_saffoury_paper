import 'package:flutter_saffoury_paper/models/dashboards/balance_due.dart';

import '../funds/money_funds.dart';
import 'package:flutter_view_controller/ext_utils.dart';

extension MoneyFundTotals<T extends MoneyFunds> on List<T?>? {
  double getTotalValue({int? currencyID}) {
    if (this == null) return 0;
    try {
      if (currencyID == null) {
        return this!
            .map((e) => e?.value)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable())
            .toNonNullable();
      } else {
        return this!
            .where((element) => element?.equalities?.currency?.iD == currencyID)
            .map((e) => e?.value)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable())
            .toNonNullable();
      }
    } catch (e) {
      return 0;
    }
  }
}

extension BalanceDueTotals<T extends BalanceDue> on List<T?>? {
  double getTotalValue({String? currencyName, int? cashBoxID}) {
    if (this == null) return 0;
    try {
      if (currencyName == null && cashBoxID == null) {
        return this!
            .map((e) => e?.sum)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable())
            .toNonNullable();
      } else if (currencyName != null) {
        return this!
            .where((element) => element?.currency == currencyName)
            .map((e) => e?.sum)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable())
            .toNonNullable();
      } else {
        return this!
            .where((element) => element?.CashBoxID == cashBoxID)
            .map((e) => e?.sum)
            .reduce((value, element) =>
                value.toNonNullable() + element.toNonNullable())
            .toNonNullable();
      }
    } catch (e) {
      return 0;
    }
  }
}
