// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_determine_screen_page.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/details/list_details.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_main_page.dart';
import 'package:flutter_view_controller/new_screens/search/search_page.dart';
import 'package:flutter_view_controller/new_screens/setting/setting_page.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/checout.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/return-privecy-policey.dart';
import 'package:flutter_view_controller/screens/web/register.dart';
import 'package:flutter_view_controller/screens/web/services.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile_web_page.dart';
import 'package:flutter_view_controller/screens/web/views/web_master_to_list.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../interfaces/dashable_interface.dart';
import '../models/view_abstract.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import '../screens/web/contact-us.dart';
import '../screens/web/error-page.dart';
import '../screens/web/our_products.dart';
import '../screens/web/terms.dart';
import 'actions/view/view_view_main_page.dart';
import 'authentecation/base_authentication_screen.dart';
import 'actions/edit_new/base_edit_main_page.dart';
import 'home/base_home_main.dart';

const String rootRouteName = 'root';
const String cartRouteName = 'cart';
const String createAccountRouteName = 'create-account';
const String detailsRouteName = 'details';
const String homeRouteName = 'home';
const String loggedInKey = 'LoggedIn';
const String loginRouteName = 'login';
const String moreInfoRouteName = 'moreInfo';
const String paymentRouteName = 'payment';
const String personalRouteName = 'personal';
const String profileMoreInfoRouteName = 'profile-moreInfo';
const String profilePaymentRouteName = 'profile-payment';
const String profilePersonalRouteName = 'profile-personal';
const String profileRouteName = 'profile';
const String profileSigninInfoRouteName = 'profile-signin';
const String subDetailsRouteName = 'shop-details';
const String shoppingRouteName = 'shopping';
const String printRouteName = 'print';
const String viewRouteName = 'view';
const String editRouteName = 'edit';
const String addRouteName = 'add';
const String searchRouteName = "search";
const String dashboardRouteName = "dashboard";
const String posRouteName = "pos";
const String indexWebRouteName = "index";
const String indexWebSignIn = "sign-in";
const String indexReturnPrivecyPolicy = "return-policy";
const String indexWebTermsAndConditions = "terms-and-conditions";
const String indexWebOurProducts = "products";
const String indexWebServices = "services";
const String indexWebAboutUs = "about-us";
const String indexWebContactUs = "contact-us";
const String indexWebCheckout = "checkout";
const String indexWebView = "v";
const String indexWebMasterToList = "list";
const String IndexWebRegister = "register";
const String indexWebSettingAndAccount = "account";
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

//https://assets5.lottiefiles.com/packages/lf20_kcsr6fcp.json
class RouteGenerator {
  AuthProvider appService;
  GoRouter get router => _goRouter;
  BuildContext context;
  List<RouteBase>? addonRoutes;

  RouteGenerator({
    required this.appService,
    required this.context,
    this.addonRoutes,
  });

  String? getRouterAuthWeb(GoRouterState state) {
    debugPrint("GoRouter kIsWeb path  ${state.fullPath}");

    final isLogedIn = appService.getUser.login == true;
    final isInitialized = appService.getStatus == Status.Initialization;
    final isAuthenticated = appService.getStatus == Status.Authenticated;
    final isFinishedInitialization = appService.isInitialized;

    final loginLocation = state.namedLocation(loginRouteName);
    var homeLocation = "/index";
    final splashLocation = state.namedLocation("splash");
    if (isInitialized) {
      return splashLocation;
    } else if (isLogedIn && !isFinishedInitialization) {
      appService.isInitialized = true;
      return homeLocation;

    }
    else {
      if (state.fullPath == null) {
        return homeLocation;
      } else if (state.fullPath == "/") {
        return homeLocation;
      } else if (state.fullPath!.startsWith("/index")) {
        debugPrint("GoRouter state.fullPath!.startsWith");
        return null;
      } else {
        debugPrint("GoRouter Error");
        return "Error";
      }
    }
  }

