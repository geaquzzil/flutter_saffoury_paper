import 'package:flutter/cupertino.dart';
import 'package:flutter_saffoury_paper/models/dashboards/balance_due.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:supercharged/supercharged.dart';

import '../funds/money_funds.dart';
import '../products/products.dart';
import '../products/sizes.dart';

extension ProductUtils<T extends Product> on List<T?>? {
  String getTotalQuantityGroupedSizeTypeFormattedText(BuildContext context) {
    List<String> list = [];
    Map<ProductSizeType, double> total = getTotalQuantitySizeTypeGrouped();
    total.forEach((key, value) {
      list.add(value.toCurrencyFormat(
          symbol: key.getFieldLabelString(context, key)));
    });
    return list.join("\n");
  }

  String getTotalQuantityGroupedFormattedText(BuildContext context) {
    List<String> list = [];
    Map<ProductTypeUnit, double> total = getTotalQuantityGrouped();
    total.forEach((key, value) {
      list.add(value.toCurrencyFormat(
          symbol: key.getFieldLabelString(context, key)));
    });
    return list.join("\n");
  }

  Map<ProductSizeType, double> getTotalQuantityGroupedBySizeType() {
    if (this == null) return {};
    try {
      Map<ProductSizeType, double> total = {};
      Map<ProductSizeType, List<double>> quantity = this!.groupBy(
          (item) => item!.getSizeType(),
          valueTransform: (v) => v!.getQuantity().toNonNullable());
      quantity.forEach((key, value) {
        total[key] = value.reduce((value, element) =>
            value.toNonNullable() + element.toNonNullable());
      });
      return total;
    } catch (e) {
      return {};
    }
  }

  Map<ProductTypeUnit, double> getTotalQuantityGroupedByProductType() {
    if (this == null) return {};
    try {
      Map<ProductTypeUnit, double> total = {};
      Map<ProductTypeUnit, List<double>> quantity = this!.groupBy(
          (item) => item!.products_types!.unit!,
          valueTransform: (v) => v!.getQuantity().toNonNullable());
      quantity.forEach((key, value) {
        total[key] = value.reduce((value, element) =>
            value.toNonNullable() + element.toNonNullable());
      });
      return total;
    } catch (e) {
      return {};
    }
  }

  Map<ProductSizeType, double> getTotalQuantitySizeTypeGrouped() {
    if (this == null) return {};
    Map<ProductSizeType, double> map = {};

    Map<ProductSizeType, double> detailMap =
        getTotalQuantityGroupedBySizeType();

    detailMap.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = value + map[key]!;
      } else {
        map[key] = value;
      }
    });

    return map;
  }

  Map<ProductTypeUnit, double> getTotalQuantityGrouped() {
    if (this == null) return {};
    Map<ProductTypeUnit, double> map = {};

    Map<ProductTypeUnit, double> detailMap =
        getTotalQuantityGroupedByProductType();

    detailMap.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = value + map[key]!;
      } else {
        map[key] = value;
      }
    });

    return map;
  }
}

extension InvoiceMasterUtils<T extends InvoiceMaster> on List<T?>? {
  String getTotalQuantityGroupedFormattedText(BuildContext context) {
    List<String> list = [];
    Map<ProductTypeUnit, double> total = getTotalQuantityGrouped();
    debugPrint("getTotalQuantityGroupedFormattedText $total");
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

      debugPrint(
          "getTotalQuantityGroupedFormattedText getTotalQuantityGrouped $detailMap");

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
  ///getting only currnecyID 1 and 2 and compine together
  ///todo this function is static
  String getTotalValueString(BuildContext context) {
    if (this == null) return AppLocalizations.of(context)!.noItems;
    List<String> l = List.empty(growable: true);
    double first = getTotalValue(currencyID: 1);
    double secound = getTotalValue(currencyID: 2);
    if (first == 0 && secound == 0) {
      return AppLocalizations.of(context)!.no_content;
    }
    if (first != 0) {
      l.add(first.toCurrencyFormat(
          symbol: AppLocalizations.of(context)!.sypDots));
    }
    if (secound != 0) {
      l.add(
          secound.toCurrencyFormat(symbol: AppLocalizations.of(context)!.syp));
    }

    return l.join("\n");
  }

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
          .toNonNullable();
    });
    debugPrint("getTotalPreviousBalance getToto getTotalGrouped $total");
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
