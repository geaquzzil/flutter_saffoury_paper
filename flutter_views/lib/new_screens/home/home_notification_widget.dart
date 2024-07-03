import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_shared_with_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomeNotificationPage extends BaseHomeSharedWithWidgets {
  HomeNotificationPage({super.key});

  @override
  Widget? getEndPane(BuildContext context) {
    return null;
  }

  @override
  Widget? getSilverAppBarTitle(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.notification,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
      leading: Icon(
        Icons.notifications_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  List<Widget>? getSliverAppBarActions(BuildContext context) {
    return null;
  }

  @override
  Widget? getSliverHeader(BuildContext context) {
    return null;
  }

  String title = "No New Notifications";
  String subtitle =
      "Check this section for updates exclusively offer and general notifications";
  String notifiactionLottie =
      "https://assets6.lottiefiles.com/packages/lf20_heejrebm.json";

  @override
  List<Widget> getSliverList(BuildContext context) {
    return [
      SliverFillRemaining(
        child: Center(
          child: EmptyWidget(
              lottiUrl: notifiactionLottie, title: title, subtitle: subtitle),
        ),
      )
    ];
  }

  @override
  EdgeInsets? hasBodyPadding(BuildContext context) {
    // return null;
    return const EdgeInsets.symmetric(horizontal: 100);
  }

  @override
  EdgeInsets? hasMainBodyPadding(BuildContext context) {
    return null;
  }

  @override
  void init(BuildContext context) {}
}
