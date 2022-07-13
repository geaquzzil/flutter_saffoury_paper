import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/profile_menu.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_tow_childs.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}

Body() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        // const RoundedIconButtonTowChilds(),
        const SizedBox(height: 20),
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
