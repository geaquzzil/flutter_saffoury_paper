import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../screens/action_screens/edit_details_page.dart';

class BaseSharedDetailsView extends StatelessWidget {
  BaseSharedDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ActionViewAbstractProvider, ViewAbstract?>(
      builder: (context, value, child) {
        ActionViewAbstractProvider actionViewAbstractProvider =
            context.read<ActionViewAbstractProvider>();

        // ViewAbstract? viewAbstract = actionViewAbstractProvider.getObject;
        // // if (viewAbstract != null)
        // //   return MasterHomeHorizontal(
        // //     viewAbstract: viewAbstract,
        // //   );
        // Widget? customWidget = actionViewAbstractProvider.getCustomWidget;
        // Widget? currentWidget;
        // if (customWidget != null) {
        //   currentWidget = Center(
        //     child: customWidget,
        //   );
        // }
        // else
        Widget? currentWidget;
        if (value == null) {
          currentWidget = Scaffold(body: getEmptyView(context));
        } else {
          switch (actionViewAbstractProvider.getServerActions) {
            case ServerActions.edit:
              currentWidget = Container(
                key: UniqueKey(),
                color: Theme.of(context).colorScheme.background,
                child: BaseEditNewPage(
                  viewAbstract: value,
                ),
              );
              break;
            case ServerActions.view:
              currentWidget = Container(
                  key: UniqueKey(),
                  color: Theme.of(context).colorScheme.background,
                  child: BaseViewNewPage(
                    viewAbstract: value,
                  ));
              break;
            default:
              currentWidget = MasterHomeHorizontal(viewAbstract: value);
              break;
          }
        }
        return AnimatedSwitcher(
          // key: UniqueKey(),
          duration: Duration(milliseconds: 250),
          child: currentWidget,
        );
      },
      selector: (p0, p1) => p1.getObject,
    );
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      key: UniqueKey(),
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
            children: viewAbstract.getHomeHorizotalList(context)));
  }
}
