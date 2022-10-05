import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/users/user.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DashboardCustomer extends User
    implements DashableInterface<DashboardCustomer> {
  DashboardCustomer();

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  List<ViewAbstract> getDashboardsItems(BuildContext context) {
    // TODO: implement getDashboardsItems
    throw UnimplementedError();
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;
}
