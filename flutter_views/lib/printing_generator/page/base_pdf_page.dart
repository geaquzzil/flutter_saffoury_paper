import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/base_api_call_screen.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

abstract class BasePdfPage extends StatefulWidget {
  const BasePdfPage({super.key});
}

abstract class BasePdfPageState<T extends BasePdfPage, C>
    extends BaseApiCallPageState<T, C> {
  BasePdfPageState({super.iD, super.tableName, super.extras});

  Widget getFloatingActions(BuildContext context);

  Widget getFutureBody(BuildContext context, C newObject, PdfPageFormat format);
  Future<ViewAbstract?>? getSettingObject(BuildContext context);
  ViewAbstract getMainObject();
  late PrintSettingLargeScreenProvider printSettingListener;
  // bool hasSetting

  @override
  Widget buildAfterCall(BuildContext context, C newObject) {
    return TowPaneExt(
      // startPane: SizeConfig.isMobile(context)
      //     ? getFirstPane(context, newObject)
      //     : (getEndPane(context) ?? getFirstPane(context, newObject)),
      startPane: getFirstPane(context, newObject),
      endPane: null,
    );
  }

  @override
  void initState() {
    super.initState();
    printSettingListener =
        Provider.of<PrintSettingLargeScreenProvider>(context, listen: false);
  }

  Widget? getEndPane(BuildContext context) {
    var future = getSettingObject(context);
    if (future == null) return null;
    // return null;

    return FutureBuilder<ViewAbstract?>(
      future: future,
      builder: (_, snapshot) {
        return Scaffold(
          body: BaseEditWidget(
            isTheFirst: true,
            viewAbstract: snapshot.data as ViewAbstract,
            onValidate: (viewAbstract) {
              debugPrint("BasePdfPageConsumer new viewAbstract $viewAbstract");

              if (viewAbstract != null) {
                notifyNewViewAbstract(viewAbstract.getCopyInstance());
                // Configurations.save(
                //     "_printsetting${getMainObject().runtimeType}",
                //     viewAbstract);
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

  void notifyNewViewAbstract(ViewAbstract? viewAbstract) {
    printSettingListener.setViewAbstract = viewAbstract;
  }

  Widget getPdfPageConsumer(BuildContext context, C newObject) {
    return Selector<PrintSettingLargeScreenProvider,
        Tuple2<ViewAbstract?, PdfPageFormat>>(
      builder: (_, provider, __) {
        debugPrint("BasePdfPageConsumer Selector =>  getPdfPageConsumer");
        return getFutureBody(context, newObject, provider.item2);
      },
      selector: (ctx, provider) =>
          Tuple2(provider.getViewAbstract, provider.getSelectedFormat),
    );
  }

  Widget getFirstPane(BuildContext context, C newObject) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getFloatingActions(context),
        body: getPdfPreview(context, newObject));
  }

  CustomScrollView getPdfPreview(BuildContext context, C newObject) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: true,
          elevation: 4,
          leading: BackButton(onPressed: () => context.goNamed(homeRouteName)),
          pinned: true,
          primary: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(getMainObject().getPritablePageTitle(context)),
          ),
        ),
        SliverFillRemaining(
          child: Center(child: getPdfPageConsumer(context, newObject)),
        )
      ],
    );
  }
}

class PrintSettingLargeScreenProvider with ChangeNotifier {
  ViewAbstract? _viewAbstract;
  bool _floatActionIsExpanded = false;

  PdfPageFormat _selectedFormat = PdfPageFormat.a4;

  int get hasho {
    return Object.hash(
      fromPage,
      toPage,
      _length,
    );
  }

  int? fromPage;
  int? toPage;

  int? _length;

  void init(int length) {
    if (length == -1) {
      _length = null;
      fromPage = null;
      toPage = null;
      return;
    }
    _length = length;
    fromPage = 0;
    toPage = _length;
  }

  List<int> generateListOfPage() {
    debugPrint("generateListOfPage from $fromPage to $toPage");
    if (fromPage == toPage) {
      return [fromPage!];
    }
    List<int> l = [];
    for (var i = fromPage!; i < toPage!; i++) {
      l.add(i);
    }
    debugPrint("generateListOfPage $l");
    return l;
  }

  void setFromToPage({int? from, int? to}) {
    if (from != null) {
      fromPage = from;
    }
    if (to != null) {
      toPage = to;
    }
    notifyListeners();
  }
//   List<int>? getPages(){
//     if(fromPage==null) || toPage==null){
//       return
//     }
//   }

  // set setPages(List<int>? value) => _pages = value;

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
