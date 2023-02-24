import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
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
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/checout.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/privecy-policey.dart';
import 'package:flutter_view_controller/screens/web/services.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../interfaces/dashable_interface.dart';
import '../models/view_abstract.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import '../screens/web/contact-us.dart';
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
const String indexWebPrivecyPolicy = "privecy-policy";
const String indexWebTermsAndConditions = "terms";
const String indexWebOurProducts = "products";
const String indexWebServices = "services";
const String indexWebAboutUs = "about-us";
const String indexWebContactUs = "contact-us";
const String indexWebCheckout = "checkout";
const String indexWebView = "v";

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

//https://assets5.lottiefiles.com/packages/lf20_kcsr6fcp.json
class RouteGenerator {
  static GoRouter? _instance;
  static GoRouter instance({List<RouteBase>? addonRoutes}) {
    _instance ??= _getGoRouter(addonRoutes: addonRoutes);
    return _instance!;
  }

  static GoRouter _getGoRouter({List<RouteBase>? addonRoutes}) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) async {
        if (kIsWeb) {
          if (state.location == "/") {
            return "/index";
          } else if (state.location.startsWith("/index")) {
            return state.location;
          } else {
            return "/index";
          }
        }
        return "/";
      },
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: getErrorPage(),
      ),
      // redirect: (context, state) {

      // },
      routes: <RouteBase>[
        GoRoute(
            path: "/index",
            name: indexWebRouteName,
            pageBuilder: (context, state) => MaterialPage(child: HomeWebPage()),
            routes: [
              GoRoute(
                name: indexWebSignIn,
                path: indexWebSignIn,
                pageBuilder: (context, state) {
                  return MaterialPage(key: state.pageKey, child: SignInPage());
                },
              ),
              GoRoute(
                path: "privecy-policy",
                name: indexWebPrivecyPolicy,
                pageBuilder: (context, state) {
                  return MaterialPage(child: PrivecyPolicyWebPage());
                },
              ),
              GoRoute(
                path: indexWebContactUs,
                name: indexWebContactUs,
                pageBuilder: (context, state) {
                  return MaterialPage(child: ContactUsWebPage());
                },
              ),
              GoRoute(
                path: "about-us",
                name: indexWebAboutUs,
                pageBuilder: (context, state) {
                  return MaterialPage(child: AboutUsWebPage());
                },
              ),
              GoRoute(
                path: indexWebCheckout,
                name: indexWebCheckout,
                pageBuilder: (context, state) {
                  return MaterialPage(child: CheckoutWeb());
                },
              ),
              GoRoute(
                name: indexWebView,
                path: "v/:tableName/:id",
                pageBuilder: (context, state) {
                  return MaterialPage(
                      key: state.pageKey,
                      child: WebProductView(
                        iD: int.parse(state.params['id']!),
                        tableName: state.params['tableName']!,
                        extras: state.extra as ViewAbstract?,
                      ));
                },
              ),
              GoRoute(
                path: "terms",
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
                    searchQuery: state.queryParams["search"],
                    customFilter: state.queryParams['filter'],
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
          path: "/home",
          pageBuilder: (context, state) =>
              const MaterialPage(child: BaseHomeMainPage()),
        ),
        GoRoute(
            path: '/',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const MaterialPage(child: BaseAuthenticatingScreen());
            },
            routes: [
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
                  return MaterialPage(
                      key: state.pageKey,
                      child: BaseViewNewPage(
                        viewAbstract: state.extra as ViewAbstract,
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
                        tableName: state.params["tableName"],
                        viewAbstract: null,
                        // viewAbstract: (state.extra as List)[0],
                      ));
                },
              ),
            ]),
        GoRoute(
          name: printRouteName,
          path: "/print/:tableName/:id",
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: PdfPage(
                  iD: int.tryParse(state.params['id'] ?? "-"),
                  tableName: state.params['tableName'],
                  invoiceObj: state.extra as PrintableMaster,
                ));
          },
        ),
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
            return MaterialPage(key: state.pageKey, child: POSPage());
          },
        ),
        GoRoute(
          name: loginRouteName,
          path: "/login",
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: SignInPage());
          },
        ),
        if (addonRoutes != null) ...addonRoutes
      ],
    );
  }

  static Scaffold getErrorPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('ERROR'),
      ),
    );
  }

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
                child: child,
                animation: animation,
              ),
            );
          },
        );
}

class CurvedRectArcTween extends MaterialRectArcTween {
  CurvedRectArcTween({
    Rect? begin,
    Rect? end,
  }) : super(begin: begin, end: end);
  @override
  Rect lerp(double t) {
    Cubic easeInOut = const Cubic(0.42, 0.0, 0.58, 1.0);
    double curvedT = easeInOut.transform(t);
    return super.lerp(curvedT);
  }
}

class PageRouteTransition extends AnimatedWidget {
  const PageRouteTransition({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key, listenable: animation);
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
