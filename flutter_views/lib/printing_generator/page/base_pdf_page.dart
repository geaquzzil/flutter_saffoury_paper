import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:pdf/pdf.dart';
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
  late PrintSettingLargeScreenProvider printSettingListener;
  // bool hasSetting

  @override
  void initState() {
    super.initState();
    printSettingListener =
        Provider.of<PrintSettingLargeScreenProvider>(context, listen: false);
  }

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
              printSettingListener.setViewAbstract = viewAbstract;
              if (viewAbstract != null) {
                Configurations.save(
                    "_printsetting${getMainObject().runtimeType}",
                    viewAbstract);
              }
            },
          ),
        );
      },
    );
  }

  Widget getFloatingActionButtonConsomer(BuildContext context,
      {required Widget Function(BuildContext, bool) builder}) {
    return Selector<PrintSettingLargeScreenProvider, bool>(
      builder: (_, isExpanded, __) {
        debugPrint(
            "BasePdfPageConsumer Selector =>  getFloatingActionButtonConsomer");
        return builder(_, isExpanded);
      },
      selector: (ctx, provider) => provider.getFloatActionIsExpanded,
    );
  }

  Widget getPdfPageSelectedFormatConsumer(
      BuildContext context,
      {required Widget Function(BuildContext, PdfPageFormat) builder}) {
    return Selector<PrintSettingLargeScreenProvider, PdfPageFormat>(
      builder: (_, selectedFormat, __) {
        debugPrint(
            "BasePdfPageConsumer Selector => getPdfPageSelectedFormatConsumer");
        return builder(_, selectedFormat);
      },
      selector: (ctx, provider) => provider.getSelectedFormat,
    );
  }

  void notifyNewSelectedFormat(
      BuildContext context, PdfPageFormat selectedFormat) {
    printSettingListener.setSelectedFormat = selectedFormat;
  }

  void notifyToggleFloatingButton(BuildContext context, {bool? isExpaned}) {
    if (isExpaned != null) {
      printSettingListener.setFloatActionIsExpanded = isExpaned;
    }
    printSettingListener.toggleFloatingActionIsExpanded();
  }

  void notifyNewViewAbstract(BuildContext context, ViewAbstract? viewAbstract) {
    printSettingListener.setViewAbstract = viewAbstract;
  }

  Widget getPdfPageConsumer(BuildContext context) {
    return Selector<PrintSettingLargeScreenProvider, ViewAbstract?>(
      builder: (_, provider, __) {
        debugPrint("BasePdfPageConsumer Selector =>  getPdfPageConsumer");
        return getFutureBody(context);
      },
      selector: (ctx, provider) => provider.getViewAbstract,
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
          child: Center(child: getPdfPageConsumer(context)),
        )
      ],
    );
  }
}

class PrintSettingLargeScreenProvider with ChangeNotifier {
  ViewAbstract? _viewAbstract;
  bool _floatActionIsExpanded = false;

  PdfPageFormat _selectedFormat = PdfPageFormat.a4;

  set setSelectedFormat(PdfPageFormat selectedFormat) {
    _selectedFormat = selectedFormat;
    notifyListeners();
  }

  set setFloatActionIsExpanded(bool expanded) {
    _floatActionIsExpanded = expanded;
    notifyListeners();
  }

  set setViewAbstract(ViewAbstract? viewAbstract) {
    if (viewAbstract == null) return;
    _viewAbstract = viewAbstract;
    notifyListeners();
  }

  void toggleFloatingActionIsExpanded() {
    _floatActionIsExpanded = !_floatActionIsExpanded;
    notifyListeners();
  }

  bool get getFloatActionIsExpanded {
    return _floatActionIsExpanded;
  }

  PdfPageFormat get getSelectedFormat => _selectedFormat;

  ViewAbstract? get getViewAbstract {
    return _viewAbstract;
  }
}
