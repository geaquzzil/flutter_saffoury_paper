// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_customer_dashboard_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintCustomerDashboardSetting _$PrintCustomerDashboardSettingFromJson(
        Map<String, dynamic> json) =>
    PrintCustomerDashboardSetting()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
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
      ..currentGroupNameIndex = json['currentGroupNameIndex'] as int?
      ..currentGroupList = json['currentGroupList'] as List<dynamic>?
      ..hideInfoHeader = json['hideInfoHeader'] as bool?
      ..hideTotalFooter = json['hideTotalFooter'] as bool?
      ..hideCurrency = json['hideCurrency'] as bool?
      ..showAsDetails = json['showAsDetails'] as bool?
      ..includePreviousBalance = json['includePreviousBalance'] as bool?
      ..currency = json['currency'] == null
          ? null
          : Currency.fromJson(json['currency'] as Map<String, dynamic>)
      ..hideCustomerTerms = json['hideCustomerTerms'] as bool?;

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
      'hideCustomerTerms': instance.hideCustomerTerms,
    };
