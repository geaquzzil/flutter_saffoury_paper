import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:go_router/go_router.dart';

import 'ext.dart';

class SettingAndProfileWebPage extends BaseWebPageSlivers {
  String? currentSetting;
  SettingAndProfileWebPage({super.key, this.currentSetting});
  Widget? currentWidget;

  @override
  Widget getScaffold(BuildContext context) {
    if (currentSetting != null) {
      currentWidget = getWidgetFromProfile(
          context,
          getListOfProfileSettings(context)
              .firstWhereOrNull((p0) => p0.title == currentSetting!),
          true);
    }
    if (currentWidget is MasterToListFromProfile) {
      return MasterToListFromProfile(
        pinToolbar: true,
        buildHeader: true,
        buildFooter: true,
        useSmallFloatingBar: false,
      );
    }
    return super.getScaffold(context);
  }

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      if (currentWidget != null)
        getSliverPadding(
            context,
            constraints,
            SliverFillRemaining(
                child: Center(
              child: SizedBox(
                height: 500,
                child: currentWidget,
              ),
            ))),
      if (currentSetting == null)
        getSliverPadding(
            context,
            constraints,
            SliverToBoxAdapter(
              child: ClipRect(
                child: Container(
                  // height: 200,
                  color:
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
                  child: ProfileMenuWidget(
                    selectedValueVoid: (value) {
                      if (value == null) {
                        context.goNamed(
                          indexWebSettingAndAccount,
                        );
                      } else {
                        context.goNamed(indexWebSettingAndAccount,
                            queryParameters: {"action": value.title});
                      }
                    },
                  ),
                ),
              ),
            ))
    ];
  }
}
