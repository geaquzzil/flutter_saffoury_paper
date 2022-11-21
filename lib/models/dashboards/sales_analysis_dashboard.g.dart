// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_analysis_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesAnalysisDashboard _$SalesAnalysisDashboardFromJson(
        Map<String, dynamic> json) =>
    SalesAnalysisDashboard()
      ..iD = json['iD'] as int
      ..searchByAutoCompleteTextInput =
          json['searchByAutoCompleteTextInput'] as String?
      ..delete = json['delete'] as bool?
      ..date = json['date'] == null
          ? null
          : DateObject.fromJson(json['date'] as Map<String, dynamic>)
      ..bestSellingSize = (json['bestSellingSize'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList()
      ..bestSellingGSM = (json['bestSellingGSM'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList()
      ..bestSellingTYPE = (json['bestSellingTYPE'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList()
      ..bestProfitableType = (json['bestProfitableType'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalSalesQuantity = (json['totalSalesQuantity'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalSalesQuantityAnalysis =
          (json['totalSalesQuantityAnalysis'] as List<dynamic>?)
              ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..totalReturnsQuantity = (json['totalReturnsQuantity'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalReturnsQuantityAnalysis =
          (json['totalReturnsQuantityAnalysis'] as List<dynamic>?)
              ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..totalNetSalesQuantity =
          (json['totalNetSalesQuantity'] as List<dynamic>?)
              ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..totalNetSalesQuantityAnalysis =
          (json['totalNetSalesQuantityAnalysis'] as List<dynamic>?)
              ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..wastesQuantity = (json['wastesQuantity'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..wastesQuantityAnalysis =
          (json['wastesQuantityAnalysis'] as List<dynamic>?)
              ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..profits = (json['profits'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..profitsAnalysis = (json['profitsAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..incomesDue = (json['incomesDue'] as List<dynamic>?)
          ?.map((e) => AccountNamesBalance.fromJson(e as Map<String, dynamic>))
          .toList()
      ..spendingsDue = (json['spendingsDue'] as List<dynamic>?)
          ?.map((e) => AccountNamesBalance.fromJson(e as Map<String, dynamic>))
          .toList()
      ..wastes = (json['wastes'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..wastesAnalysis = (json['wastesAnalysis'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList()
      ..netProfit = (json['netProfit'] as List<dynamic>?)
          ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SalesAnalysisDashboardToJson(
        SalesAnalysisDashboard instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'date': instance.date?.toJson(),
      'bestSellingSize':
          instance.bestSellingSize?.map((e) => e.toJson()).toList(),
      'bestSellingGSM':
          instance.bestSellingGSM?.map((e) => e.toJson()).toList(),
      'bestSellingTYPE':
          instance.bestSellingTYPE?.map((e) => e.toJson()).toList(),
      'bestProfitableType':
          instance.bestProfitableType?.map((e) => e.toJson()).toList(),
      'totalSalesQuantity':
          instance.totalSalesQuantity?.map((e) => e.toJson()).toList(),
      'totalSalesQuantityAnalysis':
          instance.totalSalesQuantityAnalysis?.map((e) => e.toJson()).toList(),
      'totalReturnsQuantity':
          instance.totalReturnsQuantity?.map((e) => e.toJson()).toList(),
      'totalReturnsQuantityAnalysis': instance.totalReturnsQuantityAnalysis
          ?.map((e) => e.toJson())
          .toList(),
      'totalNetSalesQuantity':
          instance.totalNetSalesQuantity?.map((e) => e.toJson()).toList(),
      'totalNetSalesQuantityAnalysis': instance.totalNetSalesQuantityAnalysis
          ?.map((e) => e.toJson())
          .toList(),
      'wastesQuantity':
          instance.wastesQuantity?.map((e) => e.toJson()).toList(),
      'wastesQuantityAnalysis':
          instance.wastesQuantityAnalysis?.map((e) => e.toJson()).toList(),
      'profits': instance.profits?.map((e) => e.toJson()).toList(),
      'profitsAnalysis':
          instance.profitsAnalysis?.map((e) => e.toJson()).toList(),
      'incomesDue': instance.incomesDue?.map((e) => e.toJson()).toList(),
      'spendingsDue': instance.spendingsDue?.map((e) => e.toJson()).toList(),
      'wastes': instance.wastes?.map((e) => e.toJson()).toList(),
      'wastesAnalysis':
          instance.wastesAnalysis?.map((e) => e.toJson()).toList(),
      'netProfit': instance.netProfit?.map((e) => e.toJson()).toList(),
    };
