import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/view/view_view_abstract.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
          debugPrint("ServerActions.edit ${viewAbstract.runtimeType} ");
          return Scaffold(
              body: BaseEditPage(
            parent: viewAbstract,
            onSubmit: (obj) {
              if (obj != null) {
                debugPrint("baseEditPage onSubmit $obj");
              }
            },
          ));
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
