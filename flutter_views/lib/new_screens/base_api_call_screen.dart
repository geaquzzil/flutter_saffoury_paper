import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:provider/provider.dart';

import '../providers/actions/list_multi_key_provider.dart';

abstract class BaseApiCallPageState<T extends StatefulWidget, C>
    extends State<T> {
  int? iD;
  String? tableName;
  C? extras;

  BaseApiCallPageState({this.iD, this.tableName, this.extras});
  Future<C?> getCallApiFunctionIfNull(BuildContext context);
  Widget buildAfterCall(BuildContext context, C newObject);
  ServerActions getServerActions();
  C getExtras() {
    return extras as C;
  }

  Widget beforeBuildAfterCall(BuildContext context) {
    return buildAfterCall(context, extras as C);
  }

  bool getBodyWithoutApi() {
    return (extras as ViewAbstract?)?.getBodyWithoutApi(getServerActions()) ==
        true;
  }

  @override
  Widget build(BuildContext context) {
    if (extras != null && getBodyWithoutApi()) {
      return beforeBuildAfterCall(context);
    }

    return FutureBuilder<C?>(
      future: getCallApiFunctionIfNull(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyWidget(
              lottiUrl:
                  "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
              onSubtitleClicked: () {
                setState(() {});
              },
              title: AppLocalizations.of(context)!.cantConnect,
              subtitle: AppLocalizations.of(context)!.cantConnectRetry);
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            extras = snapshot.data;
            if (extras is ViewAbstract) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                context
                    .read<ListMultiKeyProvider>()
                    .edit(extras as ViewAbstract);
              });
            }
            return beforeBuildAfterCall(context);
          } else {
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                onSubtitleClicked: () {
                  setState(() {});
                },
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else {
          return const Text("TOTODO");
        }
      },
    );
  }
}
