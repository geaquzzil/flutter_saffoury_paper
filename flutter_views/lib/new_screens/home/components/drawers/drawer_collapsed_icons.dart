import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CollapsedIcons extends StatelessWidget {
  const CollapsedIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ElevatedButton.icon(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {},
        //     label: Text(
        //         "${AppLocalizations.of(context)!.add_new} ${context.watch<LargeScreenPageProvider>().getCurrentPageTitle(context)}")),
        // const SizedBox(
        //   width: kDefaultPadding / 2,
        // ),
        Badge(
          badgeContent: Text("${context.watch<CartProvider>().getCount}"),
          toAnimate: true,
          animationType: BadgeAnimationType.scale,
          showBadge: context.watch<CartProvider>().getCount > 0,
          child: RoundedIconButton(
              onTap: () {
                // context
                //     .read<EndDrawerProvider>()
                //     .change();
                context
                    .read<DrawerMenuControllerProvider>()
                    .controlEndDrawerMenu();
              },
              // onTap: () => context
              //     .read<EndDrawerProvider>()
              //     .changeAndOpen(context, BaseHomeCartPage()),
              icon: Icons.shopping_cart_rounded),
        ),
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
    );
  }
}
