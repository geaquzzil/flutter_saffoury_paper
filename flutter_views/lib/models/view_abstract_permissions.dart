import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';

abstract class ViewAbstractPermissions<T>{
  static const String ADMIN_ID="-1";
  String iD = "-1";
Future<bool> hasPermissionToPreformActionOn(BuildContext context,
  String field, ServerActions actions) {
        print( "hasPermissionToPreformActionOn: " + " field " + field + "  action " + actions.toString());
        PermissionField permissionField = getPermission(field);
        if (permissionField == null) {
            print(  "hasPermissionToPreformActionOn: " + " PermissionField ==null  " + field.getName() + "  action " + actions.toString());
            return true;
        }
     print( "hasPermissionToPreformActionOn: " + " PermissionField " + field.getName() + "  permissionField " + permissionField.table_name());
        if (isEmpty(permissionField.table_name())) return false;
        return hasPermission(permissionField.table_name(), actions);
    }
Future<bool> hasPermission( dynamic toDo,ServerActions? action) async {
    if (action == null) action = ServerActions.view;
    PermissionLevelAbstract permissionLevelAbstract = getUserPermissionLevel();
    if (permissionLevelAbstract == null) {
      //todo why is null here ?
      print("hasPermission: " +
          "permissionLevelAbstract is null ? " +
          this.toString());
      return true;
    } else {
      if (getUserPermissionLevel().isAdmin()) {
        print("hasPermission: " +
            "Admin Permission for " +
            toDo.toString() +
            " to Action " +
            action.toString());
        return true;
      }
    }
    List<?> PermissionActions = getUserPermissionLevel().getPermissions_levels();//  PermissionLevel.GetValue < IList > ("permissions_levels");
            print( "hasPermission: " + "Checking Pe|rmission for " + toDo.toString() + " to Action " + action.toString() + "  Count" + PermissionActions.size());
        if (PermissionActions.isEmpty()) {
            return false;
        }
        PermissionActionAbstract foundedPermission = getUserPermissionLevel().findCurrentPermission(toDo);
        if (foundedPermission == null) {
            if (toDo is String) {
                return false;
            }
            RestOption restOption = Objects.getAnnotation(toDo, RestOption.class);
            if (restOption == null) {
                return true;
            }
            return false;
        }
        if (toDo is String) {
              print( "hasPermission: " + "founded permissio" + (foundedPermission.view == 1 || foundedPermission.list == 1));
            return foundedPermission.view == 1 || foundedPermission.list == 1;
        } else {
            return    Objects.getValue(foundedPermission, action.toString(), Integer.class) == 1;
        }
  }

     Future<bool> hasPermissionImport({ViewAbstract? viewAbstract}) async {
        return    viewAbstract==null? await hasPermission(this , ServerActions.add):
        await hasPermission(viewAbstract , ServerActions.add);
        
    }

          Future<bool> hasPermissionDelete({ViewAbstract? viewAbstract})async {
            if(viewAbstract==null){
                  if (isNew()) return false;
        if (hasPerantViewAbstrct()) return false;
        return await hasPermission(this , ServerActions.delete_action);
            }
                  if (viewAbstract.isNew()) return false;
        if (viewAbstract.hasPerantViewAbstrct()) return false;
                return await hasPermission(viewAbstract , ServerActions.delete_action);
    }

          Future<bool> hasPermissionAdd({ViewAbstract? viewAbstract})async {
         return    viewAbstract==null? await hasPermission(this , ServerActions.add):
        await hasPermission(viewAbstract , ServerActions.add);
    }

          Future<bool> hasPermissionEdit({ViewAbstract? viewAbstract})async {
       return    viewAbstract==null? await hasPermission(this , ServerActions.edit):
        await hasPermission(viewAbstract , ServerActions.edit);
    }
  Future<bool> hasPermissionEditPrint({ViewAbstract? viewAbstract})async {
  return    viewAbstract==null? await hasPermission(this , ServerActions.print):
        await hasPermission(viewAbstract , ServerActions.print);
    }
    PermissionLevelAbstract getUserPermissionLevel(BuildContext context){
     return  context.read<AuthProvider>().getPermissions;
    }
     bool hasPerantViewAbstrct() {
        return getParent() != null;
    }
    Future<bool>  hasPermissionDelete({ViewAbstract? viewAbstract})async {
        if (isNew()) return false;
        if (hasPerantViewAbstrct()) return false;
          return    viewAbstract==null? await hasPermission(this , ServerActions.delete_action):
        await hasPermission(viewAbstract , ServerActions.delete_action);
    }

     bool isAdmin(BuildContext context) => getUserPermissionLevel(context).iD == ADMIN_ID;

  bool isGuest(BuildContext context) =>  getUserPermissionLevel(context).iD == "0";

  bool isGeneralClient(BuildContext context) => int.parse( getUserPermissionLevel(context).iD) > 0;

  bool isGeneralEmployee(BuildContext context) => int.parse( getUserPermissionLevel(context).iD) < 0;
    
bool isEditing() {
        return iD != "-1";
    }

    bool isNew() {
        return iD == "-1";
    }
}