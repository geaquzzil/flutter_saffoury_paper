import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cartable_draggable_header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/setting/list_sticky_setting_page.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class SettingPageNew extends StatefulWidget {
  bool buildDrawer;
  SettingPageNew({super.key, this.buildDrawer = false});

  @override
  State<SettingPageNew> createState() => _SettingPageNewState();
}

class _SettingPageNewState extends BasePageState<SettingPageNew> {
  late List<ModifiableInterface> _modifieableList;

  late List<TitleAndDescription> _titleAndDescription;
  @override
  void initState() {
    buildDrawer = widget.buildDrawer;
    _modifieableList =
        context.read<SettingProvider>().getModifiableListSetting(context);

    _titleAndDescription = [
      TitleAndDescription(title: "GENERAL"),
      TitleAndDescription(title: "GENERAL"),
      TitleAndDescription(title: "GENERAL"),

    ];
    super.initState();
  }

  @override
  Widget? getBaseAppbar() => null;
  @override
  List<Widget>? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;
  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getDesktopSecondPane(tab: tab, secoundTab: secoundTab);

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    // List<Widget> widgets = List.empty(growable: true);
    // var list = getExtrasCastDashboard(tab: tab).getDashboardSectionsFirstPane(
    //     context, getCrossAxisCount(getWidth),
    //     tab: tab, globalKey: globalKeyBasePageWithApi);
    // if (list is List<DashableGridHelper>) {
    //   for (var element in list) {
    //     GlobalKey buttonKey = GlobalKey();
    //     var group = [
    //       SectionItemHeader(
    //         context: context,
    //         dgh: element,
    //         buttonKey: buttonKey,
    //         child: getWidget(element),
    //       ),
    //       // SliverToBoxAdapter(child: getWidget(width, element))
    //     ];
    //     widgets.addAll(group);
    //   }
    // } else if (list is List<Widget>) {
    //   widgets.addAll(list);
    // } else {
    //   widgets.add(list);
    // }
    // return widgets;
  }

  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      Text("TODO");

  @override
  getFirstPane({TabControllerHelper? tab}) => getDesktopFirstPane(tab: tab);

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;

  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => firstPane;

  @override
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
          {TabControllerHelper? tab}) =>
      true;
  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => true;
}
