import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/size_config.dart';

class SettingPageNew extends BasePageSecoundPaneNotifier {
  bool isFromMenu;
  String? currentSettingPage;
  SettingPageNew(
      {super.key,
      super.buildDrawer = false,
      this.currentSettingPage,
      this.isFromMenu = false,
      super.isFirstToSecOrThirdPane});

  @override
  State<SettingPageNew> createState() => _SettingPageNewState();
}

class _SettingPageNewState extends BasePageState<SettingPageNew>
    with BasePageSecoundPaneNotifierState {
  List<ActionOnToolbarItem>? menuItems;
  String? _currentSettingPageMobile;
  @override
  void initState() {
    _currentSettingPageMobile = widget.currentSettingPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    menuItems ??= getListOfProfileSettings(context);
    return super.build(context);
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  bool setPaneBodyPadding(bool firstPane) => false;

  @override
  bool setMainPageSuggestionPadding() => true;
  // isLargeScreenFromCurrentScreenSize(context);

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setClipRect(bool? firstPane) {
    if (firstPane == null) {
      return widget.isFromMenu;
    }
    return false;
  }

  // @override
  // ActionOnToolbarItem onActionInitial() {
  //   return ActionOnToolbarItem(
  //       actionTitle: AppLocalizations.of(context)!.action_settings);
  // }

  @override
  List<Widget>? getPaneNotifier(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab,
      SecondPaneHelper? valueNotifier}) {
    if (firstPane) {
      return [
        const SliverToBoxAdapter(child: ProfileHeaderListTileWidget()),
        const SliverToBoxAdapter(child: Divider()),
        SliverList(
            delegate: SliverChildBuilderDelegate((c, i) {
          bool isLarge = isLargeScreenFromScreenSize(getCurrentScreenSize());
          final item = menuItems![i];
          return OnHoverCardWithListTile(
              onTap: () {
                debugPrint("ListTileAdaptive");
                notify(SecondPaneHelper(title: item.actionTitle, value: item));
              },
              isSelected: lastItem?.value.hashCode == item.hashCode,
              child: ListTileAdaptive(
                  isLargeScreen: isLarge,
                  leading: Icon(
                    item.icon,
                    size: isLarge ? 15 : null,
                  ),
                  subtitle: isLarge
                      ? null
                      : Text("this is a description ${item.actionTitle}"),
                  title: Text(
                    item.actionTitle,
                    style:
                        isLarge ? Theme.of(context).textTheme.bodySmall : null,
                  )));
        }, childCount: menuItems!.length))
      ];
    }
    return [
      if (valueNotifier!.value.icon == Icons.logout)
        const Logout()
      else if (valueNotifier.value.icon == Icons.help_outline_rounded)
        const Help()
      else if (valueNotifier.value.icon == Icons.admin_panel_settings)
        const AdminSetting()
      else if (valueNotifier.value.icon == Icons.local_print_shop)
        PrintSetting(
          buildSecondPane: true,
          valueNotifierIfThirdPane: ValueNotifier(null),
        )
      else if (valueNotifier.value.icon == Icons.account_box_outlined)
        const ProfileEdit()
      else if (valueNotifier.value.icon == Icons.shopping_basket_rounded)
        MasterToListFromProfile(
          pinToolbar: pinToolbar,
        ),
    ]
        .map(
          (e) => SliverFillRemaining(
            child: e,
          ),
        )
        .toList();
  }

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getAppbarTitle({bool? firstPane, TabControllerHelper? tab}) {
    return null;
  }
}
