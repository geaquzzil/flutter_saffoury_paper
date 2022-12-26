import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_screens/filterables/custom_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/filterables/master_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseFilterableMainWidget extends StatelessWidget {
  bool useDraggableWidget;
  bool setHeaderTitle;
  Function()? onDoneCliced;
  BaseFilterableMainWidget(
      {super.key,
      this.useDraggableWidget = false,
      this.setHeaderTitle = true,
      this.onDoneCliced});

  @override
  Widget build(BuildContext context) {
    ViewAbstract drawerViewAbstract =
        context.watch<DrawerViewAbstractListProvider>().getObject;

    return FutureBuilder(
        future: context
            .read<FilterableListApiProvider<FilterableData>>()
            .getServerData(drawerViewAbstract),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getListFilterableControlers(context, drawerViewAbstract);
          }
          return Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json");
        }));
  }

  Widget getListFilterableControlers(
      BuildContext context, ViewAbstract drawerViewAbstract) {
    Map<ViewAbstract, List<dynamic>> list = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getRequiredFiltter;
    if (useDraggableWidget) {
      return getDraggableWidget(context, list, drawerViewAbstract);
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            if (setHeaderTitle) getHeader(context, drawerViewAbstract),
            if (SizeConfig.isMobile(context) && (setHeaderTitle)) Divider(),
            Expanded(
              child: getControllers(list, drawerViewAbstract, context),
            ),
            Divider(),
            getButtons(context)
          ],
        ),
      ),
    );
  }

  ListView getControllers(Map<ViewAbstract<dynamic>, List<dynamic>> list,
      ViewAbstract<dynamic> drawerViewAbstract, BuildContext context,
      {ScrollController? scrollController}) {
    return ListView(
      children: [
        ListView.builder(
          controller: scrollController,
          // separatorBuilder: (context, index) {
          //   return const Divider();
          // },
          itemCount: list.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            ViewAbstract viewAbstract = list.keys.elementAt(index);
            List<dynamic> itemsViewAbstract = list[viewAbstract] ?? [];
            debugPrint(
                "getListFilterableControlers is => ${viewAbstract.runtimeType.toString()} count is ${itemsViewAbstract.length}");
            return MasterFilterableController(
                viewAbstract: viewAbstract, list: itemsViewAbstract);
          },
        ),
        ListView.builder(
            itemCount:
                drawerViewAbstract.getCustomFilterableFields(context).length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return CustomFilterableController(
                  customFilterableField: drawerViewAbstract
                      .getCustomFilterableFields(context)[index]);
            }),
      ],
    );
  }

  Row getButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          child: const Text("DONE"),
          onPressed: () {
            if (onDoneCliced != null) {
              onDoneCliced!();
              return;
            }
            notifyListApi(context);
            if (SizeConfig.isMobile(context)) {
              Navigator.pop(context);
            }
            // Navigator.pop(context);
            // debugPrint(context.read<FilterableProvider>().getList.toString());
          },
        )
      ],
    );
  }

  Widget getHeader(
      BuildContext context, ViewAbstract<dynamic> drawerViewAbstract) {
    if (SizeConfig.isMobile(context)) {
      return ListTile(
        leading: Badge(
          badgeColor: Theme.of(context).colorScheme.primary,
          badgeContent: Text(
            context.watch<FilterableProvider>().getList.length.toString(),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          toAnimate: true,
          showBadge: context.watch<FilterableProvider>().getList.length > 0,
          animationType: BadgeAnimationType.slide,
          child: Icon(Icons.filter_alt),
        ),
        title: getTitle(context, drawerViewAbstract),
      );
    }
    return Card(
      child: ListTile(
        leading: Badge(
          badgeColor: Theme.of(context).colorScheme.primary,
          badgeContent: Text(
            context.watch<FilterableProvider>().getList.length.toString(),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          toAnimate: true,
          showBadge: context.watch<FilterableProvider>().getList.length > 0,
          animationType: BadgeAnimationType.slide,
          child: Icon(Icons.filter_alt),
        ),
        title: getTitle(context, drawerViewAbstract),
      ),
    );
  }

  Text getTitle(BuildContext context, ViewAbstract v) => Text(
      "${AppLocalizations.of(context)!.filter} ${v.getMainHeaderLabelTextOnly(context).toLowerCase()}");

  Widget getDraggableWidget(BuildContext context,
      Map<ViewAbstract, List<dynamic>> list, ViewAbstract drawerViewAbstract) {
    return Scaffold(
      appBar: AppBar(title: getHeader(context, drawerViewAbstract)),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          initialChildSize: .3,
          builder: (BuildContext context, ScrollController scrollController) {
            return getControllers(list, drawerViewAbstract, context,
                scrollController: scrollController);
          },
        ),
      ),
    );
  }
}
