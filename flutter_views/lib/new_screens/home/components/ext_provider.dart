import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'profile/profile_pic_popup_menu.dart';

List<ItemModel> getListOfProfileSettings(BuildContext context,
    {CustomPopupMenuController? controller}) {
  List<ItemModel> menuItems = [];
  AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
  if (authProvider.hasSavedUser) {
    menuItems = [
      ItemModel(authProvider.getUserName, Icons.chat_bubble),
      ItemModel(
          "${AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.profile}",
          Icons.account_box_outlined),
      ItemModel(
          AppLocalizations.of(context)!.orders, Icons.shopping_basket_rounded),
      //todo translate
      ItemModel('Chat', Icons.chat_bubble),
      //todo translate
      ItemModel("Help", Icons.help_outline_rounded),
      ItemModel(AppLocalizations.of(context)!.logout, Icons.logout),
    ];
  } else {
    menuItems = [
      ItemModel(AppLocalizations.of(context)!.action_sign_in_short, Icons.login,
          onPress: () {
        debugPrint("onPress sing_in");
        controller?.hideMenu();
        context.goNamed(kIsWeb ? indexWebSignIn : loginRouteName);
      }),
    ];
  }
  return menuItems;
}

void notifyListApi(BuildContext context) {
  ViewAbstract? v =
      context.read<DrawerMenuControllerProvider>().getObjectCastViewAbstract;
  v.setFilterableMap(context.read<FilterableProvider>().getList);
  debugPrint(
      "notifyListApi viewAbstract ${v.getTableNameApi()} customMap ${v.getCustomMap}");
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

void addFilterableSort(BuildContext context, SortByType selectedItem) {
  context.read<FilterableProvider>().addSortBy(context, selectedItem);
}

void addFilterableSortField(
    BuildContext context, String selectedItem, String selectedItemMainValue) {
  context
      .read<FilterableProvider>()
      .addSortFieldName(context, selectedItem, selectedItemMainValue);
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

List<FilterableProviderHelper> getAllSelectedFiltersRead(BuildContext context) {
  var list = context.read<FilterableProvider>().getList.values.toList();
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
