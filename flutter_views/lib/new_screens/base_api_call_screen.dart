import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class BaseApiCallPageState<T extends StatefulWidget, C>
    extends State<T> {
  int? iD;
  String? tableName;
  C? extras;
  BaseApiCallPageState({this.iD, this.tableName, this.extras});
  Future<C?> getCallApiFunctionIfNull(BuildContext context);
  Widget buildAfterCall(BuildContext context, C newObject);
  C getExtras() {
    return extras as C;
  }

  @override
  Widget build(BuildContext context) {
    
    if (extras != null) return buildAfterCall(context, extras as C);

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
            return buildAfterCall(context, snapshot.data as C);
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
          return Scaffold(
              body: const Center(child: CircularProgressIndicator()));
        } else {
          return Text("TOTODO");
        }
      },
    );
  }
}
