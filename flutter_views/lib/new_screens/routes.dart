import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/file_reader/base_file_reader_page.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/base_file_exporter_page.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_main_page.dart';
import 'package:flutter_view_controller/new_screens/search/search_page.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/view_abstract.dart';
import '../providers/auth_provider.dart';

import 'actions/view/view_view_main_page.dart';
import 'authentecation/base_authentication_screen.dart';
import 'actions/edit_new/base_edit_main_page.dart';
import 'home/base_home_main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            Status authStatus = context.read<AuthProvider>().getStatus;
            if (authStatus == Status.Authenticated) {
              // return POSPage();
              return const BaseHomeMainPage();
            } else {
              // return POSPage();
              return BaseAuthenticatingScreen();
            }
          },
        );

      case "/search":
        return MaterialPageRoute(builder: (context) =>  SearchPage());
      case '/sign_in':
        return MaterialPageRoute(builder: (context) => const SignInPage());

      //  case "/print":
      //     return MaterialPageRoute(builder: (context) => const SignInPage());

      case "/print":
        return MaterialPageRoute(builder: (context) {
          if (args == null) {
            return Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json");
          } else if (args is ViewAbstract) {
            return PdfPage(
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

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
