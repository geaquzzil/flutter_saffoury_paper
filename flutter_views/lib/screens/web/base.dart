import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/screens/web/about-us.dart';
import 'package:flutter_view_controller/screens/web/components/footer.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/terms.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class BaseWebPage extends StatelessWidget {
  Widget? getContentWidget(BuildContext context);
  const BaseWebPage({Key? key}) : super(key: key);

  String getSelectedHeader(BuildContext context) {
    if (this is AboutUsWebPage) {
      return AppLocalizations.of(context)!.about;
    } else if (this is HomeWebPage) {
      return AppLocalizations.of(context)!.home;
    } else if (this is ProductWebPage) {
      return AppLocalizations.of(context)!.products;
    } else if (this is TermsWebPage) {
      return AppLocalizations.of(context)!.termsAndConitions;
    } else {
      return "";
    }
  }

  Widget getHeader(BuildContext context) {
    if (kIsWeb) {
      return Header(
        selectedHeader: getSelectedHeader(context),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
        child: BackButton(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var headerItems = getHeaderItems(context);
    return Scaffold(
      // key: Globals.scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return headerItems[index].isButton
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kDangerColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: TextButton(
                            onPressed: () => headerItems[index].onClick?.call(),
                            child: Text(
                              headerItems[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          headerItems[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemCount: headerItems.length,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader(context),
            getContentWidget(context)!,
            const Footer(),
          ],
        ),
      ),
    );
  }
}
