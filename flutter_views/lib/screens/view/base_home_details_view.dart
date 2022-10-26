import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/listable_data_table_builder.dart';
import 'package:flutter_view_controller/new_components/lists/search_card_item.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:flutter_view_controller/screens/view/view_stand_alone.dart';
import 'package:flutter_view_controller/screens/view/view_view_abstract.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseSharedDetailsView extends StatefulWidget {
  const BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  State<BaseSharedDetailsView> createState() => _BaseSharedDetailsViewState();
}

class _BaseSharedDetailsViewState extends State<BaseSharedDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> tabs = [];
  @override
  void initState() {
    super.initState();
    ActionViewAbstractProvider abstractProvider =
        Provider.of<ActionViewAbstractProvider>(context, listen: false);
    tabs.addAll(abstractProvider.getObject?.getTabs(context) ?? []);
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    ActionViewAbstractProvider actionViewAbstractProvider =
        context.watch<ActionViewAbstractProvider>();

    ViewAbstract? viewAbstract = actionViewAbstractProvider.getObject;
    Widget? customWidget = actionViewAbstractProvider.getCustomWidget;

    if (customWidget != null) {
      return Center(
        child: customWidget,
      );
    } else if (viewAbstract == null) {
      return Scaffold(body: getEmptyView(context));
    } else {
      tabs.clear();
      tabs.addAll(viewAbstract.getTabs(context));
      // if (viewAbstract is ViewAbstractStandAloneCustomView) {
      //   return Center(
      //     child: MasterViewStandAlone(viewAbstract: viewAbstract),
      //   );
      // }
      switch (actionViewAbstractProvider.getServerActions) {
        case ServerActions.edit:
          return Scaffold(body: BaseEditPage(parent: viewAbstract));
        case ServerActions.view:
          return MasterView(viewAbstract: viewAbstract);
        default:
          return MasterHomeHorizontal(viewAbstract: viewAbstract);
      }
    }
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}

class MasterHomeHorizontal extends StatelessWidget {
  ViewAbstract viewAbstract;
  MasterHomeHorizontal({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: viewAbstract.getHorizotalList(context)));
  }
}
