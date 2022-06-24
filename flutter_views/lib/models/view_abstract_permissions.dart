import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class ViewAbstractPermissions<T>{
  String iD = "-1";
Future<bool> hasPermissionToPreformActionOn(Field field, ServerActions actions) {
        Log.e(TAG, "hasPermissionToPreformActionOn: " + " field " + field.getName() + "  action " + actions.toString());
        PermissionField permissionField = getPermission(field);
        if (permissionField == null) {
            Log.e(TAG, "hasPermissionToPreformActionOn: " + " PermissionField ==null  " + field.getName() + "  action " + actions.toString());
            return true;
        }
        Log.e(TAG, "hasPermissionToPreformActionOn: " + " PermissionField " + field.getName() + "  permissionField " + permissionField.table_name());
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
        Log.e(TAG, "hasPermission: " + "Checking Pe|rmission for " + toDo.toString() + " to Action " + action.toString() + "  Count" + PermissionActions.size());
        if (PermissionActions.isEmpty()) {
            return false;
        }
        PermissionActionAbstract foundedPermission = getUserPermissionLevel().findCurrentPermission(toDo);
        if (foundedPermission == null) {
            if (toDo instanceof String) {
                return false;
            }
            RestOption restOption = Objects.getAnnotation(toDo, RestOption.class);
            if (restOption == null) {
                return true;
            }
            return false;
        }
        if (toDo is String) {
           print(TAG, "hasPermission: " + "founded permissio" + (foundedPermission.view == 1 || foundedPermission.list == 1));
            return foundedPermission.view == 1 || foundedPermission.list == 1;
        } else {
            return    Objects.getValue(foundedPermission, action.toString(), Integer.class) == 1;
        }
  }

     bool hasPermissionImport(ViewAbstract viewAbstract) {
        return hasPermission(viewAbstract, ServerActions.add);
    }

     bool hasPermissionDelete(ViewAbstract viewAbstract) {
        return hasPermission(viewAbstract, ServerActions.delete_action);
    }

     bool hasPermissionAdd(ViewAbstract viewAbstract) {
        return hasPermission(viewAbstract, ServerActions.add);
    }

     bool hasPermissionEdit(ViewAbstract viewAbstract) {
        return hasPermission(viewAbstract, ServerActions.edit);
    }

     bool hasPerantViewAbstrct() {
        return getParent() != null;
    }
    bool hasPermissionDelete() {
        if (isNew()) return false;
        if (hasPerantViewAbstrct()) return false;
        return hasPermission(this, Enums.ServerActions.delete_action);
    }
     bool isAdmin() {
        return getUserPermissionLevel().isAdmin();
    }

    bool isGeneralEmployee() {
        return getUserPermissionLevel().isGeneralEmployee();
    }

    bool isGeneralClient() {
        return getUserPermissionLevel().isGeneralClient();
    }

    bool isGuest() {
        return getUserPermissionLevel().isGuest();
    }
bool isEditing() {
        return iD != "-1";
    }

    bool isNew() {
        return iD == "-1";
    }
}