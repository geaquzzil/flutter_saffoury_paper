import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class BaseDetailsPage extends StatefulWidget {
  const BaseDetailsPage({super.key});

  @override
  State<BaseDetailsPage> createState() => _BaseDetailsPageState();
}

class _BaseDetailsPageState extends State<BaseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BaseSharedDetailsView extends StatelessWidget {
  ViewAbstract? viewAbstract;
  ServerActions? action;
  BaseSharedDetailsView({super.key, this.viewAbstract, this.action});

  @override
  Widget build(BuildContext context) {
    return Selector<ActionViewAbstractProvider, Tuple2<ViewAbstract?, Widget?>>(
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

        if (value.item1 == null) {
          Widget? customWidget = value.item2;
          if (customWidget != null) {
            currentWidget = customWidget;
          } else {
            // Widget? currentWidget;

            currentWidget = Scaffold(body: getEmptyView(context));
          }
        } else {
          switch (actionViewAbstractProvider.getServerActions) {
            case ServerActions.edit:
              currentWidget = Container(
                key: UniqueKey(),
                // color: Theme.of(context).colorScheme.background,
                child: Card(
                  child: BaseEditNewPage(
                    viewAbstract: value.item1!,
                  ),
                ),
              );
              break;
            case ServerActions.view:
              currentWidget = Container(
                  // margin: EdgeInsets.all(20),
                  key: UniqueKey(),
                  color: Theme.of(context).colorScheme.surface,
                  child: Card(
                    child: BaseViewNewPage(
                      viewAbstract: value.item1!,
                    ),
                  ));
              break;
            default:
              currentWidget = MasterHomeHorizontal(viewAbstract: value.item1!);
              break;
          }
        }
        return AnimatedSwitcher(
          // key: UniqueKey(),
          duration: const Duration(milliseconds: 250),
          child: currentWidget,
        );
      },
      selector: (p0, p1) => Tuple2(p1.getObject, p1.getCustomWidget),
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
  MasterHomeHorizontal({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: viewAbstract.getHomeHorizotalList(context)));
  }
}
