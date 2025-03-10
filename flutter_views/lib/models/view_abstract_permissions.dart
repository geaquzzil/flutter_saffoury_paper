// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import 'permissions/user_auth.dart';

abstract class ViewAbstractPermissions<T> extends VMirrors<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? fieldNameFromParent;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ViewAbstract? parent;
  @JsonKey(includeFromJson: false, includeToJson: false)
  static const int ADMIN_ID = -1;

  @JsonKey(includeFromJson: false, includeToJson: false)
  static const int REEL_CUTTER = -14;

  @JsonKey(includeFromJson: false, includeToJson: false)
  static const int PALLET_CUTTER = -15;
  @JsonKey(includeFromJson: false, includeToJson: false)
  static const int POS = -11;

  @JsonKey(includeFromJson: false, includeToJson: false)
  static const int GOODS_INVENTORY_WORKER = -16;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isNull = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isNullTriggerd = false;
  @JsonKey(
    fromJson: convertToMinusOneIfNotFound,
  )
  int iD = -1;

  ViewAbstract? get getParent => parent;
  String? get getFieldNameFromParent => fieldNameFromParent;

  static int convertToMinusOneIfNotFound(dynamic number) =>
      number == null ? -1 : (int.tryParse(number.toString()) ?? -1);
  Map<String, String> getPermissionFieldsMap(BuildContext context) {
    return {};
  }

  String? _getPermissionField(BuildContext context, String field) {
    return getPermissionFieldsMap(context)[field];
  }

  Future<bool> hasPermissionOnField(
      BuildContext context, String field, ServerActions? actions) async {
    debugPrint(
        "hasPermissionToPreformActionOn:  field $field  action $actions");
    String? permissionField = _getPermissionField(context, field);
    if (permissionField == null) {
      debugPrint(
          "hasPermissionToPreformActionOn:  PermissionField ==null  $field  action $actions");
      return true;
    }
    // debugPrint(
    //     "hasPermissionToPreformActionOn: " + " $permissionField " + field  permissionField " );
    // if (isEmpty(permissionField.table_name())) return false;
    return hasPermission(context, permissionField, actions);
  }

  bool hasPermission(
      BuildContext context, dynamic toDo, ServerActions? action) {
    return true;
    action ??= ServerActions.view;

    debugPrint("checking hasPermission started for $toDo");
    if (isAdmin(context)) {
      debugPrint("hasPermission: Admin Permission for $toDo to Action $action");
      return true;
    }
    List<PermissionActionAbstract> PermissionActions = getPermssionActions(
        context); //  PermissionLevel.GetValue < IList > ("permissions_levels");
    debugPrint(
        "hasPermission: Checking Pe|rmission for $toDo to Action $action  Count  ${PermissionActions.length} ");
    if (PermissionActions.isEmpty) {
      return false;
    }
    PermissionActionAbstract? foundedPermission =
        findCurrentPermission(context, toDo);
    if (foundedPermission == null) {
      if (toDo is String) {
        return false;
      }
      // RestOption restOption = Objects.getAnnotation(toDo, RestOption.class);
      // if (restOption == null) {
      //     return true;
      // }
      return false;
    }
    if (toDo is String) {
      debugPrint(
          "hasPermission: " "founded permissio ${foundedPermission.view} ");
      return foundedPermission.view == 1 || foundedPermission.list == 1;
    } else {
      return getPermissionActionValueFromServerAction(
              foundedPermission, action) ==
          1;
    }
  }

  int getPermissionActionValueFromServerAction(
      PermissionActionAbstract action, ServerActions serverActions) {
    if (serverActions == ServerActions.add) {
      return action.add ?? 0;
    } else if (serverActions == ServerActions.edit) {
      return action.edit ?? 0;
    } else if (serverActions == ServerActions.delete_action) {
      return action.delete_action ?? 0;
    } else if (serverActions == ServerActions.print) {
      return action.print ?? 0;
    } else if (serverActions == ServerActions.notification) {
      return action.notification ?? 0;
    } else if (serverActions == ServerActions.print) {
      return action.print ?? 0;
    } else if (serverActions == ServerActions.view) {
      return action.view ?? 0;
    } else {
      return 0;
    }
  }

  bool hasPermissionList(BuildContext context, {ViewAbstract? viewAbstract}) {
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.list)
        : hasPermission(context, viewAbstract, ServerActions.list);
  }

  bool hasPermissionImport(BuildContext context, {ViewAbstract? viewAbstract}) {
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.add)
        : hasPermission(context, viewAbstract, ServerActions.add);
  }

  bool hasPermissionAdd(BuildContext context, {ViewAbstract? viewAbstract}) {
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.add)
        : hasPermission(context, viewAbstract, ServerActions.add);
  }

  //todo permission check and check if the object is implemented the interface
  bool hasPermissionShare(BuildContext context, {ViewAbstract? viewAbstract}) {
    return true;
  }

  bool hasPermissionView(BuildContext context, {ViewAbstract? viewAbstract}) {
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.view)
        : hasPermission(context, viewAbstract, ServerActions.view);
  }

  bool hasPermissionEdit(BuildContext context, {ViewAbstract? viewAbstract}) {
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.edit)
        : hasPermission(context, viewAbstract, ServerActions.edit);
  }

  bool hasPermissionFromParentSelectItem(
      BuildContext context, ViewAbstract viewAbstract) {
    debugPrint("hasPermissionFromParentSelectItem fromParent=> $parent");
    return true;
  }

  bool isPrintableMaster() {
    return this is PrintableMaster;
  }

  bool hasPermissionPrint(BuildContext context, {ViewAbstract? viewAbstract}) {
    if (!isPrintableMaster()) return false;
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.print)
        : hasPermission(context, viewAbstract, ServerActions.print);
  }

  PermissionActionAbstract? findCurrentPermission(
      BuildContext context, dynamic toDo) {
    PermissionLevelAbstract permissionLevelAbstract =
        getUserPermissionLevel(context);

    return permissionLevelAbstract.findPermissionBy(toDo);
  }

  List<PermissionActionAbstract> getPermssionActions(BuildContext context) {
    return getUserPermissionLevel(context).permissions_levels ?? [];
  }

  PermissionLevelAbstract getUserPermissionLevel(BuildContext context) {
    return context.read<AuthProvider<AuthUser>>().getPermissions;
  }

  FutureBuilder<E> onFutureBuilder<E>(BuildContext context,
      {required Future<E> function,
      required Widget Function(E data) onHasPermissionWidget}) {
    return FutureBuilder<E>(
      future: function,
      builder: (context, AsyncSnapshot<E> snapshot) {
        if (snapshot.data == false) {
          return Container();
        } else {
          if (snapshot.data != null) {
            return onHasPermissionWidget(snapshot.data as E);
          } else {
            return Container();
          }
        }
      },
    );
  }

  //  bool hasPerantViewAbstrct() {
  //     return getParent() != null;
  // }
  bool hasPermissionDelete(BuildContext context, {ViewAbstract? viewAbstract}) {
    if (isNew()) return false;
    // if (hasPerantViewAbstrct()) return false;
    return viewAbstract == null
        ? hasPermission(context, this, ServerActions.delete_action)
        : hasPermission(context, viewAbstract, ServerActions.delete_action);
  }

  bool isReelCutter(BuildContext context) =>
      getUserPermissionLevel(context).iD == REEL_CUTTER || isAdmin(context);

  bool isPOS(BuildContext context) =>
      getUserPermissionLevel(context).iD == POS || isAdmin(context);

  bool isPalletCutter(BuildContext context) =>
      getUserPermissionLevel(context).iD == PALLET_CUTTER || isAdmin(context);

  bool isAdmin(BuildContext context) =>
      getUserPermissionLevel(context).iD == ADMIN_ID;

  bool isGoodsInventoryWorker(BuildContext context) =>
      getUserPermissionLevel(context).iD == GOODS_INVENTORY_WORKER ||
      isAdmin(context);

  bool isGuest(BuildContext context) => getUserPermissionLevel(context).iD == 0;

  bool isGeneralClient(BuildContext context) =>
      getUserPermissionLevel(context).iD > 0;

  bool isGeneralEmployee(BuildContext context) =>
      getUserPermissionLevel(context).iD < 0;

  bool isEditing() {
    return iD != -1;
  }

  bool isNew() {
    return iD == -1;
  }

  bool hasParent() {
    return parent != null;
  }

  void setParent(ViewAbstract? parent) {
    this.parent = parent;
    if (getFieldNameFromParent != null) {
      isNull = isNullableAlreadyFromParentCheck(getFieldNameFromParent!);
    }
  }

  void toggleIsNullable() {
    isNull = !isNull;
    isNullTriggerd = !isNullTriggerd;
  }

  bool isNullableAlreadyFromParentCheck(String field) {
    return getParent?.getFieldValue(field) == null;
  }

  void setFieldNameFromParent(String? fieldNameFromParent) =>
      this.fieldNameFromParent = fieldNameFromParent;
}
