import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/chart_records.dart';
import 'package:flutter_view_controller/models/apis/unused_records.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
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
  List<String> getMainFields({BuildContext? context}) => [
    "customers",
    "employees",
    "date",
    "value",
    "equalities",
    "warehouse",
  ];

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
  List<Widget>? getHomeListHeaderWidgetList(BuildContext context) {
    return [
      SliverApiMixinViewAbstractWidget(
        scrollDirection: Axis.horizontal,
        toListObject: UnusedRecords.init(this),
      ),
    ];
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Credits fromJsonViewAbstract(Map<String, dynamic> json) =>
      Credits.fromJson(json);

  @override
  List<TabControllerHelper> getCustomTabList(
    BuildContext context, {
    ServerActions? action,
    SecoundPaneHelperWithParentValueNotifier? basePage,
  }) {
    return [
      TabControllerHelper(
              titleFunction:(context) =>AppLocalizations.of(context)!.findSimilar,
        // titleFunction: (context) => AppLocalizations.of(context)!.findSimilar,
        widget: SliverApiMixinViewAbstractWidget(
          toListObject: Credits().setRequestOption(
            option: RequestOptions()
                .addSearchByField("CustomerID", customers?.iD)
                .addRequestObjcets(true),
          ),
          isSliver: true,
        ),
      ),
      TabControllerHelper(
             titleFunction:(context) => AppLocalizations.of(context)!.size_analyzer,
        // titleFunction: (context) => AppLocalizations.of(context)!.size_analyzer,
        widget: StorageDetailsCustom(
          chart: SliverApiMixinViewAbstractWidget(
            onResponseAddCustomWidget: ((isSliver, _, _, response) {
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
              //       trailing: const Text("SYP"),
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
            }),
            toListObject: ChartRecordAnalysis.init(
              Credits(),
              enteryInteval: EnteryInteval.monthy,
              customRequestOption: RequestOptions()
                  .addGroupBy("CustomerID")
                  .addSearchByField("CustomerID", customers?.iD),
            ),
          ),
        ),
      ),
    ];
  }
}
