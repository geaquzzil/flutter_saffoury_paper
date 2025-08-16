import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/widgets/chart_date_chosser.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/unused_records.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import 'invoice_master_details.dart';

part 'orders.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Order extends InvoiceMaster<Order>
    implements CartableInvoiceMasterObjectInterface {
  List<OrderDetails>? orders_details;
  int? orders_details_count;

  List<OrderRefund>? orders_refunds;
  int? orders_refunds_count;

  Order() : super() {
    orders_details = <OrderDetails>[];
  }
  @override
  Order getSelfNewInstance() {
    return Order();
  }

  @override
  String getForeignKeyName() {
    return "OrderID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()..addAll({
        "order_details": List<OrderDetails>.empty(),
        "orders_details_count": 0,
        "orders_refunds": List<OrderRefund>.empty(),
        "orders_refunds_count": 0,
      });

  @override
  String? getTableNameApi() => "orders";

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.orders;

  factory Order.fromJson(Map<String, dynamic> data) => _$OrderFromJson(data);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  List<TabControllerHelper> getCustomTabList(
    BuildContext context, {
    ServerActions? action,
    SecoundPaneHelperWithParentValueNotifier? basePage,
  }) {
    return [
      TabControllerHelper(
             titleFunction:(context) => AppLocalizations.of(context)!.findSimilar,
        widget: SliverApiMixinViewAbstractWidget(
          toListObject: Order().setRequestOption(
            option: RequestOptions().addSearchByField(
              "CustomerID",
              customers?.iD,
            ),
          ),
        ),
      ),
      TabControllerHelper(
             titleFunction:(context) => AppLocalizations.of(context)!.overview,
        widget: getTabControllerChartWidget(context),
      ),

      //  ChartItem(
      //   autoRest: AutoRest<Order>(
      //     obj: Order()..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
      //     key: "CustomerByOrder$iD"),
      // ),
    ];
  }

  Widget getTabControllerChartWidget(BuildContext context) {
    return SliverFillRemaining(
      child: ChartDateChooser<EnteryInteval>(
        obj: EnteryInteval.monthy,
        onSelected: (obj) => SliverApiMixinViewAbstractWidget(
          toListObject: ChartRecordAnalysis.init(
            Order(),
            enteryInteval: obj ?? EnteryInteval.monthy,
            customRequestOption: RequestOptions()
                .addGroupBy("CustomerID")
                .addSearchByField("CustomerID", customers?.iD),
          ),

          onResponseAddCustomWidget: (isSliver, _, _, response) {
            //TODO
            
            return null;
            // ChartRecordAnalysis i = response as ChartRecordAnalysis;
            // double total = i.getTotalListAnalysis();
            // return Column(
            //   children: [
            //     // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
            //     //     titleString: "TEST1 ",
            //     //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
            //     StorageInfoCardCustom(
            //       title: AppLocalizations.of(context)!.total,
            //       description: total.toCurrencyFormat(),
            //       trailing: const Text("kg"),
            //       svgSrc: Icons.monitor_weight,
            //     ),
            //     StorageInfoCardCustom(
            //       title: AppLocalizations.of(context)!.balance,
            //       description: customers?.balance?.toCurrencyFormat() ?? "0",
            //       trailing: const Text("trailing"),
            //       svgSrc: Icons.balance,
            //     ),
            //   ],
            // );
          },
        ),
      ),
    );
  }

  @override
  Order fromJsonViewAbstract(Map<String, dynamic> json) => Order.fromJson(json);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getCartableInvoiceSummary(
    BuildContext context,
  ) {
    double? totalPrice = getTotalPriceFromList();
    double? totalDiscount = getTotalDiscountFromList();
    double? totalQuantity = getTotalQuantityFromList();
    double? totalNetPrice = (totalPrice ?? 0) - (totalDiscount ?? 0);
    debugPrint("getCartableInvoiceSummary $orders_details");
    // [this].getTotalQuantityGroupedFormattedText(context);
    return [
      InvoiceTotalTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
        description: totalPrice?.toCurrencyFormatFromSetting(context) ?? "0",
      ),
      InvoiceTotalTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.discount.toUpperCase(),
        description: totalDiscount?.toStringAsFixed(2) ?? "0",
      ),
      InvoiceTotalTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.quantity.toUpperCase(),
        description: orders_details.getTotalQuantityGroupedFormattedText(
          context,
        ),
      ),
      InvoiceTotalTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
        description: totalNetPrice.toCurrencyFormatFromSetting(context),
        hexColor: getPrintablePrimaryColor(null),
      ),
    ];
  }

  @override
  List<Widget>? getHomeListHeaderWidgetList(BuildContext context) {
    return [
      SliverApiMixinViewAbstractWidget(
        // cardType: CardType.grid,
        isSliver: true,
        scrollDirection: Axis.horizontal,
        toListObject: UnusedRecords.init(this),
      ),
    ];
  }

  @override
  List<CartableInvoiceDetailsInterface> getDetailList() {
    return orders_details ?? [];
  }

  @override
  Widget onCartCheckout(
    BuildContext context,
    List<CartableProductItemInterface> details,
  ) {
    return BaseEditNewPage(viewAbstract: this);
  }

  @override
  void onCartItemChanged(
    BuildContext context,
    int index,
    CartableInvoiceDetailsInterface cii,
  ) {
    if (index != -1) {
      orders_details![index] = cii as OrderDetails;
    }
    try {
      OrderDetails? d = orders_details?.firstWhereOrNull(
        (element) => element.products?.iD == (cii as OrderDetails).products?.iD,
      );
      d = cii as OrderDetails?;
    } catch (e) {}
  }

  @override
  void onCartItemRemoved(
    BuildContext context,
    int index,
    CartableInvoiceDetailsInterface cii,
  ) {
    if (index != -1) {
      orders_details?.removeAt(index);
    }
    try {
      orders_details?.removeWhere(
        (element) => element.products?.iD == (cii as OrderDetails).products?.iD,
      );
    } catch (e) {}
  }

  @override
  CartableInvoiceDetailsInterface getCartableNewInstance(
    BuildContext context,
    CartableProductItemInterface product,
  ) {
    return OrderDetails()..setProduct(context, product as Product);
  }

  @override
  void onCartItemAdded(
    BuildContext context,
    int index,
    CartableProductItemInterface cii, {
    double? quantiy,
  }) {
    orders_details?.add(
      OrderDetails()..setProduct(
        context,
        cii as Product,
        quantity: quantiy ?? (cii).getCartableProductQuantity(),
      ),
    );
  }

  @override
  void onCartClear() {
    orders_details?.clear();
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return ["orders_details"];
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderDetails extends InvoiceMasterDetails<OrderDetails>
    implements CartableInvoiceDetailsInterface {
  // int? OrderID;
  Order? orders;
  OrderDetails() : super();
  @override
  OrderDetails getSelfNewInstance() {
    return OrderDetails();
  }

  @override
  String getForeignKeyName() {
    return "OrderDetailsID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()..addAll({"orders": Order()});
  @override
  String? getTableNameApi() => "orders_details";

  factory OrderDetails.fromJson(Map<String, dynamic> data) =>
      _$OrderDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  OrderDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      OrderDetails.fromJson(json);

  @override
  Map<String, DataTableContent> getCartInvoiceTableHeaderAndContent(
    BuildContext context,
  ) => {
    "description": DataTableContent(
      title: AppLocalizations.of(context)!.description,
      value: products?.getMainHeaderTextOnly(context) ?? "",
      canEdit: false,
    ),
    if (!kIsWeb)
      "gsm": DataTableContent(
        title: AppLocalizations.of(context)!.gsm,
        value: products?.gsms?.gsm ?? 0,
        canEdit: false,
      ),
    "quantity": DataTableContent(
      title: AppLocalizations.of(context)!.quantity,
      value: quantity ?? 0,
      canEdit: true,
    ),
    "unitPrice": DataTableContent(
      title: AppLocalizations.of(context)!.unit_price,
      value: unitPrice ?? 0,
      canEdit: true,
    ),
    if (!kIsWeb)
      "discount": DataTableContent(
        title: AppLocalizations.of(context)!.discount,
        value: discount ?? 0,
        canEdit: true,
      ),
    "price": DataTableContent(
      title: AppLocalizations.of(context)!.total_price,
      value: price ?? 0,
      canEdit: true,
    ),
  };

  @override
  bool isCartEquals(CartableInvoiceDetailsInterface other) {
    return products?.iD == (other as Product).iD;
  }

  @override
  void getCartableEditableOnChange(
    BuildContext context,
    int idx,
    String field,
    value,
  ) {
    debugPrint("getCartableEditableOnChange field=> $field value => $value");
    setFieldValue(field, double.tryParse(value) ?? 0);
    if (field == "quantity") {
      price = quantity.toNonNullable() * unitPrice.toNonNullable();
    }
    if (field == "price") {
      unitPrice = price.toNonNullable() / quantity.toNonNullable();
    }
    if (field == "unitPrice") {
      price = unitPrice.toNonNullable() * quantity.toNonNullable();
    }
    context.read<CartProvider>().onCartItemChanged(context, idx, this);
  }

  @override
  String? Function(dynamic) getCartableEditableValidateItemCell(
    BuildContext context,
    String field,
  ) {
    return getTextInputValidatorCompose(context, field);
  }

  @override
  bool isCartProductFounded(CartableProductItemInterface product) {
    return (product as ViewAbstract).iD == products?.iD;
  }
}
