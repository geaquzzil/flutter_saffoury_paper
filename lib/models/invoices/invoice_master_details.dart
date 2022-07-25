import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class InvoiceMasterDetails<T> extends ViewAbstract<T> {
  // int? ProductID;
  // int? WarehouseID;

  Product? products;
  Warehouse? warehouse;

  double? quantity;
  double? unitPrice;
  double? discount;
  double? price;

  String? comments;

  InvoiceMasterDetails() : super();
  InvoiceMasterDetails setProduct(Product products) {
    this.products = products;
    unitPrice = products.getCartItemUnitPrice();
    price = products.getCartItemPrice();
    quantity = products.getCartItemQuantity();
    discount = 0;
    return this;
  }

  @override
  List<String> getMainFields() => [
        "products",
        "warehouse",
        "quantity",
        "unitPrice",
        "discount",
        "price",
        "comments"
      ];
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "quantity": AppLocalizations.of(context)!.quantity,
        "unitPrice": AppLocalizations.of(context)!.unit_price,
        "discount": AppLocalizations.of(context)!.discount,
        "price": AppLocalizations.of(context)!.total_price,
        "comments": AppLocalizations.of(context)!.comments
      };
  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "quantity": Icons.production_quantity_limits,
        "unitPrice": Icons.price_change,
        "discount": Icons.discount,
        "price": Icons.price_check,
        "comments": Icons.comment
      };
  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "quantity": const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        "unitPrice":
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        "discount":
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        "price":
            const TextInputType.numberWithOptions(decimal: true, signed: false),
        "comments": TextInputType.text
      };
  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"quantity": true, "unitPrice": true, "discount": true, "price": true};

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      products?.getMainHeaderTextOnly(context) ?? "not found for products";

  @override
  IconData getMainIconData() => Icons.list;

  @override
  String? getSortByFieldName() => "iD";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"quantity": 10, "unitPrice": 10, "price": 10, "discount": 10};

  @override
  Map<String, double> getTextInputMaxValidateMap() =>
      {"quantity": getMaxQuantityValue(), "discount": getMaxDiscountValue()};

  @override
  Map<String, double> getTextInputMinValidateMap() =>
      {"quantity": 1, "unitPrice": 0.1, "price": 0.1, "discount": 0};

  @override
  String? getImageUrl(BuildContext context) {
    return products?.getImageUrl(context);
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoices;

  double getMaxDiscountValue() {
    return products?.getTotalSellPrice() ?? 0;
  }

  double getMinQuantityValue() {
    return 1;
  }

  double getMaxQuantityValue() {
    return products?.getQuantity() ?? 0;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.details;
}
