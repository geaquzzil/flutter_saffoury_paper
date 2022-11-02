// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer()
  ..iD = json['iD'] as int
  ..login = json['login'] as bool?
  ..permission = json['permission'] as bool?
  ..response = json['response'] as int?
  ..phone = json['phone'] as String?
  ..password = json['password'] as String?
  ..userlevels = json['userlevels'] == null
      ? null
      : PermissionLevelAbstract.fromJson(
          json['userlevels'] as Map<String, dynamic>)
  ..setting = json['setting'] == null
      ? null
      : Setting.fromJson(json['setting'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..email = json['email'] as String?
  ..token = json['token'] as String?
  ..activated = json['activated'] as int?
  ..date = json['date'] as String?
  ..city = json['city'] as String?
  ..address = json['address'] as String?
  ..profile = json['profile'] as String?
  ..comments = json['comments'] as String?
  ..cut_requests = (json['cut_requests'] as List<dynamic>?)
      ?.map((e) => CutRequest.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cut_requests_count = json['cut_requests_count'] as int?
  ..orders = (json['orders'] as List<dynamic>?)
      ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
      .toList()
  ..orders_count = json['orders_count'] as int?
  ..purchases = (json['purchases'] as List<dynamic>?)
      ?.map((e) => Purchases.fromJson(e as Map<String, dynamic>))
      .toList()
  ..purchases_count = json['purchases_count'] as int?
  ..orders_refunds = (json['orders_refunds'] as List<dynamic>?)
      ?.map((e) => OrderRefund.fromJson(e as Map<String, dynamic>))
      .toList()
  ..orders_refunds_count = json['orders_refunds_count'] as int?
  ..purchases_refunds = (json['purchases_refunds'] as List<dynamic>?)
      ?.map((e) => PurchasesRefund.fromJson(e as Map<String, dynamic>))
      .toList()
  ..purchases_refunds_count = json['purchases_refunds_count'] as int?
  ..customers_request_sizes =
      (json['customers_request_sizes'] as List<dynamic>?)
          ?.map((e) => CustomerRequestSize.fromJson(e as Map<String, dynamic>))
          .toList()
  ..customers_request_sizes_count =
      json['customers_request_sizes_count'] as int?
  ..reservation_invoice = (json['reservation_invoice'] as List<dynamic>?)
      ?.map((e) => ReservationInvoice.fromJson(e as Map<String, dynamic>))
      .toList()
  ..reservation_invoice_count = json['reservation_invoice_count'] as int?
  ..products_inputs = (json['products_inputs'] as List<dynamic>?)
      ?.map((e) => ProductInput.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_inputs_count = json['products_inputs_count'] as int?
  ..products_outputs = (json['products_outputs'] as List<dynamic>?)
      ?.map((e) => ProductOutput.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_outputs_count = json['products_outputs_count'] as int?
  ..transfers = (json['transfers'] as List<dynamic>?)
      ?.map((e) => Transfers.fromJson(e as Map<String, dynamic>))
      .toList()
  ..transfers_count = json['transfers_count'] as int?
  ..cargo_transporters = (json['cargo_transporters'] as List<dynamic>?)
      ?.map((e) => CargoTransporter.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cargo_transporters_count = json['cargo_transporters_count'] as int?
  ..cash = json['cash'] as int?
  ..totalCredits = (json['totalCredits'] as num?)?.toDouble()
  ..totalDebits = (json['totalDebits'] as num?)?.toDouble()
  ..totalOrders = (json['totalOrders'] as num?)?.toDouble()
  ..totalPurchases = (json['totalPurchases'] as num?)?.toDouble()
  ..balance = (json['balance'] as num?)?.toDouble()
  ..employees = json['employees'] == null
      ? null
      : Employee.fromJson(json['employees'] as Map<String, dynamic>)
  ..ordersAnalysis = (json['ordersAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList()
  ..purchasesAnalysis = (json['purchasesAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList()
  ..transfersAnalysis = (json['transfersAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cut_requestsAnalysis = (json['cut_requestsAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_inputsAnalysis =
      (json['products_inputsAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
  ..products_outputsAnalysis =
      (json['products_outputsAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
  ..purchases_refundsAnalysis =
      (json['purchases_refundsAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
  ..orders_refundsAnalysis = (json['orders_refundsAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cargo_transportersAnalysis =
      (json['cargo_transportersAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
  ..transfersAnalysis = (json['transfersAnalysis'] as List<dynamic>?)
      ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'iD': instance.iD,
      'login': instance.login,
      'permission': instance.permission,
      'response': instance.response,
      'phone': instance.phone,
      'password': instance.password,
      'userlevels': instance.userlevels?.toJson(),
      'setting': instance.setting?.toJson(),
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'activated': instance.activated,
      'date': instance.date,
      'city': instance.city,
      'address': instance.address,
      'profile': instance.profile,
      'comments': instance.comments,
      'cut_requests': instance.cut_requests?.map((e) => e.toJson()).toList(),
      'cut_requests_count': instance.cut_requests_count,
      'orders': instance.orders?.map((e) => e.toJson()).toList(),
      'orders_count': instance.orders_count,
      'purchases': instance.purchases?.map((e) => e.toJson()).toList(),
      'purchases_count': instance.purchases_count,
      'orders_refunds':
          instance.orders_refunds?.map((e) => e.toJson()).toList(),
      'orders_refunds_count': instance.orders_refunds_count,
      'purchases_refunds':
          instance.purchases_refunds?.map((e) => e.toJson()).toList(),
      'purchases_refunds_count': instance.purchases_refunds_count,
      'customers_request_sizes':
          instance.customers_request_sizes?.map((e) => e.toJson()).toList(),
      'customers_request_sizes_count': instance.customers_request_sizes_count,
      'reservation_invoice':
          instance.reservation_invoice?.map((e) => e.toJson()).toList(),
      'reservation_invoice_count': instance.reservation_invoice_count,
      'products_inputs':
          instance.products_inputs?.map((e) => e.toJson()).toList(),
      'products_inputs_count': instance.products_inputs_count,
      'products_outputs':
          instance.products_outputs?.map((e) => e.toJson()).toList(),
      'products_outputs_count': instance.products_outputs_count,
      'transfers': instance.transfers?.map((e) => e.toJson()).toList(),
      'transfers_count': instance.transfers_count,
      'cargo_transporters':
          instance.cargo_transporters?.map((e) => e.toJson()).toList(),
      'cargo_transporters_count': instance.cargo_transporters_count,
      'cash': instance.cash,
      'totalCredits': instance.totalCredits,
      'totalDebits': instance.totalDebits,
      'totalOrders': instance.totalOrders,
      'totalPurchases': instance.totalPurchases,
      'balance': instance.balance,
      'employees': instance.employees?.toJson(),
    };
