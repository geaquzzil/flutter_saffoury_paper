import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

abstract class ViewAbstractPermissions<T> extends VMirrors<T> {
  @JsonKey(ignore: true)
  String? fieldNameFromParent;
  @JsonKey(ignore: true)
  ViewAbstract? parent;
  @JsonKey(ignore: true)
  static const int ADMIN_ID = -1;

  int iD = -1;

  ViewAbstract? get getParnet => parent;
  String? get getFieldNameFromParent => fieldNameFromParent;

// Future<bool> hasPermissionToPreformActionOn(BuildContext context,
//   String field, ServerActions? actions) async{
//         print( "hasPermissionToPreformActionOn: " + " field " + field + "  action " + actions.toString());
//         PermissionField permissionField = getPermission(field);
//         if (permissionField == null) {
//             print(  "hasPermissionToPreformActionOn: " + " PermissionField ==null  " + field.getName() + "  action " + actions.toString());
//             return true;
//         }
//      print( "hasPermissionToPreformActionOn: " + " PermissionField " + field.getName() + "  permissionField " + permissionField.table_name());
//         if (isEmpty(permissionField.table_name())) return false;
//         return hasPermission(permissionField.table_name, actions);
//     }
  Future<bool> hasPermission(
      BuildContext context, dynamic toDo, ServerActions? action) async {
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
        await findCurrentPermission(context, toDo);
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

  Future<bool> hasPermissionList(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.list)
        : await hasPermission(context, viewAbstract, ServerActions.list);
  }

  Future<bool> hasPermissionImport(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.add)
        : await hasPermission(context, viewAbstract, ServerActions.add);
  }

  Future<bool> hasPermissionAdd(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.add)
        : await hasPermission(context, viewAbstract, ServerActions.add);
  }

  Future<bool> hasPermissionShare(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return true;
  }

  Future<bool> hasPermissionView(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.view)
        : await hasPermission(context, viewAbstract, ServerActions.view);
  }

  Future<bool> hasPermissionEdit(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.edit)
        : await hasPermission(context, viewAbstract, ServerActions.edit);
  }

  Future<bool> hasPermissionPrint(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    if (this is! PrintableMaster) return false;
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.print)
        : await hasPermission(context, viewAbstract, ServerActions.print);
  }

  Future<PermissionActionAbstract?> findCurrentPermission(
      BuildContext context, dynamic toDo) async {
    PermissionLevelAbstract permissionLevelAbstract =
        getUserPermissionLevel(context);

    return await permissionLevelAbstract.findPermissionBy(toDo);
  }

  List<PermissionActionAbstract> getPermssionActions(BuildContext context) {
    return getUserPermissionLevel(context).permissions_levels ?? [];
  }

  PermissionLevelAbstract getUserPermissionLevel(BuildContext context) {
    return context.read<AuthProvider>().getPermissions;
  }

  //  bool hasPerantViewAbstrct() {
  //     return getParent() != null;
  // }
  Future<bool> hasPermissionDelete(BuildContext context,
      {ViewAbstract? viewAbstract}) async {
    if (isNew()) return false;
    // if (hasPerantViewAbstrct()) return false;
    return viewAbstract == null
        ? await hasPermission(context, this, ServerActions.delete_action)
        : await hasPermission(
            context, viewAbstract, ServerActions.delete_action);
  }

  bool isAdmin(BuildContext context) =>
      getUserPermissionLevel(context).iD == ADMIN_ID;

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

  void setParent(ViewAbstract? parent) => this.parent = parent;
  void setFieldNameFromParent(String? fieldNameFromParent) =>
      this.fieldNameFromParent = fieldNameFromParent;
}
