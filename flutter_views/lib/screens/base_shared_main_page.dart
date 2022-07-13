import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/authentecation/components/network_faild_auth.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/screens/view/base_shared_details_view.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawer/drawer_small_screen.dart';
import 'package:flutter_view_controller/screens/base_app_shared_header.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawer_large/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_widget.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';

class BaseSharedMainPage<T extends ViewAbstract> extends StatefulWidget {
  const BaseSharedMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BaseSharedMainPage> createState() => _BaseSharedMainPageState();
}

class _BaseSharedMainPageState extends State<BaseSharedMainPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    debugPrint(authProvider.getStatus.toString());
    switch (authProvider.getStatus) {
      case Status.Initialization:
        return getLoadingWidget();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Center(
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
        );
      case Status.Authenticated:
        return getFutureDrawerItemsBuilder(context, authProvider);
      case Status.Faild:
        return const NetworkFaildAuth();
      default:
        return getFutureDrawerItemsBuilder(context, authProvider);
    }

    // return Scaffold(
    //   body: NavigationDrawerWidget(drawerItems: widget.drawerItems),
    // );
  }

  Widget getLoadingWidget() => Center(
      child: Lottie.network(
          "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json"));
  Widget getFutureDrawerItemsBuilder(
      BuildContext context, AuthProvider authProvider) {
    return FutureBuilder(
        future: authProvider.initDrawerItems(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return getLoadingWidget();
            case ConnectionState.done:
              debugPrint(
                  "drawer itmes ${authProvider.getDrawerItems.toString()}");
              return getMainContainerWidget(context);
            default:
              if (snapshot.hasError) {
                return const NetworkFaildAuth();
              } else {
                return const NetworkFaildAuth();
              }
          }
        });
  }

  Widget getScreenDivider(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(children: [
      if (SizeConfig.isDesktop(context)) DrawerLargeScreens(),
      Expanded(
        child: Column(
          children: [
            const HeaderMain(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const <Widget>[
                    Text('Deliver features faster',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Craft beautiful UIs'),
                    Spacer(),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: FlutterLogo(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(children: [
                Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      // child: Text("TESRT"),
                      child: const ListApiWidget(),
                    )),
                if (SizeConfig.isDesktop(context))
                  Expanded(
                      flex: size.width > 1340 ? 8 : 10,
                      child: Container(
                          // margin: EdgeInsets.all(25),
                          // decoration: BoxDecoration(
                          //   // boxShadow: [
                          //   //   BoxShadow(
                          //   //     color: Colors.grey[100]!,
                          //   //     spreadRadius: 10,
                          //   //     blurRadius: 5,
                          //   //   )
                          //   // ],
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(25),
                          // ),
                          child: const Center(
                        child: BaseSharedDetailsView(),
                      )))
              ]),
            )
          ],
        ),
      )
    ]);

    //   Expanded(

    //     child: Row(children: [
    //       if (SizeConfig.isDesktop(context)) NavigationDrawerWidget(),
    //       Column(children: [
    //   SizedBox(
    //         height: 60,
    //         width: double.infinity,
    //         child: Container(
    //           color: Colors.white,
    //         ), //desktop header
    //         Row(children: [
    // Expanded(
    //           // It takes 5/6 part of the screen
    //           flex: 5,
    //           child: Container(
    //             padding: EdgeInsets.all(50),
    //             child: ListProviderWidget(),
    //           )),
    //       if (SizeConfig.isDesktop(context))
    //         Expanded(
    //             flex: _size.width > 1340 ? 8 : 10,
    //             child: Container(
    //                 // margin: EdgeInsets.all(25),
    //                 decoration: BoxDecoration(
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: Colors.grey[100]!,
    //                       spreadRadius: 10,
    //                       blurRadius: 5,
    //                     )
    //                   ],
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(25),
    //                 ),
    //                 child: Center(
    //                   child: BaseSharedDetailsView(),
    //                 )))
    //         ],)]
    //       )));
  }

  Widget getMainContainerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      drawer: const DrawerMobile(),
      body: SafeArea(child: getScreenDivider(context)),
    );
  }

  Scaffold MainWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      drawer: const DrawerMobile(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (SizeConfig.isDesktop(context)) DrawerLargeScreens(),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: getMainPage(),
            ),
            if (SizeConfig.isDesktop(context))
              Expanded(
                  flex: size.width > 1340 ? 8 : 10,
                  child: const BaseSharedDetailsView()),
          ],
        ),
      ),
    );
  }

  Widget getMainPage() {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: const [
            BaseAppSharedHeader(),
            SizedBox(height: defaultPadding),
            Center(child: Text("THIS IS A TEST")),
            // ListProviderWidget()
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 5,
            //       child: Column(
            //         children: [
            //           MyFiles(),
            //           SizedBox(height: defaultPadding),
            //           RecentFiles(),
            //           if (Responsive.isMobile(context))
            //             SizedBox(height: defaultPadding),
            //           if (Responsive.isMobile(context)) StarageDetails(),
            //         ],
            //       ),
            //     ),
            //     if (!Responsive.isMobile(context))
            //       SizedBox(width: defaultPadding),
            //     // On Mobile means if the screen is less than 850 we dont want to show it
            //     if (!Responsive.isMobile(context))
            //       Expanded(
            //         flex: 2,
            //         child: StarageDetails(),
            //       ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class HeaderMain extends StatefulWidget {
  const HeaderMain({
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderMain> createState() => _HeaderMainState();
}

class _HeaderMainState extends State<HeaderMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.read<DrawerViewAbstractProvider>().getObject;

    ExampleItemPager pager = ExampleItemPager();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .99,
                    child: PaginatedSearchBar<dynamic>(
                      containerDecoration: BoxDecoration(
                        boxShadow: const [
                          // BoxShadow(
                          //   color: Colors.black.withOpacity(0.16),
                          //   offset: const Offset(0, 3),
                          //   blurRadius: 12,
                          // )
                        ],
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      itemPadding: 30,

                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      maxHeight: 300,
                      hintText:
                          'Search ${viewAbstract.getMainHeaderLabelTextOnly(context)}',
                      emptyBuilder: (context) {
                        return const Text("I'm an empty state!");
                      },

                      // placeholderBuilder: (context) {
                      //   return const Text("I'm a placeholder state!");
                      // },
                      paginationDelegate: EndlessPaginationDelegate(
                        pageSize: 20,
                        maxPages: 3,
                      ),
                      onSearch: ({
                        required pageIndex,
                        required pageSize,
                        required searchQuery,
                      }) async {
                        return await viewAbstract.search(5, 0, searchQuery);
                      },
                      //   return viewAbstract.search(5, 0, searchQuery) ?? Future.delayed(
                      //       const Duration(milliseconds: 1300), () {
                      //     if (searchQuery == "empty") {
                      //       return [];+
                      //     }
                      //     if (searchQuery == "") {
                      //       return [];
                      //     }

                      //     if (pageIndex == 0) {
                      //       pager = ExampleItemPager();
                      //     }

                      //     return  [];
                      //   });
                      // },
                      itemBuilder: (
                        context, {
                        required item,
                        required index,
                      }) {
                        return ListCardItem(object: item as ViewAbstract);
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 20,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];

    for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;

    return batch;
  }
}

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}
