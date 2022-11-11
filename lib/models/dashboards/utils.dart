import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_saffoury_paper/models/dashboards/balance_due.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:supercharged/supercharged.dart';

import '../funds/money_funds.dart';
import 'package:flutter_view_controller/ext_utils.dart';

extension InvoiceMasterUtils<T extends InvoiceMaster> on List<T?>? {
  String getTotalQuantityGroupedFormattedText(BuildContext context) {
    List<String> list = [];
    Map<ProductTypeUnit, double> total = getTotalQuantityGrouped();
    total.forEach((key, value) {
      list.add(value.toCurrencyFormat(
          symbol: key.getFieldLabelString(context, key)));
    });
    return list.join("\n");
  }

  Map<ProductTypeUnit, double> getTotalQuantityGrouped() {
    if (this == null) return {};
    Map<ProductTypeUnit, double> map = {};

    for (var element in this!) {
      // if(map.containsKey(key))
      Map<ProductTypeUnit, double> detailMap = element!
          .getDetailListFromMaster()
          .getTotalQuantityGroupedByProductType();

      detailMap.forEach((key, value) {
        if (map.containsKey(key)) {
          map[key] = value + map[key]!;
        } else {
          map[key] = value;
        }
      });
    }

    return map;
  }
}

extension InvoiceMasterDetailsUtils<T extends InvoiceMasterDetails>
    on List<T?>? {
  String getTotalQuantityGroupedFormattedText(BuildContext context) {
    List<String> list = [];
    Map<ProductTypeUnit, double> total = getTotalQuantityGroupedByProductType();
    total.forEach((key, value) {
      list.add(value.toCurrencyFormat(
          symbol: key.getFieldLabelString(context, key)));
    });
    return list.join("\n");
  }

  Map<ProductTypeUnit, double> getTotalQuantityGroupedByProductType() {
    if (this == null) return {};
    try {
      Map<ProductTypeUnit, double> total = {};
      Map<ProductTypeUnit, List<double>> quantity = this!.groupBy(
          (item) => item!.products!.products_types!.unit!,
          valueTransform: (v) => v!.quantity.toNonNullable());
      quantity.forEach((key, value) {
        total[key] = value.reduce((value, element) =>
            value.toNonNullable() + element.toNonNullable());
      });
      return total;
    } catch (e) {
      return {};
    }
  }

  double getTotalQuantityGrouped({ProductTypeUnit? unit}) {
    if (this == null) return 0;
    Map<ProductTypeUnit?, List<double?>> quantity = this!.groupBy(
        (item) => item?.products?.products_types?.unit,
        valueTransform: (v) => v?.quantity.toNonNullable());

    debugPrint("InvoiceMasterDetailsUtils $quantity");
    if (unit == null) {
      return -1;
    } else {
      return quantity[unit]
              ?.reduce((value, element) =>
                  value.toNonNullable() + element.toNonNullable())
              .toNonNullable() ??
          0;
    }
  }
}

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

  double getTotalValueEqualtiy() {
    if (this == null) return 0;
    try {
      return this!
          .map((e) => e?.getValue())
          .reduce((value, element) =>
              value.toNonNullable() + element.toNonNullable())
          .toNonNullable();
    } catch (e) {
      return 0;
    }
  }
}

extension BalanceDueTotals<T extends BalanceDue> on List<T?>? {
  String getTotalGroupedFormattedText() {
    List<String> list = [];
    Map<String, double> total = getTotalGrouped();
    total.forEach((key, value) {
      list.add(value.toCurrencyFormat(symbol: key));
    });
    return list.join("\n");
  }

  Map<String, double> getTotalGrouped({int? CashboxID}) {
    if (this == null) return {};
    Map<String, double> total = {};
    Map<String, List<double>> t = {};
    if (CashboxID != null) {
      t = this!.where((element) => element!.CashBoxID == CashboxID).groupBy(
          (item) => item!.currency!,
          valueTransform: (v) => v!.sum.toNonNullable());
    } else {
      t = this!.groupBy((item) => item!.currency!,
          valueTransform: (v) => v!.sum.toNonNullable());
    }

    t.forEach((key, value) {
      total[key] = value
              .reduce((value, element) =>
                  value.toNonNullable() + element.toNonNullable())
              .toNonNullable() ??
          0;
    });

    return total;
  }

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

String getTotalGroupedFormattedText(Map<String, double> customMap) {
  List<String> list = [];
  Map<String, double> total = customMap;
  total.forEach((key, value) {
    list.add(value.toCurrencyFormat(symbol: key));
  });
  return list.join("\n");
}