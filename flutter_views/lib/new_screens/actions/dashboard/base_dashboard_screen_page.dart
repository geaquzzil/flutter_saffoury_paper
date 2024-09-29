import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

final selectDateChanged = ValueNotifier<DateObject?>(null);

class BaseDashboard extends StatefulWidget {
  DashableInterface dashboard;
  String title;
  BaseDashboard({super.key, required this.dashboard, required this.title});

  @override
  State<BaseDashboard> createState() => _BaseDashboardState();
}

class _BaseDashboardState extends State<BaseDashboard>
    with TickerProviderStateMixin {
  Widget? firstPane;

  late ViewAbstract viewAbstract;

  late TabController _tabController;

  final List<TabControllerHelper> _tabs = <TabControllerHelper>[];

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              getAppBar(context, innerBoxIsScrolled),
              // SliverPersistentHeader(
              //     pinned: true,
              //     delegate: SliverAppBarDelegate(
              //         child:  DashboardHeader(
              //             current_screen_size: CurrentScreenSize.DESKTOP),
              //         minHeight: 70,
              //         maxHeight: 80)),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegatePreferedSize(
                    child: ColoredTabBar(
                      color: Theme.of(context).colorScheme.surface,
                      child: TabBar(
                        // labelColor: Colors.black,
                        tabs: _tabs,
                        controller: _tabController,
                      ),
                    ),
                  ))
            ],
        body: SafeArea(
          child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((e) => Builder(builder: (BuildContext context) {
                        int idex = _tabs.indexOf(e);
                        return idex == 0
                            ? getMainBody(context)
                            : const CustomScrollView(slivers: [
                                SliverFillRemaining(
                                  child: Text("TODO"),
                                )
                              ]);
                      }))
                  .toList()),
        ));
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
      stretchModes: const [StretchMode.fadeTitle],
      centerTitle: true,
      // titlePadding: const EdgeInsets.only(bottom: 62),
      title: ListTile(
        leading: const SizedBox(width: 20),
        title: viewAbstract.getMainLabelText(context),
      ),
    );
  }

  Widget getMainBody(BuildContext context) {
    return ValueListenableBuilder<DateObject?>(
        valueListenable: selectDateChanged,
        builder: (context, value, child) {
          widget.dashboard.setDate(value);
          init(context);
          return FutureBuilder(
            future: viewAbstract.callApi(context: context),
            builder: (context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.done) {
                  // debugPrint("DashboardPage ${viewAbstract.runtimeType}");
                  widget.dashboard = snapshot.data as DashableInterface;
                  init(context);
                  setTabbar();
                  var size = MediaQuery.of(context).size;
                  List<DashableGridHelper> list = widget.dashboard
                      .getDashboardSectionsFirstPane(context, 0);
                  List<Widget> widgets = List.empty(growable: true);
                  for (var element in list) {
                    var group = [
                      // DashableItemHeaderBuilder(
                      //   dgh: element,
                      // ),
                      SliverToBoxAdapter(
                        child: Responsive(
                          mobile: FileInfoStaggerdGridView(
                            list: element.widgets.map((e) => e.widget).toList(),
                            // crossAxisCount: size.width < 750 ? 2 : 4,
                            childAspectRatio:
                                size.width < 750 && size.width > 350 ? 1.3 : 1,
                          ),
                          tablet: FileInfoStaggerdGridView(
                            list: element.widgets.map((e) => e.widget).toList(),
                          ),
                          desktop: FileInfoStaggerdGridView(
                            list: element.widgets.map((e) => e.widget).toList(),
                            // crossAxisCount: 6,
                            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                          ),
                        ),
                      )
                    ];
                    widgets.addAll(group);
                  }
                  return CustomScrollView(
                    slivers: widgets,
                  );
                }
                return Center(
                  child: EmptyWidget(
                      lottiUrl:
                          "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json",
                      title: AppLocalizations.of(context)!.loading,
                      subtitle: AppLocalizations.of(context)!.pleaseWait),
                );
              } catch (e) {
                snapshot.error.printError();
                return Text(snapshot.error.toString());
              }
            },
          );
        });
  }

  Widget getFirstPane(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<DashableGridHelper> list =
        widget.dashboard.getDashboardSectionsFirstPane(context, 0);
    List<Widget> widgets = List.empty(growable: true);
    // widgets.add(
    //   getAppBar(context),
    // );
    // widgets.add(
    //   SliverPersistentHeader(
    //     pinned: true,
    //     delegate: SliverAppBarDelegate(
    //         child:  DashboardHeader(
    //             current_screen_size: CurrentScreenSize.DESKTOP),
    //         minHeight: 70,
    //         maxHeight: 80)));
    widgets.add(SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegatePreferedSize(
          child: ColoredTabBar(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              // labelColor: Colors.black,
              tabs: _tabs,
              controller: _tabController,
            ),
          ),
        )));
    for (var element in list) {
      var group = [
        // DashableItemHeaderBuilder(
        //   dgh: element,
        // ),
        SliverToBoxAdapter(
          child: Responsive(
            mobile: FileInfoStaggerdGridView(
              list: element.widgets.map((e) => e.widget).toList(),
              // crossAxisCount: size.width < 750 ? 2 : 4,
              childAspectRatio: size.width < 750 && size.width > 350 ? 1.3 : 1,
            ),
            tablet: FileInfoStaggerdGridView(
              list: element.widgets.map((e) => e.widget).toList(),
            ),
            desktop: FileInfoStaggerdGridView(
              list: element.widgets.map((e) => e.widget).toList(),
              // crossAxisCount: 6,
              childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
            ),
          ),
        )
        // SliverGrid(
        //     delegate: SliverChildBuilderDelegate(
        //       (context, index) => Container(
        //         color: Colors.cyan,
        //       ),
        //       childCount: element.widgets.length,
        //     ),
        //     gridDelegate: SliverQuiltedGridDelegate(
        //       crossAxisCount: 3,
        //       mainAxisSpacing: 4,
        //       crossAxisSpacing: 4,
        //       repeatPattern: QuiltedGridRepeatPattern.inverted,
        //       pattern: const [
        //         QuiltedGridTile(2, 1),
        //         QuiltedGridTile(2, 2),
        //         QuiltedGridTile(1, 1),
        //         QuiltedGridTile(1, 1),
        //         QuiltedGridTile(1, 1),
        //       ],
        //     ))
      ];
      widgets.addAll(group);
    }
    return CustomScrollView(slivers: widgets);
    // return CustomScrollView(
    //   slivers: [widgets[0],widgets[1],SliverFillRemaining(child: TabBarView(controller: _tabController,children: [],),)],
    // );
    // return SafeArea(
    //   child: TabBarView(
    //       controller: _tabController,
    //       children: _tabs
    //           .map((e) => Builder(builder: (BuildContext context) {
    //                 if (_tabs.indexOf(e) == 0) {
    //                   return CustomScrollView(slivers: widgets);
    //                 }
    //                 return CustomScrollView(slivers: [
    //                   widgets[0],
    //                   SliverFillRemaining(
    //                     child: e.widget!,
    //                   )
    //                 ]);
    //               }))
    //           .toList()),
    // );
    // return CustomScrollView(slivers: widgets);
  }

  Widget getAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar.large(
          pinned: false,
          floating: true,
          elevation: 4,
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          // automaticallyImplyLeading: false,
          actions: [Container()],
          // leading: SizedBox(),
          forceElevated: innerBoxIsScrolled,
          flexibleSpace: getSilverAppBarBackground(context),
        ));
  }

  Widget? getEndPane(BuildContext context) {
    return null;
  }

  @override
  void initState() {
    init(context);
    initTabbar();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BaseDashboard oldWidget) {
    if (!viewAbstract.isEquals(oldWidget.dashboard as ViewAbstract)) {
      viewAbstract = oldWidget.dashboard as ViewAbstract;
      initTabbar();
    }
    super.didUpdateWidget(oldWidget);
  }

  void init(BuildContext context) {
    viewAbstract = widget.dashboard as ViewAbstract;
  }

  Widget getWidget(BuildContext context) {
    firstPane ??= getFirstPane(context);
    return firstPane!;
  }

  void initTabbar() {
    _tabs.clear();
    _tabs.add(TabControllerHelper(widget.title));
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void setTabbar() {
    widget.dashboard
        .getDashboardSectionsFirstPane(context, 0)
        .where((element) => element.sectionsListToTabbar != null)
        .map((e) => e.sectionsListToTabbar)
        .forEach((element) {
      for (var e in element!) {
        _tabs.add(TabControllerHelper(
          e[0].getMainHeaderLabelTextOnly(context),
          widget: ListStaticSearchableWidget<ViewAbstract>(
              list: e,
              onSearchTextChanged: (query) => e,
              listItembuilder: (v) => ListCardItem(
                    object: v,
                  )),
        ));
      }
    });

    _tabController = TabController(length: _tabs.length, vsync: this);
  }
}

