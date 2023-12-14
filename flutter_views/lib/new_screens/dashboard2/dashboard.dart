import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/recent_files.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/storage_detail.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../actions/dashboard/compontents/header.dart';
import 'my_files.dart';

class DashboardPage extends StatelessWidget {
  DashableInterface dashboard;
  DashboardPage({Key? key, required this.dashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (dashboard as ViewAbstract).callApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dashboard = snapshot.data as DashableInterface;
          return getWidget(context);
        }
        return Center(
          child: EmptyWidget(
              lottiUrl:
                  "https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json",
              title: AppLocalizations.of(context)!.loading,
              subtitle: AppLocalizations.of(context)!.pleaseWait),
        );
      },
    );
  }

  SizedBox getWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const DashboardHeader(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      ...dashboard
                          .getDashboardSectionsFirstPane(context, 0)
                          .map((e) => MyFiles(
                                dgh: e,
                              ))
                          .toList(),
                      const RecentFiles(),
                      if (SizeConfig.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (SizeConfig.isMobile(context)) const StarageDetails(),
                    ],
                  ),
                ),
                // if (!SizeConfig.isMobile(context))
                //   const SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we dont want to show it
                // if (!SizeConfig.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: Column(children: const [
                //       StarageDetails(),
                //       SizedBox(height: defaultPadding),
                //       StarageDetails()
                //     ]),
                //   ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (size.width >= 1100) {
      debugPrint("ResponsiveWidget desktop");
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (size.width >= 850 && tablet != null) {
      debugPrint("ResponsiveWidget tablet");
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      debugPrint("ResponsiveWidget mobile");
      return mobile;
    }
  }
}
