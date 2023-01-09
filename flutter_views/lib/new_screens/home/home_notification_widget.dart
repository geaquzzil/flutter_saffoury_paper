import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_shared_with_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import '../../providers/actions/action_viewabstract_provider.dart';
import '../lists/components/search_components.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'components/notifications/notification_popup.dart';

class HomeNotificationPage extends BaseHomeSharedWithWidgets {
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
    return EdgeInsets.symmetric(horizontal: 100);
  }

  @override
  EdgeInsets? hasMainBodyPadding(BuildContext context) {
    return null;
  }

  @override
  void init(BuildContext context) {}
}
