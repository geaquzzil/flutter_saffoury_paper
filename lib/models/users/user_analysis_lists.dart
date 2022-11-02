import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';

class UserLists<T> extends AuthUser {
  List<CutRequest>? cut_requests;
  List<GrowthRate>? cut_requestsAnalysis;
  int? cut_requests_count;

  List<Order>? orders;
  List<GrowthRate>? ordersAnalysis;
  int? orders_count;

  List<Purchases>? purchases;
  List<GrowthRate>? purchasesAnalysis;
  int? purchases_count;

  List<OrderRefund>? orders_refunds;
  List<GrowthRate>? orders_refundsAnalysis;
  int? orders_refunds_count;

  List<PurchasesRefund>? purchases_refunds;
  List<GrowthRate>? purchases_refundsAnalysis;
  int? purchases_refunds_count;

  List<CustomerRequestSize>? customers_request_sizes;
  List<GrowthRate>? customers_request_sizesAnalysis;
  int? customers_request_sizes_count;

  List<ReservationInvoice>? reservation_invoice;
  List<GrowthRate>? reservation_invoiceAnalysis;
  int? reservation_invoice_count;

  List<ProductInput>? products_inputs; //employee only
  List<GrowthRate>? products_inputsAnalysis;
  int? products_inputs_count;

  List<ProductOutput>? products_outputs; //employee only
  List<GrowthRate>? products_outputsAnalysis;
  int? products_outputs_count;

  List<Transfers>? transfers; //employee only
  List<GrowthRate>? transfersAnalysis;
  int? transfers_count;

  List<CargoTransporter>? cargo_transporters; //employee only
  List<GrowthRate>? cargo_transportersAnalysis;
  int? cargo_transporters_count;

  UserLists() : super();

  @override
  Map<String, dynamic> getMirrorFieldsNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "cut_requests": List<CutRequest>.empty(),
          "cut_requstesAnalysis": List<GrowthRate>.empty(),
          "cut_requests_count": 0,
          "orders": List<Order>.empty(),
          "ordersAnalysis": List<GrowthRate>.empty(),
          "orders_count": 0,
          "purchases": List<Purchases>.empty(),
          "purchasesAnalysis": List<GrowthRate>.empty(),
          "purchases_count": 0,
          "orders_refunds": List<OrderRefund>.empty(),
          "orders_refundsAnalysis": List<GrowthRate>.empty(),
          "orders_refunds_count": 0,
          "purchases_refunds_count": 0,
          "purchases_refunds": List<PurchasesRefund>.empty(),
          "purchases_refundsAnalysis": List<GrowthRate>.empty(),
          "customers_request_sizes": List<CustomerRequestSize>.empty(),
          "customers_request_sizesAnalysis": List<GrowthRate>.empty(),
          "customers_request_sizes_count": 0,
          "reservation_invoice": List<ReservationInvoice>.empty(),
          "reservation_invoiceAnalysis": List<GrowthRate>.empty(),
          "reservation_invoice_count": 0,
          "products_inputs": List<ProductInput>.empty(),
          "products_inputsAnalysis": List<GrowthRate>.empty(),
          "products_inputs_count": 0,
          "products_outputs": List<ProductOutput>.empty(),
          "products_outputsAnalysis": List<GrowthRate>.empty(),
          "products_outputs_count": 0,
          "transfers": List<Transfers>.empty(),
          "transfersAnalysis": List<GrowthRate>.empty(),
          "transfers_count": 0,
          "cargo_transporters": List<CargoTransporter>.empty(),
          "cargo_transportersAnalysis": List<GrowthRate>.empty(),
          "cargo_transporters_count": 0
        });
}
