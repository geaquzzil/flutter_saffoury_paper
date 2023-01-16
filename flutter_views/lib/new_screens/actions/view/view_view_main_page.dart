import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/base_action_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../new_components/cards/outline_card.dart';
import '../../lists/list_static_editable.dart';
import '../../../providers/actions/list_multi_key_provider.dart';

import 'package:nil/nil.dart';

class BaseViewNewPage extends BaseActionScreenPage {
  BaseViewNewPage({super.key, required super.viewAbstract}) : super();

  @override
  State<BaseActionScreenPage> createState() => _BaseViewNewPage();
}

class _BaseViewNewPage extends BaseActionScreenPageState {
  @override
  Widget getBody(BuildContext context) {
    return MasterView(viewAbstract: getExtras() as ViewAbstract);
  }

  @override
  List<Widget>? getFloatingActionWidgetAddOns(BuildContext context) {
    return [getAddFloatingButton2(context)];
  }

  FloatingActionButton getAddFloatingButton2(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: UniqueKey(),
        onPressed: () async {},
        icon: Icon(Icons.edit),
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
