import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Faild
}

class AuthProvider with ChangeNotifier {
  AuthUser _user;
  Status _status = Status.Uninitialized;
  PermissionLevelAbstract _permissions;

  Status get getStatus => _status;
  AuthUser get getUser => _user;
  PermissionLevelAbstract get getPermissions => _permissions;

  // public variables
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  AuthProvider.initialize() {
    _init();
  }

  _init() async {
    bool hasUser = await Configurations.hasSavedValue(_user);
    if (hasUser == false) {
      _status = Status.Uninitialized;
    } else {
      _user = await Configurations.get<AuthUser>(_user);
      final responseUser =
          await _user.getRespones(serverActions: ServerActions.add);
      if (responseUser == null) {
        _status = Status.Faild;
      } else if (responseUser.statusCode == 401) {
        _status = Status.Faild;
      }else{
        _user=

      }
      await prefs.setString("id", firebaseUser.uid);

      _userModel = await _userServices.getAdminById(getUser.uid).then((value) {
        _status = Status.Authenticated;
        return value;
      });
    }
    notifyListeners();
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        await prefs.setString("id", value.getUser.uid);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  // Future<bool> signUp() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     await auth
  //         .createUserWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) async {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("id", result.user.uid);
  //       _userServices.createAdmin(
  //         id: result.user.uid,
  //         name: name.text.trim(),
  //         email: email.text.trim(),
  //       );
  //     });
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     print(e.toString());
  //     return false;
  //   }
  // }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel() async {
    _user = await _user.getAdminById(getUser.uid);
    notifyListeners();
  }

  String? validateEmail(String value) {
    value = value.trim();

    if (email.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }
}