  String? getRouterAuth(GoRouterState state) {
    final loginLocation = state.namedLocation(loginRouteName);
    var homeLocation = state.namedLocation(homeRouteName);
    final splashLocation = state.namedLocation("splash");

    // homeLocation=state.namedLocation("listable",pathParameters: {"tableName": "products","iD":"213"});
    // final onboardLocation = state.namedLocation(APP_PAGE.onBoarding.toName);

    final isLogedIn = appService.getUser.login == true;
    final isInitialized = appService.getStatus == Status.Initialization;
    final isAuthenticated = appService.getStatus == Status.Authenticated;
    final isFinishedInitialization = appService.isInitialized;
    // final isOnboarded = appService.onboarding;

    final isGoingToLogin = state.path == loginLocation;
    final isGoingToInit = state.path == splashLocation;
    // final isGoingToOnboard = state.path == onboardLocation;
    debugPrint(
        "getRouterAuth: isGoingToLogin: isGoingToInit: isLogedIn: $isLogedIn isInitialized: $isInitialized appService.getStatus :${appService.getStatus}");

    if (isInitialized) {
      return splashLocation;
      // If not onboard and not going to onboard redirect to OnBoarding
    } else if (isLogedIn && !isFinishedInitialization) {
      appService.isInitialized = true;
      return homeLocation;
      // If not logedin and not going to login redirect to Login
    }
    // else if (isInitialized && !isLogedIn && !isGoingToLogin) {
    //   return loginLocation;
    //   // If all the scenarios are cleared but still going to any of that screen redirect to Home
    // } else if ((isLogedIn && isGoingToLogin) ||
    //     (isInitialized && isGoingToInit)) {
    //   return homeLocation;
    // }
    else {
      // Else Don't do anything
      return null;
    }
    // if (!isInitialized && !isGoingToInit) {
    //   return splashLocation;
    // // If not onboard and not going to onboard redirect to OnBoarding
    // } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
    //   return onboardLocation;
    // // If not logedin and not going to login redirect to Login
    // } else if (isInitialized && isOnboarded && !isLogedIn && !isGoingToLogin) {
    //   return loginLocation;
    // // If all the scenarios are cleared but still going to any of that screen redirect to Home
    // } else if ((isLogedIn && isGoingToLogin) || (isInitialized && isGoingToInit) || (isOnboarded && isGoingToOnboard)) {
    //   return homeLocation;
    // } else {
    // // Else Don't do anything
    //   return null;
    // }
  }

  late final GoRouter _goRouter = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    refreshListenable: appService,
    redirect: !kIsWeb
        ? (context, state) async {
            return getRouterAuth(state);
          }
        : (context, state) async {
            return getRouterAuthWeb(state);
          },
    errorPageBuilder: (context, state) {
      debugPrint("routes errorPageBuilder ${state.fullPath}");
      return MaterialPage(
        key: state.pageKey,
        child: getErrorPage(),
      );
    },
    // redirect: (context, state) {

