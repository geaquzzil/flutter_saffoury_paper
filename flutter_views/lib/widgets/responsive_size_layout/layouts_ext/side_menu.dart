import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'side_menu_items.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/Logo_Outlook.png",
                    width: 46,
                  ),
                  const Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!SizeConfig.isDesktop(context)) const CloseButton(),
                ],
              ),
              const SizedBox(height: kDefaultPadding),
              // TextButton.icon(
              //   minWidth: double.infinity,
              //   padding: const EdgeInsets.symmetric(
              //     vertical: kDefaultPadding,
              //   ),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   color: kPrimaryColor,
              //   onPressed: () {},
              //   icon: SvgPicture.asset("Icons/Edit.svg", width: 16),
              //   label: const Text(
              //     "New message",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ).addNeumorphism(
              //   topShadowColor: Colors.white,
              //   bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
              // ),
              // const SizedBox(height: kDefaultPadding),
              // FlatButton.icon(
              //   minWidth: double.infinity,
              //   padding: const EdgeInsets.symmetric(
              //     vertical: kDefaultPadding,
              //   ),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   color: kBgDarkColor,
              //   onPressed: () {},
              //   icon: SvgPicture.asset("Icons/Download.svg", width: 16),
              //   label: const Text(
              //     "Get messages",
              //     style: TextStyle(color: kTextColor),
              //   ),
              // ).addNeumorphism(),
              const SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              SideMenuItem(
                press: () {},
                title: "Inbox",
                iconSrc: "Icons/Inbox.svg",
                isActive: true,
                itemCount: 3,
              ),
              SideMenuItem(
                press: () {},
                title: "Sent",
                iconSrc: "Icons/Send.svg",
                isActive: false,
              ),
              SideMenuItem(
                press: () {},
                title: "Drafts",
                iconSrc: "Icons/File.svg",
                isActive: false,
              ),
              SideMenuItem(
                press: () {},
                title: "Deleted",
                iconSrc: "Icons/Trash.svg",
                isActive: false,
                showBorder: false,
              ),

              // SizedBox(height: kDefaultPadding * 2),
              // // Tags
              // Tags(),
            ],
          ),
        ),
      ),
    );
  }
}
