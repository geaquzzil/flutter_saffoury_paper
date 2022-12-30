import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../configrations.dart';
import '../../new_screens/setting/base_shared_detail_modifidable.dart';

abstract class BasePdfPage extends StatefulWidget {
  String title;
  BasePdfPage({super.key, required this.title});
}

abstract class BasePdfPageState<T extends BasePdfPage> extends State<T> {
  Widget getFloatingActions(BuildContext context);

  Widget getFutureBody(BuildContext context);
  Future<ViewAbstract?>? getSettingObject(BuildContext context);
  ViewAbstract getMainObject();
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
    var future = getSettingObject(context);
    if (future == null) return null;
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return Scaffold(
          body: BaseEditWidget(
            isTheFirst: true,
            viewAbstract: snapshot.data as ViewAbstract,
            onValidate: (viewAbstract) {
              context.read<PrintSettingLargeScreenProvider>().setViewAbstract =
                  (viewAbstract);

              if (viewAbstract != null) {
                Configurations.save(
                    "_printsetting${getMainObject().runtimeType}",
                    viewAbstract);
              }
              // setState(() {});
            },
          ),
        );
      },
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

class PrintSettingLargeScreenProvider with ChangeNotifier {
  ViewAbstract? _viewAbstract;
  set setViewAbstract(ViewAbstract? viewAbstract) {
    if (viewAbstract == null) return;
    _viewAbstract = viewAbstract;
    notifyListeners();
  }

  get getViewAbstract {
    return _viewAbstract;
  }
}
