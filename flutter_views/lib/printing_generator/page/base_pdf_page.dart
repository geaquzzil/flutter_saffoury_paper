import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../../new_screens/setting/base_shared_detail_modifidable.dart';

abstract class BasePdfPage extends StatefulWidget {
  String title;
  BasePdfPage({super.key, required this.title});
}

abstract class BasePdfPageState<T extends BasePdfPage> extends State<T> {
  Widget getFloatingActions(BuildContext context);

  Widget getFutureBody(BuildContext context);
  ViewAbstract? getSettingObject(BuildContext context);
  // bool hasSetting

  @override
  Widget build(BuildContext context) {
    return TowPaneExt(
      startPane: SizeConfig.isMobile(context)
          ? getFirstPane(context)
          : (getEndPane(context) ?? getFirstPane(context)),
      endPane: getFirstPane(context),
    );
  }

  Widget? getEndPane(BuildContext context) {
    ViewAbstract? settings = getSettingObject(context);
    if (settings == null) return null;
    return Scaffold(
      body: BaseSettingDetailsView(
        viewAbstract: settings as ModifiableInterface,
        onValidate: (viewAbstract) {
          setState(() {});
        },
      ),
    );
  }

  Widget getFirstPane(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getFloatingActions(context),
        body: getPdfPreview(context));
  }

  CustomScrollView getPdfPreview(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 4,
          pinned: true,
          primary: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.title),
          ),
        ),
        SliverFillRemaining(
          child: Center(child: getFutureBody(context)),
        )
      ],
    );
  }
}
