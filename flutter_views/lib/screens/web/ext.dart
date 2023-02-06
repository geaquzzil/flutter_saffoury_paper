import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/web/models/header_item.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';

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
