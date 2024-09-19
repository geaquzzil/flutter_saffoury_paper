import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/filterables/custom_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/filterables/master_list_filterable.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseFilterableMainWidget extends StatelessWidget {
  bool useDraggableWidget;
  bool setHeaderTitle;
  ViewAbstract? viewAbstract;
  Function()? onDoneClickedPopResults;
  BaseFilterableMainWidget(
      {super.key,
      this.useDraggableWidget = false,
      this.setHeaderTitle = true,
      this.viewAbstract,
      this.onDoneClickedPopResults});

  @override
  Widget build(BuildContext context) {
    if (viewAbstract != null) {
      return FutureBuilder(
          future: context
              .read<FilterableListApiProvider<FilterableData>>()
              .getServerData(viewAbstract!),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return getListFilterableControlers(context, viewAbstract!);
            }
            return Lottie.network(
                "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json");
          }));
    }
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) {
        return FutureBuilder(
            future: context
                .read<FilterableListApiProvider<FilterableData>>()
                .getServerData(value),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return getListFilterableControlers(context, value);
              }
              return Lottie.network(
                  "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json");
            }));
      },
      selector: (p0, p1) => p1.getObjectCastViewAbstract,
    );
  }

  Widget getListFilterableControlers(
      BuildContext context, ViewAbstract drawerViewAbstract) {
    Map<ViewAbstract, List<dynamic>> list = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getRequiredFiltter;
    if (useDraggableWidget) {
      return getDraggableWidget(context, list, drawerViewAbstract);
    }
    if (onDoneClickedPopResults != null) {
      return Scaffold(
        body: _getBody(context, drawerViewAbstract, list),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .pop(context.read<FilterableProvider>().getList);
          },
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          icon: const Icon(Icons.arrow_forward),
          label: Text(AppLocalizations.of(context)!.subment),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
    return _getBody(context, drawerViewAbstract, list);
  }

  CustomScrollView _getBody(
      BuildContext context,
      ViewAbstract<dynamic> drawerViewAbstract,
      Map<ViewAbstract<dynamic>, List<dynamic>> list) {
    return CustomScrollView(
      slivers: [
        if (setHeaderTitle)
          SliverToBoxAdapter(
            child: getHeader(context, drawerViewAbstract),
          ),
        if (SizeConfig.isMobile(context) && (setHeaderTitle))
          const SliverToBoxAdapter(child: Divider()),
        ...getControllersSliver(list, drawerViewAbstract, context),

        // SliverFillRemaining(child: getButtons(context),)
      ],
    );
  }

  List<Widget> getControllersSliver(
      Map<ViewAbstract<dynamic>, List<dynamic>> list,
      ViewAbstract<dynamic> drawerViewAbstract,
      BuildContext context,
      {ScrollController? scrollController}) {
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          ViewAbstract viewAbstract = list.keys.elementAt(index);
          List<dynamic> itemsViewAbstract = list[viewAbstract] ?? [];
          debugPrint(
              "getListFilterableControlers is => ${viewAbstract.runtimeType.toString()} count is ${itemsViewAbstract.length}");
          return MasterFilterableController(
              viewAbstract: viewAbstract, list: itemsViewAbstract);
        }, childCount: list.length)),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return CustomFilterableController(
              customFilterableField:
                  drawerViewAbstract.getCustomFilterableFields(context)[index]);
        },
                childCount: drawerViewAbstract
                    .getCustomFilterableFields(context)
                    .length)),
      ),
    ];
  }

  Widget getControllers(Map<ViewAbstract<dynamic>, List<dynamic>> list,
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
            if (onDoneClickedPopResults != null) {
              onDoneClickedPopResults!();
              Navigator.of(context)
                  .pop(context.read<FilterableProvider>().getList);
              return;
            }
            // Navigator.pop(context);
            // debugPrint(context.read<FilterableProvider>().getList.toString());
          },
        )
      ],
    );
  }

  Widget getBadge(BuildContext context) {
    return Selector<FilterableProvider, int>(
      builder: (context, value, child) {
        return Badge(
        isLabelVisible: false,
        largeSize: 40,
        label: Text(
          value.toString(),
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        // badgeColor: Theme.of(context).colorScheme.primary,
        // badgeContent: Text(
        //   value.toString(),
        //   style: Theme.of(context)
        //       .textTheme
        //       .titleSmall!
        //       .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        // ),
        // toAnimate: true,
        // showBadge: value > 0,
        // animationType: BadgeAnimationType.slide,
        child: const Icon(Icons.filter_alt),
      );
      },
      selector: (p0, p1) => p1.getList.length,
    );
  }

  Widget getHeader(
      BuildContext context, ViewAbstract<dynamic> drawerViewAbstract) {
    if (SizeConfig.isMobile(context)) {
      return ListTile(
        leading: getBadge(context),
        title: getTitle(context, drawerViewAbstract),
      );
    }
    return Card(
      child: ListTile(
        leading: kIsWeb ? const BackButton() : getBadge(context),
        trailing: kIsWeb ? getBadge(context) : null,
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
