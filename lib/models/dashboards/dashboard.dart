import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import '../funds/money_funds.dart';
import '../users/balances/customer_terms.dart';
import '../users/user.dart';
import 'balance_due.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Dashboard extends User implements DashableInterface {
  //  List<CustomerTerms> notPayedCustomers;

  //  List<CustomerTerms> customerToPayNext;

  List<BalanceDue>? debitsDue;
  List<BalanceDue>? creditsDue;
  List<BalanceDue>? incomesDue;
  List<BalanceDue>? spendingsDue;
  List<BalanceDue>? debitsBalanceToday;
  List<BalanceDue>? creditsBalanceToday;
  List<BalanceDue>? incomesBalanceToday;
  List<BalanceDue>? spendingsBalanceToday;
  List<BalanceDue>? previousdebitsDue;
  List<BalanceDue>? previouscreditsDue;
  List<BalanceDue>? previousincomesDue;
  List<BalanceDue>? previousspendingsDue;
  //  @override
  //    DateObject? date;

  // // @PermissionField(table_name = "text_balance_due_previous")
  //  List<MoneyFunds> total;

  // // @PermissionField(table_name = "text_balance_due_previous")
  //  List<MoneyFunds> previousBalance;
  // // @PermissionField(table_name = "text_balance_due_today")
  //  List<MoneyFunds> todayBalance;

  // //  @PermissionField(table_name = "text_balance_due")
  //  List<MoneyFunds> balanceDue;

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  @override
  List<ViewAbstract> getDashboardsItems(BuildContext context) {
    // TODO: implement getDashboardsItems
    throw UnimplementedError();
  }
}