    // },
    routes: <RouteBase>[
      GoRoute(
          path: "/index",
          name: indexWebRouteName,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: HomeWebPage()),
          routes: [
            GoRoute(
              name: indexWebSignIn,
              path: indexWebSignIn,
              pageBuilder: (context, state) {
                return MaterialPage(key: state.pageKey, child: SignInPage());
              },
            ),
            GoRoute(
              path: IndexWebRegister,
              name: IndexWebRegister,
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey, child: RegisterWebPage());
              },
            ),
            GoRoute(
              path: indexWebSettingAndAccount,
              name: indexWebSettingAndAccount,
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: SettingAndProfileWebPage(
                      currentSetting: state.pathParameters["action"],
                    ));
              },
            ),
            GoRoute(
              path: indexReturnPrivecyPolicy,
              name: indexReturnPrivecyPolicy,
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey, child: ReturnPrivecyPolicyWebPage());
              },
            ),
            GoRoute(
              path: indexWebContactUs,
              name: indexWebContactUs,
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey, child: ContactUsWebPage());
              },
            ),
            GoRoute(
              path: "about-us",
              name: indexWebAboutUs,
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey, child: AboutUsWebPage());
              },
            ),
            GoRoute(
              path: indexWebCheckout,
              name: indexWebCheckout,
              pageBuilder: (context, state) {
                return MaterialPage(key: state.pageKey, child: CheckoutWeb());
              },
            ),
            GoRoute(
              name: indexWebView,
              path: "v/:tableName/:id",
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: WebProductView(
                      iD: int.parse(state.pathParameters['id']!),
                      tableName: state.pathParameters['tableName']!,
                      extras: state.extra as ViewAbstract?,
                    ));
              },
            ),
            GoRoute(
              name: indexWebMasterToList,
              path: "list/:tableName",
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: WebMasterToList(
                      iD: int.parse(state.uri.queryParameters['id']!),
                      tableName: state.pathParameters['tableName']!,
                      extras: state.extra as ViewAbstract?,
                    ));
              },
            ),
            GoRoute(
              path: indexWebTermsAndConditions,
              name: indexWebTermsAndConditions,
              pageBuilder: (context, state) {
                return MaterialPage(child: TermsWebPage());
              },
            ),
            GoRoute(
              path: "products",
              name: indexWebOurProducts,
              pageBuilder: (context, state) {
                return MaterialPage(
                    child: ProductWebPage(
                  searchQuery: state.uri.queryParameters["search"],
                  customFilter: state.uri.queryParameters['filter'],
                ));
              },
            ),
            GoRoute(
              path: "services",
              name: indexWebServices,
              pageBuilder: (context, state) {
                return MaterialPage(child: ServicesWebPage());
              },
            )
          ]),

      GoRoute(
          name: homeRouteName,
          path: '/',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(child: SafeArea(child: BaseDeterminePageState()));
          },
          routes: [
            // GoRoute(
            //   name: "listable",
            //   path: ":tableName",
            //   pageBuilder: (context, state) {
            //     return MaterialPage(
            //         key: state.pageKey,
            //         child: WebMasterToList(
            //           iD: int.parse(state.uri.queryParameters['id']!),
            //           tableName: state.pathParameters['tableName']!,
            //           extras: state.extra as ViewAbstract?,
            //         ));
            //   },
            // ),
            GoRoute(
              name: editRouteName,
              path: "edit/:tableName/:id",
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: BaseEditNewPage(
                      viewAbstract: state.extra as ViewAbstract,
                    ));
              },
            ),
            GoRoute(
              name: addRouteName,
              path: "add/:tableName",
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: BaseEditNewPage(
                      viewAbstract: state.extra as ViewAbstract,
                    ));
              },
            ),
            GoRoute(
              name: viewRouteName,
              path: "view/:tableName/:id",
              pageBuilder: (context, state) {
                debugPrint("BaseViewNewPage");
                return MaterialPage(
                    key: state.pageKey,
                    child: BaseViewNewPage(
                      viewAbstract: state.extra as ViewAbstract,
                    ));
              },
            ),
            GoRoute(
              name: printRouteName,
              path: "print/:tableName/:id",
              pageBuilder: (context, state) {
                debugPrint(
                    "go route name=> $printRouteName extras=> ${state.extra}");
                // debugPrint("go route name=> ${state.extra}");
                // return MaterialPage(key: state.pageKey, child: TestBasePage());

                // return MaterialPage(
                //     key: state.pageKey,
                //     child: PdfPage<PrintLocalSetting>(
                //       iD: int.tryParse(state.pathParameters['id'] ?? "-"),
                //       tableName: state.pathParameters['tableName'],
                //       invoiceObj: state.extra as PrintableMaster?,
                //     ));

                return MaterialPage(
                    key: state.pageKey,
                    child: PdfPageNew<PrintLocalSetting>(
                      iD: int.tryParse(state.pathParameters['id'] ?? "-"),
                      tableName: state.pathParameters['tableName'],
                      invoiceObj: state.extra as PrintableMaster?,
                    ));
              },
            ),
            GoRoute(
              name: searchRouteName,
              path: "search/:tableName",
              pageBuilder: (context, state) {
                return MaterialPage(
                    key: state.pageKey,
                    child: SearchPage(
                      // heroTag: (state.extra as List)[1],
                      tableName: state.pathParameters["tableName"],
                      viewAbstract: null,
                      // viewAbstract: (state.extra as List)[0],
                    ));
              },
            ),
          ]),
      GoRoute(
        name: dashboardRouteName,
        path: "/dashboard/list/:tableName",
        pageBuilder: (context, state) {
          return MaterialPage(
              key: state.pageKey,
              child: DashboardListDetails(
                list: (state.extra as List)[1],
                header: (state.extra as List)[0],
              ));
        },
      ),
      GoRoute(
        name: posRouteName,
        path: "/pos",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const POSPage());
        },
      ),
      GoRoute(
        path: "/splash",
        name: "splash",
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: BaseAuthenticatingScreen()),
      ),
      GoRoute(
        name: loginRouteName,
        path: "/login",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: SignInPage());
        },
      ),
      // if (addonRoutes != null) ...addonRoutes
    ],
  );

  static dynamic getFromExtra(Map<String, dynamic> extra) {
    // return ViewAbstract()..fromJsonViewAbstract(extra);
  }

  static Widget getErrorPage() {
    return ErrorWebPage(
      errorMessage: "404 not found!",
    );
  }

  @Deprecated("")
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return getHomePage();

      case "/search":
        return getSearchPage();
      case '/sign_in':
        return MaterialPageRoute(builder: (context) => SignInPage());

      //  case "/print":
      //     return MaterialPageRoute(builder: (context) => const SignInPage());
      case "/settings":
        return MaterialPageRoute(builder: (context) {
          return const SettingPage();
        });
      case "/dashboard":
        return MaterialPageRoute(builder: (context) {
          return DashboardPage(
            dashboard: args as DashableInterface,
          );
        });
      case "/print":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return PdfPage(
              iD: null,
              tableName: null,
              invoiceObj: args as PrintableMaster,
            );
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });

      case "/view":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return BaseViewNewPage(viewAbstract: args);
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });
      case "/edit":
      case "/add":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return BaseEditNewPage(viewAbstract: args);
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });
      case "/search":
        return MaterialPageRoute(builder: (context) {
          return BaseFilterableMainWidget(
            useDraggableWidget: true,
          );
        });
      case "/list":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is List<ViewAbstract>) {
            return Scaffold(
              body: SafeArea(
                child: ListStaticSearchableWidget<ViewAbstract>(
                  list: args,
                  listItembuilder: (item) => ListCardItem(object: item),
                  onSearchTextChanged: (query) {
                    debugPrint("onSearchTextChanged $query");

                    return (args).where((element) {
                      debugPrint(
                          "onSearchTextChanged ${element.toStringValues()}");
                      return query.contains(element.toStringValues());
                    }).toList();
                  },
                ),
              ),
            );
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });
      case "/import":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return FileReaderPage(
              viewAbstract: args,
            );
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });
      case "/export":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return FileExporterPage(
              viewAbstract: args,
            );
          } else {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          }
        });
    }
    return _errorRoute();
  }

  static MaterialPageRoute<dynamic> getSearchPage() => MaterialPageRoute(
      builder: (context) => SearchPage(
            viewAbstract: null,
          ));

  static MaterialPageRoute<dynamic> getHomePage() {
    return MaterialPageRoute(
      builder: (context) {
        // return BaseHomeMainPage();
        Status authStatus = context.read<AuthProvider<AuthUser>>().getStatus;
        if (authStatus == Status.Authenticated) {
          // return POSPage();
          return const BaseHomeMainPage();
        } else {
          // return POSPage();
          return const BaseAuthenticatingScreen();
        }
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class HeroPageRoute extends PageRouteBuilder {
  final String tag;
  final Widget child;
  HeroPageRoute({
    required this.tag,
    required this.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return Hero(
              tag: tag,
              createRectTween: (Rect? begin, Rect? end) {
                return CurvedRectArcTween(begin: begin, end: end);
              },
              child: PageRouteTransition(
                animation: animation,
                child: child,
              ),
            );
          },
        );
}

class CurvedRectArcTween extends MaterialRectArcTween {
  CurvedRectArcTween({
    super.begin,
    super.end,
  });
  @override
  Rect lerp(double t) {
    Cubic easeInOut = const Cubic(0.42, 0.0, 0.58, 1.0);
    double curvedT = easeInOut.transform(t);
    return super.lerp(curvedT);
  }
}

class PageRouteTransition extends AnimatedWidget {
  const PageRouteTransition({
    super.key,
    required this.child,
    required this.animation,
  }) : super(listenable: animation);
  final Widget child;
  final Animation<double> animation;
  static final opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  static final elevationTween = Tween<double>(begin: 6.0, end: 0.0);
  static final borderRadiusTween = BorderRadiusTween(
    begin: BorderRadius.circular(100.0),
    end: BorderRadius.zero,
  );
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Material(
      color: Colors.blue,
      clipBehavior: Clip.antiAlias,
      elevation: elevationTween.evaluate(animation),
      borderRadius: borderRadiusTween.evaluate(animation),
      child: Opacity(
        opacity: opacityTween.evaluate(animation),
        child: child,
      ),
    );
  }
}
