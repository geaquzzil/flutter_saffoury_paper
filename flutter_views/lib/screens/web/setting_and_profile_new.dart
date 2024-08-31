import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cartable_draggable_header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SettingPageNew extends StatefulWidget {
  bool buildDrawer;
  String? currentSettingPage;
  SettingPageNew(
      {super.key, this.buildDrawer = false, this.currentSettingPage});

  @override
  State<SettingPageNew> createState() => _SettingPageNewState();
}

class _SettingPageNewState extends BasePageState<SettingPageNew>
    with BasePageActionOnToolbarMixin {
  late List<ModifiableInterface> _modifieableList;
  late List<ActionOnToolbarItem> _items;
  String? _currentSettingPageMobile;
  late List<TitleAndDescription> _titleAndDescription;
  @override
  void initState() {
    buildDrawer = widget.buildDrawer;
    // _items=getListOfProfileSettings();
    _modifieableList =
        context.read<SettingProvider>().getModifiableListSetting(context);

    _titleAndDescription = [
      TitleAndDescription(title: "GENERAL"),
      TitleAndDescription(title: "GENERAL"),
      TitleAndDescription(title: "GENERAL"),
    ];
    _currentSettingPageMobile = widget.currentSettingPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _items = getListOfProfileSettings(context);
    return super.build(context);
  }

  ActionOnToolbarItem? getItemModel(String fromName) {
    return _items.firstWhereOrNull(
      (p0) => p0.actionTitle == fromName,
    );
  }

  @override
  void didUpdateWidget(covariant SettingPageNew oldWidget) {
    //
    setState(() {
      if (_currentSettingPageMobile != widget.currentSettingPage) {
        _currentSettingPageMobile = widget.currentSettingPage;
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  List<Widget>? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

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
      true;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setMainPageSuggestionPadding() =>
      isLargeScreenFromCurrentScreenSize(context);

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => true;

  @override
  ActionOnToolbarItem onActionInitial() {
    return ActionOnToolbarItem(
        actionTitle: AppLocalizations.of(context)!.action_settings);
  }

  @override
  getActionFirstPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem}) {
    bool isLarge = isLargeScreenFromCurrentScreenSize(context);
    if (_currentSettingPageMobile != null) {
      return getWidgetFromProfile(
          valueNotifier: ValueNotifier<ActionOnToolbarItem?>(null),
          context: context,
          value: getItemModel(_currentSettingPageMobile ?? ""),
          pinToolbar: true);
    }

    return ProfileMenuWidget(
      size: getCurrentScreenSize(),
      selectedValue: getOnActionAdd,
      // selectedValue: onActionAdd,
      // selectedValueVoid: !isLarge
      //     ? (value) {
      //         context.goNamed(settingsRouteName,
      //             queryParameters: {"page": value?.title});
      //       }
      //     : null,
    );
  }

  @override
  getActionSecondPane(bool isDesktop,
      {TabControllerHelper? tab,
      TabControllerHelper? secoundTab,
      ActionOnToolbarItem? selectedItem}) {
    return Center(
        child: getWidgetFromProfile(
            // valueNotifier: onActionAdd,
            context: context,
            value: selectedItem,
            pinToolbar: pinToolbar));
  }

  @override
  ValueNotifierPane getValueNotifierPane() => ValueNotifierPane.BOTH;
}
