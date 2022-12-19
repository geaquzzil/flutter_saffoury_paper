import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/authentecation/components/loading_auth.dart';
import 'package:flutter_view_controller/new_screens/authentecation/components/network_faild_auth.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_main_page.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseAuthenticatingScreen extends StatelessWidget {
  const BaseAuthenticatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.getStatus) {
      case Status.Initialization:
        return getLoadingWidget();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return const LoadingAuth();
      case Status.Authenticated:
      case Status.Guest:
        return getFutureDrawerItemsBuilder(context, authProvider);
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
              return POSPage();
              return const BaseHomeMainPage();
            default:
              if (snapshot.hasError) {
                return const NetworkFaildAuth();
              } else {
                return const NetworkFaildAuth();
              }
          }
        });
  }
}
