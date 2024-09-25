import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/models/header_item.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Text getWebText(
    {required String title, double fontSize = 35, Color color = Colors.white}) {
  return Text(
    title,
    style: GoogleFonts.roboto(
      color: color,
      fontWeight: FontWeight.w900,
      height: 1.3,
      fontSize: fontSize,
    ),
  );
}

launchMailtoSaffouryPaperCustom(String email, String body) async {
  final mailtoLink = Mailto(
    to: [email],
    // cc: ['cc1@example.com', 'cc2@example.com'],
    subject: 'Hello $body',
    // body: 'mailto example body',
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}

Widget getWidgetFromProfile(
    {required BuildContext context,
    ActionOnToolbarItem? value,
    required bool pinToolbar,
     ValueNotifier<ActionOnToolbarItem?>? valueNotifier}) {
  if (value == null) {
    return const Center(
      child: Text("Select setting to show"),
    );
  }
  if (value.icon == Icons.logout) {
    return const Logout();
  } else if (value.icon == Icons.help_outline_rounded) {
    return const Help();
  } else if (value.icon == Icons.account_box_outlined) {
    return const ProfileEdit();
  } else if (value.icon == Icons.shopping_basket_rounded) {
    return MasterToListFromProfile(
      pinToolbar: pinToolbar,
      valueNotiferActionOnToolbarItem: valueNotifier,
    );
  }
  return const Center(
    child: Text("not seleting setting to show"),
  );
}

List<HeaderItem> getHeaderItems(BuildContext context) => [
      HeaderItem(
        title: AppLocalizations.of(context)!.home.toUpperCase(),
        iconData: Icons.home_outlined,
        iconDataSelected: Icons.home,
        onClick: () {
          context.goNamed(indexWebRouteName);
        },
      ),
      HeaderItem(
        title: "SHOP",
        iconData: Icons.shopping_basket_outlined,
        iconDataSelected: Icons.shopping_basket_rounded,
        onClick: () {
          context.goNamed(indexWebOurProducts);
        },
      ),
      // HeaderItem(
      //   title: "SERVICES",
      //   iconData: Icons.supervised_user_circle_outlined,
      //   iconDataSelected: Icons.supervised_user_circle,
      //   onClick: () {
      //     context.goNamed(indexWebServices);
      //   },
      // ),
      HeaderItem(
        title: AppLocalizations.of(context)!.contactUs.toUpperCase(),
        iconData: Icons.contact_support_outlined,
        iconDataSelected: Icons.contact_support_rounded,
        onClick: () {
          context.goNamed(indexWebContactUs);
        },
      ),
      HeaderItem(
        title: AppLocalizations.of(context)!.about.toUpperCase(),
        iconData: Icons.question_answer_outlined,
        iconDataSelected: Icons.question_answer,
        onClick: () {
          context.goNamed(indexWebAboutUs);
        },
      ),
      if (context.read<AuthProvider<AuthUser>>().getStatus !=
          Status.Authenticated)
        HeaderItem(
          title: AppLocalizations.of(context)!.log_in,
          iconData: Icons.login,
          iconDataSelected: Icons.login_rounded,
          onClick: () {
            context.goNamed(loginRouteName);
          },
          isButton: true,
        ),
    ];
