import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/web/models/header_item.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
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

List<HeaderItem> getHeaderItems(BuildContext context) => [
      HeaderItem(
        title: AppLocalizations.of(context)!.home.toUpperCase(),
        onClick: () {
          context.goNamed(indexWebRouteName);
        },
      ),
      HeaderItem(
        title: AppLocalizations.of(context)!.product.toUpperCase(),
        onClick: () {
          context.goNamed(indexWebOurProducts);
        },
      ),
      HeaderItem(
        title: "SERVICES",
        onClick: () {
          context.goNamed(indexWebServices);
        },
      ),
      HeaderItem(
        title: AppLocalizations.of(context)!.about,
        onClick: () {
          context.goNamed(indexWebAboutUs);
        },
      ),
      HeaderItem(
        title: "LOG IN",
        onClick: () {
          context.goNamed(loginRouteName);
        },
        isButton: true,
      ),
    ];
