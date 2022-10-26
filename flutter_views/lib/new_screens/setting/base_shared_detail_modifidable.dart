import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseSettingDetailsView extends StatefulWidget {
  const BaseSettingDetailsView({Key? key}) : super(key: key);

  @override
  State<BaseSettingDetailsView> createState() => _BaseModifadableState();
}

class _BaseModifadableState extends State<BaseSettingDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    ModifiableInterface? settingObject =
        context.watch<SettingProvider>().getSelectedObject;
    if (settingObject == null) {
      return getEmptyView(context);
    }
    return BaseEditPage(
      parent: settingObject.getModifibleSettingObject(context),
    );
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets4.lottiefiles.com/packages/lf20_gjvlmbzr.json"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget getBodyView(BuildContext context, ViewAbstract viewAbstract) {
    return Container(
      color: Colors.grey,
      child: Expanded(
        flex: 2,
        child: Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
            // fit: BoxFit.contain,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseSharedHeaderViewDetailsActions(
                    viewAbstract: viewAbstract,
                  ),
                  ViewDetailsListWidget(
                    viewAbstract: viewAbstract,
                  ),
                  if (viewAbstract is CartableInvoiceMasterObjectInterface)
                    CartDataTableMaster(
                        action: ServerActions.view,
                        obj: viewAbstract
                            as CartableInvoiceMasterObjectInterface),
                  if (viewAbstract.getTabs(context).isNotEmpty)
                    TabBarWidget(
                      viewAbstract: viewAbstract,
                    )
                ],
              ),
            ]),
      ),
    );
  }
}
