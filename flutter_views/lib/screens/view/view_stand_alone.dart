import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../new_components/ext.dart';
import '../../providers/actions/action_viewabstract_provider.dart';
import '../base_shared_actions_header.dart';

class MasterViewStandAlone extends StatelessWidget {
  ViewAbstractStandAloneCustomView viewAbstract;
  MasterViewStandAlone({Key? key, required this.viewAbstract})
      : super(key: key);
  Future<dynamic>? getFuture() {
    debugPrint(
        "getFuture responseType=> ${viewAbstract.getCustomStandAloneResponseType()}");
    switch (viewAbstract.getCustomStandAloneResponseType()) {
      case ResponseType.LIST:
        return viewAbstract.callApi();
      case ResponseType.SINGLE:
        return viewAbstract.callApi();
    }
  }

  Widget getFutureBuilder(BuildContext context) {
    return FutureBuilder(
        future: getFuture(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("getFutureBuilder ${snapshot.data}");
            viewAbstract = snapshot.data;
            Size size = MediaQuery.of(context).size;
            return Expanded(
              child: Row(children: [
                Expanded(
                    flex: size.width > 1340 ? 8 : 2,
                    child: getMainWidget(context)),
                if (SizeConfig.isDesktop(context)) wrapSideWidget(context, size)
              ]),
            );
            //  snapshot.data.bodyBytes);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget getMainWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // Expanded(flex: 1, child: Text("TEST")),
          Expanded(
            flex: 1,
            child: Stack(alignment: Alignment.bottomCenter, fit: StackFit.loose,
                // fit: BoxFit.contain,
                children: [
                  SingleChildScrollView(
                    controller: ScrollController(),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseSharedHeaderViewDetailsActions(
                          viewAbstract: viewAbstract,
                        ),
                        viewAbstract.getCustomStandAloneWidget(context)
                      ],
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget getSideWidget(BuildContext context, Widget? hasCustomWidget) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: getShadowBoxDecoration(),
        child: Center(
            child: hasCustomWidget ??
                viewAbstract.getCustomeStandAloneSideWidget(context)));
  }

  Widget wrapSideWidget(BuildContext context, Size size) {
    ActionViewAbstractProvider actionViewAbstractProvider =
        context.watch<ActionViewAbstractProvider>();
    Widget? customWidget = actionViewAbstractProvider.getCustomWidget;
    return Expanded(
        flex: customWidget != null
            ? 6
            : size.width > 1340
                ? 4
                : 1,
        child: getSideWidget(context, customWidget));
  }

  @override
  Widget build(BuildContext context) {
    return getFutureBuilder(context);
  }
}
