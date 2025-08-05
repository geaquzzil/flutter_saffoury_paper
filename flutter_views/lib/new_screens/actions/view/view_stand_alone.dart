import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../../providers/actions/action_viewabstract_provider.dart';

class MasterViewStandAlone extends StatelessWidget {
  ViewAbstractStandAloneCustomViewApi viewAbstract;
  MasterViewStandAlone({super.key, required this.viewAbstract});
  FutureOr<dynamic>? getFuture(BuildContext context) {
    debugPrint(
      "getFuture responseType=> ${viewAbstract.getCustomStandAloneResponseType()}",
    );
    return viewAbstract.viewCall(context: context);
  }

  Widget getFutureBuilder(BuildContext context) {
    return FutureOrBuilder(
      future: getFuture(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint("getFutureBuilder ${snapshot.data}");
          viewAbstract = snapshot.data;
          Size size = MediaQuery.of(context).size;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: size.width > 1340 ? 8 : 2,
                  child: getMainWidget(context),
                ),
                if (SizeConfig.isDesktop(context))
                  wrapSideWidget(context, size),
              ],
            ),
          );
          //  snapshot.data.bodyBytes);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getMainWidget(BuildContext context) {
    return viewAbstract.getCustomStandAloneWidget(context);
  }

  Widget getSideWidget(BuildContext context, Widget? hasCustomWidget) {
    return ListView(
      shrinkWrap: true,
      // controller: ScrollController(),
      // physics: const AlwaysScrollableScrollPhysics(),
      // c: Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [...viewAbstract.getCustomeStandAloneSideWidget(context) ?? []],
      // ),
    );
  }

  // Widget wrapMainWidget(BuildContext context,Size size){
  //     return Expanded(
  //       flex: customWidget != null
  //           ? 6
  //           : size.width > 1340
  //               ? 4
  //               : 1,
  //       child: getSideWidget(context, customWidget));
  // }
  Widget wrapSideWidget(BuildContext context, Size size) {
    ActionViewAbstractProvider actionViewAbstractProvider = context
        .watch<ActionViewAbstractProvider>();
    Widget? customWidget = actionViewAbstractProvider.getCustomWidget;
    return Expanded(
      flex: customWidget != null
          ? 6
          : size.width > 1340
          ? 5
          : 2,
      child: getSideWidget(context, customWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (viewAbstract.getCustomStandAloneResponseType() ==
        ResponseType.NONE_RESPONSE_TYPE) {
      // return viewAbstract.getCustomStandAloneWidget(context);
      //todo on CustomStandAloneResponse alone we need to do this       return viewAbstract.getCustomStandAloneWidget(context);
      //todod if from split scree then
      // return viewAbstract.getCustomStandAloneWidget(context);
      return Card(
        child: ListView(
          shrinkWrap: true,
          children: [
            BaseSharedHeaderViewDetailsActions(viewAbstract: viewAbstract),
            viewAbstract.getCustomStandAloneWidget(context),
          ],
        ),
      );
    } else {
      return getFutureBuilder(context);
    }
  }
}
