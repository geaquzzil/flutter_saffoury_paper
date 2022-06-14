import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/profile_menu.dart';
import 'package:flutter_view_controller/components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}

Body() {
  SingleChildScrollView(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        ProfilePic(),
        SizedBox(height: 20),
        ProfileMenu(
          text: "My Account",
          icon: "assets/icons/User Icon.svg",
          press: () => {},
        ),
        ProfileMenu(
          text: "Notifications",
          icon: "assets/icons/Bell.svg",
          press: () {},
        ),
        ProfileMenu(
          text: "Settings",
          icon: "assets/icons/Settings.svg",
          press: () {},
        ),
        ProfileMenu(
          text: "Help Center",
          icon: "assets/icons/Question mark.svg",
          press: () {},
        ),
        ProfileMenu(
          text: "Log Out",
          icon: "assets/icons/Log out.svg",
          press: () {},
        ),
      ],
    ),
  );
}
