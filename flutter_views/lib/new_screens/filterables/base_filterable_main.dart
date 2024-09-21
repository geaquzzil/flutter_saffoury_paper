import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/filterables/custom_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/filterables/master_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_list_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseFilterableMainWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  Function(dynamic v)? onDoneClickedPopResults;

  BaseFilterableMainWidget(
      {super.key, required this.viewAbstract, this.onDoneClickedPopResults});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: context
                .read<FilterableListApiProvider<FilterableData>>()
                .getServerData(viewAbstract),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return getSliverCustomScrollViewBody(context);
                } else {
                  EmptyWidget.error(
                    context,
                  );
                }
              }
              return const EmptyWidget(
                expand: true,
                lottiUrl:
                    "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json",
              );
            })),
      ),
    );
  }

  SliverCustomScrollView getSliverCustomScrollViewBody(BuildContext context) {
    return SliverCustomScrollView(
      scrollKey: 'bottomSheet',
      builderAppbar: (fullyCol, fullyExp) {
        return SliverAppBar.large(
            leading: CloseButton(),
            actions: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: fullyExp ? Container() : Text("2"),
              )
            ],
            title: getTitle(context));
      },
      slivers: [
        const SliverToBoxAdapter(child: Divider()),
        ...getControllersSliver(context)
      ],
    );
  }

  // Widget getListFilterableControlers(
  //     BuildContext context, ViewAbstract drawerViewAbstract) {
  //   Map<ViewAbstract, List<dynamic>> list = context
  //       .read<FilterableListApiProvider<FilterableData>>()
  //       .getRequiredFiltter;
  //   if (useDraggableWidget) {
  //     return getDraggableWidget(context, list, drawerViewAbstract);
  //   }
  //   if (onDoneClickedPopResults != null) {
  //     return Scaffold(
  //       body: _getBody(context, drawerViewAbstract, list),
  //       floatingActionButton: FloatingActionButton.extended(
  //         onPressed: () {
  //           Navigator.of(context)
  //               .pop(context.read<FilterableProvider>().getList);
  //         },
  //         isExtended: true,
  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //         icon: const Icon(Icons.arrow_forward),
  //         label: Text(AppLocalizations.of(context)!.subment),
  //       ),
  //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  //     );
  //   }
  //   return _getBody(context, drawerViewAbstract, list);
  // }

  List<Widget> getControllersSliver(BuildContext context,
      {ScrollController? scrollController}) {
    Map<ViewAbstract, List<dynamic>> list = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getRequiredFiltter;
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
                  viewAbstract.getCustomFilterableFields(context)[index]);
        }, childCount: viewAbstract.getCustomFilterableFields(context).length)),
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

  // Widget getHeader(
  //     BuildContext context, ViewAbstract<dynamic> drawerViewAbstract) {
  //   if (SizeConfig.isMobile(context)) {
  //     return ListTile(
  //       leading: getBadge(context),
  //       title: getTitle(context, drawerViewAbstract),
  //     );
  //   }
  //   return Card(
  //     child: ListTile(
  //       leading: kIsWeb ? const BackButton() : getBadge(context),
  //       trailing: kIsWeb ? getBadge(context) : null,
  //       title: getTitle(context, drawerViewAbstract),
  //     ),
  //   );
  // }

  Text getTitle(BuildContext context) => Text(
      "${AppLocalizations.of(context)!.filter} ${viewAbstract.getMainHeaderLabelTextOnly(context).toLowerCase()}");

  // Widget getDraggableWidget(BuildContext context,
  //     Map<ViewAbstract, List<dynamic>> list, ViewAbstract drawerViewAbstract) {
  //   return Scaffold(
  //     appBar: AppBar(title: getHeader(context, drawerViewAbstract)),
  //     body: SizedBox.expand(
  //       child: DraggableScrollableSheet(
  //         initialChildSize: .3,
  //         builder: (BuildContext context, ScrollController scrollController) {
  //           return getControllers(list, drawerViewAbstract, context,
  //               scrollController: scrollController);
  //         },
  //       ),
  //     ),
  //   );
  // }
}
