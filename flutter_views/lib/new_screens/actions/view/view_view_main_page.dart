import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseViewNewPage extends BaseActionScreenPage {
  BaseViewNewPage({super.key, required super.viewAbstract}) : super();

  @override
  State<BaseActionScreenPage> createState() => _BaseViewNewPage();
}

class _BaseViewNewPage extends BaseActionScreenPageState {
  @override
  Widget getBody(BuildContext context) {
    return MasterView(viewAbstract: getExtras());
  }

  @override
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context) {
    return [getAddFloatingButton2(context)];
  }

  FloatingActionButton getAddFloatingButton2(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: () async {},
        icon: const Icon(Icons.edit),
        label: Text(AppLocalizations.of(context)!.edit));
  }

  @override
  Widget? getSliverImageBackground(BuildContext context) {
    return null;
  }

  @override
  bool getBodyIsSliver() {
    return true;
  }
}
