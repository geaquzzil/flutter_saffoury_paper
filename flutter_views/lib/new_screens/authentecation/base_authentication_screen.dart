import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page_new.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_determine_screen_page.dart';
import 'package:flutter_view_controller/new_screens/authentecation/components/loading_auth.dart';
import 'package:flutter_view_controller/new_screens/authentecation/components/network_faild_auth.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

@Deprecated("This will be removed in to do SplashScreen")
class BaseAuthenticatingScreen extends StatefulWidget {
  const BaseAuthenticatingScreen({super.key});

  @override
  State<BaseAuthenticatingScreen> createState() =>
      _BaseAuthenticatingScreenState();
}

class _BaseAuthenticatingScreenState extends State<BaseAuthenticatingScreen> {
  late AuthProvider authProvider;

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await authProvider.onAppStart(context);
  }

  @override
  Widget build(BuildContext context) {
    return getLoadingWidget();
    switch (authProvider.getStatus) {
      case Status.Initialization:
        return getLoadingWidget();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return const LoadingAuth();
      case Status.Authenticated:
      case Status.Guest:
        return authProvider.hasFinished()
            ? getDoneWidget(context)
            : getFutureDrawerItemsBuilder(context, authProvider);
      case Status.Faild:
        return const NetworkFaildAuth();
      default:
        return const LoadingAuth();
    }
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
              return getDoneWidget(context);

            default:
              if (snapshot.hasError) {
                return const NetworkFaildAuth();
              } else {
                return const NetworkFaildAuth();
              }
          }
        });
  }

  Widget getDoneWidget(BuildContext context) {
    // return POSPage();
    // return BaseDashboardMainPage(key: globalKeyBasePageWithApi, title: "TEST");
    return BaseDeterminePageState();
    // return Selector<DrawerMenuControllerProvider,
    //     ViewAbstractStandAloneCustomViewApi?>(
    //   builder: (context, value, child) {
    //     ViewAbstract? viewAbstract2 =
    //         context.read<DrawerMenuControllerProvider>().getObject;
    //     bool isInitViewAbstractCustomView =
    //         viewAbstract2 is ViewAbstractStandAloneCustomViewApi;
    //     if (value != null || isInitViewAbstractCustomView) {
    //       // List<Widget>? fabs=value.();
    //       value ??= viewAbstract2 as ViewAbstractStandAloneCustomViewApi;
    //       return Scaffold(
    //           key: drawerMenuControllerProvider.getStartDrawableKey,
    //           drawer: drawer,
    //           endDrawer: const BaseHomeCartPage(),
    //           floatingActionButton:
    //               value.getCustomFloatingActionWidget(context),
    //           body: shouldWrapNavigatorChild(
    //               context, getSliverPadding(context, value),
    //               isCustomWidget: true));
    //     } else {
    //       return Scaffold(
    //           key: drawerMenuControllerProvider.getStartDrawableKey,
    //           drawer: drawer,
    //           // drawerScrimColor: Colors.transparent,
    //           // backgroundColor: compexDrawerCanvasColor,
    //           endDrawer: const BaseHomeCartPage(),
    //           bottomNavigationBar: getBottomNavigationBar(),
    //           appBar: getAppBar(),
    //           body: getMainBodyIndexedStack(context));
    //     }
    //   },
    //   selector: (p0, p1) => p1.getStandAloneCustomView,
    // );

    // return BaseShared();
    // return PdfTestToBasePage();
    // return TestBasePage();
    return const BaseHomeMainPage();
  }
}
