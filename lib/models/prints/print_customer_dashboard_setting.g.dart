// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_customer_dashboard_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintCustomerDashboardSetting _$PrintCustomerDashboardSettingFromJson(
        Map<String, dynamic> json) =>
    PrintCustomerDashboardSetting()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..printerOptions = json['printerOptions'] == null
          ? null
          : PrinterOptions.fromJson(
              json['printerOptions'] as Map<String, dynamic>)
      ..reportOptions = json['reportOptions'] == null
          ? null
          : ReportOptions.fromJson(
              json['reportOptions'] as Map<String, dynamic>)
      ..hideQrCode = json['hideQrCode'] as bool?
      ..primaryColor = json['primaryColor'] as String?
      ..secondaryColor = json['secondaryColor'] as String?
      ..hasMultiplePageFormats = json['hasMultiplePageFormats'] as bool?
      ..hideTermsOfService = json['hideTermsOfService'] as bool?
      ..hideAdditionalNotes = json['hideAdditionalNotes'] as bool?
      ..hideHeaderLogo = json['hideHeaderLogo'] as bool?
      ..currentGroupNameFromList = json['currentGroupNameFromList'] as String?
      ..currentGroupNameIndex = (json['currentGroupNameIndex'] as num?)?.toInt()
      ..currentGroupList = json['currentGroupList'] as List<dynamic>?
      ..hideInfoHeader = json['hideInfoHeader'] as bool?
      ..hideTotalFooter = json['hideTotalFooter'] as bool?
      ..hideCurrency = json['hideCurrency'] as bool?
      ..showAsDetails = json['showAsDetails'] as bool?
      ..includePreviousBalance = json['includePreviousBalance'] as bool?
      ..currency = json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>)
      ..dashboardPrintType = $enumDecodeNullable(
          _$PrintDashboardTypeEnumMap, json['dashboardPrintType'])
      ..hideCustomerTerms = json['hideCustomerTerms'] as bool?
      ..hideCustomersNotCreditsInvoices =
          json['hideCustomersNotCreditsInvoices'] as bool?;

Map<String, dynamic> _$PrintCustomerDashboardSettingToJson(
        PrintCustomerDashboardSetting instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'printerOptions': instance.printerOptions?.toJson(),
      'reportOptions': instance.reportOptions?.toJson(),
      'hideQrCode': instance.hideQrCode,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'hasMultiplePageFormats': instance.hasMultiplePageFormats,
      'hideTermsOfService': instance.hideTermsOfService,
      'hideAdditionalNotes': instance.hideAdditionalNotes,
      'hideHeaderLogo': instance.hideHeaderLogo,
      'currentGroupNameFromList': instance.currentGroupNameFromList,
      'currentGroupNameIndex': instance.currentGroupNameIndex,
      'currentGroupList': instance.currentGroupList,
      'hideInfoHeader': instance.hideInfoHeader,
      'hideTotalFooter': instance.hideTotalFooter,
      'hideCurrency': instance.hideCurrency,
      'showAsDetails': instance.showAsDetails,
      'includePreviousBalance': instance.includePreviousBalance,
      'currency': instance.currency?.toJson(),
      'dashboardPrintType':
          _$PrintDashboardTypeEnumMap[instance.dashboardPrintType],
      'hideCustomerTerms': instance.hideCustomerTerms,
      'hideCustomersNotCreditsInvoices':
          instance.hideCustomersNotCreditsInvoices,
    };

const _$PrintDashboardTypeEnumMap = {
  PrintDashboardType.ALL: 'ALL',
  PrintDashboardType.DAILY_INVOICE_ONLY: 'DAILY_INVOICE_ONLY',
  PrintDashboardType.MONEY_FUND_ONLY: 'MONEY_FUND_ONLY',
};
