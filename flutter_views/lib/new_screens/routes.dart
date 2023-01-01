import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
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
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../interfaces/dashable_interface.dart';
import '../models/view_abstract.dart';
import '../providers/auth_provider.dart';

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
const String searchRouteName = "search";

//https://assets5.lottiefiles.com/packages/lf20_kcsr6fcp.json
class RouteGenerator {
  static final GoRouter goRouter = GoRouter(
    initialLocation: '/',
    // redirect: (context, state) async {
    //   Status authStatus = context.read<AuthProvider>().getStatus;
    //   if (authStatus == Status.Initialization) {
    //     return "/home";
    //   }
    //   return "/";
    // },
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: getErrorPage(),
    ),
    // redirect: (context, state) {

    // },
    routes: <RouteBase>[
      GoRoute(
        name: homeRouteName,
        path: "/home",
        pageBuilder: (context, state) =>
            MaterialPage(child: BaseHomeMainPage()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) {
          Status authStatus = context.read<AuthProvider>().getStatus;
          if (authStatus == Status.Authenticated) {
            // return POSPage();
            return const MaterialPage(child: BaseHomeMainPage());
          } else {
            // return POSPage();
            return const MaterialPage(child: BaseAuthenticatingScreen());
          }
        },
      ),
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
        name: viewRouteName,
        path: "/view/:tableName/:id",
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
        path: "/search/:tableName",
      
        pageBuilder: (context, state) {
          return MaterialPage(
              key: state.pageKey,
              child: SearchPage(
                tableName: state.params["tableName"],
                viewAbstract: state.extra as ViewAbstract?,
              ));
        },
      ),
      GoRoute(
        name: loginRouteName,
        path: "/login",
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: SignInPage());
        },
      )
    ],
  );

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
        return MaterialPageRoute(builder: (context) => const SignInPage());

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
        Status authStatus = context.read<AuthProvider>().getStatus;
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
