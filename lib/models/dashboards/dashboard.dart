import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../users/user.dart';

class Dashboard extends User implements DashableInterface {
  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  @override
  List<ViewAbstract> getDashboardsItems(BuildContext context) {
    // TODO: implement getDashboardsItems
    throw UnimplementedError();
  }
}
