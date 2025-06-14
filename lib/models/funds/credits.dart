import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_custom_view_horizontal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credits.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Credits extends MoneyFunds<Credits> {
  Credits() : super();

  @override
  Credits getSelfNewInstance() {
    return Credits();
  }

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["customers", "employees", "date", "value", "equalities", "warehouse"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.credits;
  @override
  IconData getMainIconData() => Icons.move_to_inbox_sharp;

  @override
  String? getTableNameApi() => "credits";

  factory Credits.fromJson(Map<String, dynamic> data) =>
      _$CreditsFromJson(data);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Credits fromJsonViewAbstract(Map<String, dynamic> json) =>
      Credits.fromJson(json);

  @override
  List<TabControllerHelper> getCustomTabList(BuildContext context,
      {ServerActions? action}) {
    return [
      TabControllerHelper(
        AppLocalizations.of(context)!.findSimilar,
        widget: ListApiAutoRestWidget(
          autoRest: AutoRest<Credits>(
              obj: Credits()
                ..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
              key: "CustomerByCredit$iD"),
        ),
      ),
      TabControllerHelper(
        AppLocalizations.of(context)!.size_analyzer,
        widget: StorageDetailsCustom(
          chart: ListHorizontalCustomViewApiAutoRestWidget(
              onResponseAddWidget: ((response) {
                ChartRecordAnalysis i = response as ChartRecordAnalysis;
                double total = i.getTotalListAnalysis();
                return Column(
                  children: [
                    // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
                    //     titleString: "TEST1 ",
                    //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
                    StorageInfoCardCustom(
                        title: AppLocalizations.of(context)!.total,
                        description: total.toCurrencyFormat(),
                        trailing: const Text("SYP"),
                        svgSrc: Icons.monitor_weight),
                    StorageInfoCardCustom(
                        title: AppLocalizations.of(context)!.balance,
                        description:
                            customers?.balance?.toCurrencyFormat() ?? "0",
                        trailing: const Text("trailing"),
                        svgSrc: Icons.balance),
                  ],
                );
              }),
              autoRest: ChartRecordAnalysis.init(
                  Credits(), DateObject(), EnteryInteval.monthy,
                  customAction: {"CustomerID": customers?.iD})),
        ),
      ),
    ];
  }
}