class SectionItemHeaderI extends MultiSliver {
  bool pinHeader;
  double pinHeaderPrefferedSize;
  SectionItemHeaderI(
      {super.key,
      required BuildContext context,
      required Widget title,
      required GlobalKey buttonKey,
      super.pushPinnedChildren = true,
      this.pinHeader = true,
      this.pinHeaderPrefferedSize = 80,
      Widget? child})
      : super(
          children: [
            
            if (pinHeader)
              SliverPinnedHeader(
                
                child: Container(

                    padding: const EdgeInsets.all(kDefaultPadding),
                    //todo
                    color: ElevationOverlay.colorWithOverlay(
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceBright,
                        10),
                    child: title),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(kDefaultPadding),
                sliver: SliverPersistentHeader(
                    pinned: false,
                    delegate: SliverAppBarDelegatePreferedSize(
                        shouldRebuildWidget: true,
                        child: PreferredSize(
                            preferredSize:
                                Size.fromHeight(pinHeaderPrefferedSize),
                            child: title))),
              ),
            SliverToBoxAdapter(
              child: child,
            )
          ],
        );
}

class SectionItemHeader extends MultiSliver {
  SectionItemHeader(
      {super.key,
      required BuildContext context,
      required DashableGridHelper dgh,
      required GlobalKey buttonKey,
      Widget? child})
      : super(
          pushPinnedChildren: true,
          children: [
            if (dgh.title != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                sliver: SliverPinnedHeader(
                    child: Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                            title: Text(
                              dgh.title!,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            trailing: dgh.headerListToAdd == null
                                ? null
                                : ElevatedButton.icon(
                                    key: buttonKey,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding * 1.5,
                                        vertical: kDefaultPadding / 2,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (dgh.headerListToAdd == null) return;
                                      await showPopupMenu(context, buttonKey,
                                              list: dgh.headerListToAdd!
                                                  .map((e) => buildMenuItem(
                                                      context,
                                                      MenuItemBuild(
                                                          e.getMainHeaderLabelTextOnly(
                                                              context),
                                                          Icons.add,
                                                          "")))
                                                  .toList())
                                          .then((value) => debugPrint(
                                              "showPopupMenu $value"));
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text(
                                        AppLocalizations.of(context)!.add_new),
                                  ))

                        //  Column(
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text(
                        //           dgh.title,
                        //           style: Theme.of(context).textTheme.titleLarge,
                        //         ),
                        //         if (dgh.headerListToAdd != null)
                        //           ElevatedButton.icon(
                        //             key: buttonKey,
                        //             style: TextButton.styleFrom(
                        //               padding: const EdgeInsets.symmetric(
                        //                 horizontal: kDefaultPadding * 1.5,
                        //                 vertical: kDefaultPadding / 2,
                        //               ),
                        //             ),
                        //             onPressed: () async {
                        //               if (dgh.headerListToAdd == null) return;
                        //               await showPopupMenu(context, buttonKey,
                        //                       list: dgh.headerListToAdd!
                        //                           .map((e) => buildMenuItem(
                        //                               context,
                        //                               MenuItemBuild(
                        //                                   e.getMainHeaderLabelTextOnly(
                        //                                       context),
                        //                                   Icons.add,
                        //                                   "")))
                        //                           .toList())
                        //                   .then((value) =>
                        //                       debugPrint("showPopupMenu $value"));
                        //             },
                        //             icon: const Icon(Icons.add),
                        //             label: Text(AppLocalizations.of(context)!.add_new),
                        //           ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        )),
              ),
            SliverToBoxAdapter(
              child: child,
            )
          ],
        );
}

// @deprecated
// class DashableItemHeaderBuilder extends StatelessWidget {
//   DashableGridHelper dgh;
//   DashableItemHeaderBuilder({Key? key, required this.dgh}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey buttonKey = GlobalKey();
//     return SliverPinnedHeader(
//       child: Text(dgh.title),
//     );
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: kDefaultPadding, vertical: kDefaultPadding),
//       sliver: SliverPersistentHeader(
//         floating: true,
//         pinned: true,

//         // floating: true,
//         delegate: SliverAppBarDelegate(

//             // 2
//             minHeight: 50,
//             maxHeight: 50,
//             // 3
//             child: Container(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         dgh.title,
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       ElevatedButton.icon(
//                         key: buttonKey,
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: kDefaultPadding * 1.5,
//                             vertical: kDefaultPadding / 2,
//                           ),
//                         ),
//                         onPressed: () async {
//                           if (dgh.headerListToAdd == null) return;
//                           await showPopupMenu(context, buttonKey,
//                                   list: dgh.headerListToAdd!
//                                       .map((e) => buildMenuItem(
//                                           context,
//                                           MenuItemBuild(
//                                               e.getMainHeaderLabelTextOnly(
//                                                   context),
//                                               Icons.add,
//                                               "")))
//                                       .toList())
//                               .then((value) =>
//                                   debugPrint("showPopupMenu $value"));
//                         },
//                         icon: const Icon(Icons.add),
//                         label: Text(AppLocalizations.of(context)!.add_new),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }

// class TicPackage extends StatelessWidget {
//   TicPackage(
//       {this.heroTag,
//       this.package,
//       this.onTap,
//       this.isSmall = false,
//       this.animation});

//   final String heroTag;
//   final Animation<double> ?animation;
//   final Package package;
//   final bool isSmall;
//   final Function() onTap;

//   final NumberFormat currencyFormatter =
//       NumberFormat.currency(locale: "nl", decimalDigits: 2, symbol: "€");

//   Widget _animationWidget({Widget child}) {
//     return animation != null
//         ? FadeTransition(
//             opacity: animation,
//             child: SizeTransition(
//                 axisAlignment: 1.0, sizeFactor: animation, child: child))
//         : !isSmall ? child : Container();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget eventCountText = _animationWidget(
//         child: Padding(
//             padding: EdgeInsets.only(bottom: 10),
//             child: Text("${package.eventCount} evenementen",
//                 style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))));

//     Widget goodsText = _animationWidget(
//       child: Padding(
//           padding: EdgeInsets.only(top: 12),
//           child: Text(package.goods,
//               style:
//                   TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
//     );

//     Widget discountText = _animationWidget(
//         child: Padding(
//             padding: EdgeInsets.only(top: 10),
//             child: Container(
//               child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   child: Text(
//                     "${currencyFormatter.format(package.discount)} korting",
//                     style: TextStyle(color: Colors.white),
//                   )),
//               decoration: BoxDecoration(
//                   border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.5)),
//                   borderRadius: BorderRadius.circular(100)),
//             )));

//     Widget titleText = Text(
//       package.name,
//       style: TextStyle(
//           color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//     );

//     Widget card = Card(
//         color: package.color,
//         borderRadius: BorderRadius.circular(10),
//         margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Stack(
//             children: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   eventCountText,
//                   titleText,
//                   Padding(
//                       padding: EdgeInsets.only(top: 2),
//                       child: Text(package.description,
//                           style: TextStyle(color: Colors.white))),
//                   goodsText,
//                   discountText,
//                 ],
//               ),
//               Positioned(
//                   child: Text(
//                     "${currencyFormatter.format(package.price)}",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   top: 0,
//                   right: 0)
//             ],
//           ),
//         ));

//     if (heroTag == null) {
//       return card;
//     }

//     return Hero(
//         tag: heroTag,
//         flightShuttleBuilder: (
//           BuildContext flightContext,
//           Animation<double> animation,
//           HeroFlightDirection flightDirection,
//           BuildContext fromHeroContext,
//           BuildContext toHeroContext,
//         ) {
//           return TicPackage(
//             package: package,
//             animation: ReverseAnimation(animation),
//           );
//         },
//         child: card);
//   }
// }
