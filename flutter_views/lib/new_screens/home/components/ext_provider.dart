import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

List<ActionOnToolbarItem> getListOfProfileSettings(BuildContext context,
    {CustomPopupMenuController? controller}) {
  List<ActionOnToolbarItem> menuItems = [];
  AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
  if (authProvider.isLoggedInN()) {
    menuItems = [
      if (authProvider.isAdmin(context))
        ActionOnToolbarItem(
            actionTitle: AppLocalizations.of(context)!.adminSetting,
            icon: Icons.admin_panel_settings),
      ActionOnToolbarItem(
          actionTitle: authProvider.getUserName, icon: Icons.chat_bubble),
      ActionOnToolbarItem(
          actionTitle:
              "${AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.profile}",
          icon: Icons.account_box_outlined),
      ActionOnToolbarItem(
          actionTitle: AppLocalizations.of(context)!.orders,
          icon: Icons.shopping_basket_rounded),
      // ActionOnToolbarItem(
      //     actionTitle: AppLocalizations.of(context)!.chat,
      //     icon: Icons.chat_bubble),
      ActionOnToolbarItem(
          actionTitle: AppLocalizations.of(context)!.printerSetting,
          icon: Icons.local_print_shop),
      ActionOnToolbarItem(
          actionTitle: AppLocalizations.of(context)!.help,
          icon: Icons.help_outline_rounded),
      ActionOnToolbarItem(
          actionTitle: AppLocalizations.of(context)!.logout,
          icon: Icons.logout),
    ];
  } else {
    menuItems = [
      ActionOnToolbarItem(
          actionTitle: AppLocalizations.of(context)!.action_sign_in_short,
          icon: Icons.login,
          onPress: () {
            debugPrint("onPress sing_in");
            controller?.hideMenu();
            context.goNamed(kIsWeb ? indexWebSignIn : loginRouteName);
          }),
    ];
  }
  return menuItems;
}

@Deprecated("")
void notifyListApi(BuildContext context) {
  ViewAbstract? v =
      context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract;
  // v.setFilterableMap(context.read<FilterableProvider>().getList);
  // debugPrint(
  //     "notifyListApi viewAbstract ${v.getTableNameApi()} customMap ${v.getCustomMap}");
  context.read<DrawerMenuControllerProvider>().change(
      context, v, DrawerMenuControllerProviderAction.list,
      changeWithFilterable: true);
}

void notifyFilterableListApiIsCleared(BuildContext context) {
  ViewAbstract? v =
      context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract;
  context.read<DrawerMenuControllerProvider>().change(
      context, v.getSelfNewInstance(), DrawerMenuControllerProviderAction.list);
}

void addFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  addFilterableSelectedStringValue(
      context,
      selectedItem.getForeignKeyName(),
      selectedItem.getIDString(),
      selectedItem.getMainHeaderLabelTextOnly(context),
      selectedItem.getMainHeaderTextOnly(context));
}

void addFilterableSelectedStringValue(BuildContext context, String field,
    String value, String mainLabelName, String mainValueName) {
  context
      .read<FilterableProvider>()
      .add(field, field, value, mainValueName, mainLabelName);
}

void clearFilterableSelected(BuildContext context, String field) {
  context.read<FilterableProvider>().clear(field: field);
}

///TODO context.read deprecated
List<FilterableProviderHelper> getAllSelectedFiltersRead(BuildContext context,
    {Map<String, FilterableProviderHelper>? map}) {
  var list = map?.values.toList() ??
      context.read<FilterableProvider>().getList.values.toList();
  var listSelectd = list
      .map((master) => master.values
          .map((e) => FilterableProviderHelper(
              field: master.field,
              fieldNameApi: master.fieldNameApi,
              values: [e],
              mainFieldName: master.mainFieldName,
              mainValuesName: [
                master.mainValuesName[master.values.indexOf(e)]
              ]))
          .toList())
      .toList();
  List<FilterableProviderHelper> finalList = [];
  for (var element in listSelectd) {
    for (var element in element) {
      finalList.add(element);
    }
  }
  return finalList;
}

@Deprecated("will be removed in a future release")
List<FilterableProviderHelper> getAllSelectedFilters(BuildContext context,
    {Map<String, FilterableProviderHelper>? customFilters}) {
  var list = customFilters?.values.toList() ??
      context.watch<FilterableProvider>().getList.values.toList();
  var listSelectd = list
      .map((master) => master.values
          .map((e) => FilterableProviderHelper(
              field: master.field,
              fieldNameApi: master.fieldNameApi,
              values: [e],
              mainFieldName: master.mainFieldName,
              mainValuesName: [
                master.mainValuesName[master.values.indexOf(e)]
              ]))
          .toList())
      .toList();
  List<FilterableProviderHelper> finalList = [];
  for (var element in listSelectd) {
    for (var element in element) {
      finalList.add(element);
    }
  }
  return finalList;
}

void removeFilterableSelectedStringValue(
    BuildContext context, String field, String value, String mainValueName) {
  context
      .read<FilterableProvider>()
      .remove(field, value: value, mainValueName: mainValueName);
}

void removeFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  removeFilterableSelectedStringValue(context, selectedItem.getForeignKeyName(),
      selectedItem.getIDString(), selectedItem.getMainHeaderTextOnly(context));
}
