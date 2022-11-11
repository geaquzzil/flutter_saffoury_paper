import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/view/view_view_abstract.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../base_shared_actions_header.dart';

class BaseSharedDetailsView extends StatefulWidget {
  const BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  State<BaseSharedDetailsView> createState() => _BaseSharedDetailsViewState();
}

class _BaseSharedDetailsViewState extends State<BaseSharedDetailsView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
      switch (actionViewAbstractProvider.getServerActions) {
        case ServerActions.edit:
          debugPrint("ServerActions.edit ${viewAbstract.runtimeType} ");
          return Scaffold(
              body: BaseEditPageNew(
            onValidate: (viewAbstract) {
              debugPrint("BaseSharedDetailsView onValidate=> $viewAbstract");
            },
            viewAbstract: viewAbstract,
            isTheFirst: true,
            // onSubmit: (obj) {
            //   if (obj != null) {
            //     debugPrint("baseEditPage onSubmit $obj");
            //   }
            // },
          ));
        case ServerActions.view:
          return wrapHeaderAndFooter(
              MasterView(viewAbstract: viewAbstract), viewAbstract);
        default:
          return MasterHomeHorizontal(viewAbstract: viewAbstract);
      }
    }
  }

  Widget wrapHeaderAndFooter(Widget main, ViewAbstract viewAbstract) {
    return Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.loose,
        children: [
          Column(
            children: [
              BaseSharedHeaderViewDetailsActions(
                viewAbstract: viewAbstract,
              ),
              Expanded(child: main)
            ],
          ),
          if (viewAbstract is CartableProductItemInterface)
            BottomWidgetOnViewIfCartable(
                viewAbstract: viewAbstract as CartableProductItemInterface)
          else
            BottomWidgetOnViewIfViewAbstract(viewAbstract: viewAbstract)
        ]);
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
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
