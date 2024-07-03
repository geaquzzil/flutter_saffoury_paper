import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HeaderMain extends StatefulWidget {
  const HeaderMain({
    super.key,
  });

  @override
  State<HeaderMain> createState() => _HeaderMainState();
}

class _HeaderMainState extends State<HeaderMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.read<DrawerMenuControllerProvider>().getObject;

    // return ProfileMenu(icon: "", text: "dsa", press: () {});
    // return  SearchWidgetApi();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                    label: Text(
                        "${AppLocalizations.of(context)!.add_new} ${context.watch<LargeScreenPageProvider>().getCurrentPageTitle(context)}")),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                // Badge(
                //   badgeContent:
                //       Text("${context.watch<CartProvider>().getCount}"),
                //   toAnimate: true,
                //   animationType: BadgeAnimationType.scale,
                //   showBadge: context.watch<CartProvider>().getCount > 0,
                //   child: RoundedIconButton(
                //       onTap: () {
                //         // context
                //         //     .read<EndDrawerProvider>()
                //         //     .change();
                //         context
                //             .read<DrawerMenuControllerProvider>()
                //             .controlEndDrawerMenu();
                //       },
                //       // onTap: () => context
                //       //     .read<EndDrawerProvider>()
                //       //     .changeAndOpen(context, BaseHomeCartPage()),
                //       icon: Icons.shopping_cart_rounded),
                // ),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                // CartPopupWidget(),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                NotificationPopupWidget(),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                const ProfilePicturePopupMenu(),
              ],
            )));
  }
}
