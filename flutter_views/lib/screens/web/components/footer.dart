import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/models/footer_item.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
final List<FooterItem> footerItems = [
  FooterItem(
    icon: const Icon(Icons.add_home_work, size: 25),
    title: "ADDRESS",
    text1: "Damascus - Syria",
    text2: "Hosh-Sahia",
  ),
  FooterItem(
    icon: const Icon(Icons.phone, size: 25),
    title: "PHONE",
    text1: "+963 933-326-882",
    text2: "+963 933-211-012",
  ),
  FooterItem(
    icon: const Icon(Icons.email, size: 25),
    title: "EMAIL",
    text1: "papr@saffoury.com",
    text2: "info@saffoury.com",
  ),
  FooterItem(
    icon: const Icon(FlutterIcons.whatsapp_faw, size: 25),
    title: "WHATSAPP",
    text1: "+963 933-211-012",
    text2: "+963 933-211-012",
  )
];

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      largeTablet: _buildUi(kDesktopMaxWidth, context),
      smallTablet: _buildUi(kTabletMaxWidth, context),
      mobile: _buildUi(getMobileMaxWidth(context), context),
    );
  }
}

Widget _buildUi(double width, BuildContext context) {
  Dealers? dealersInfo = context.read<AuthProvider<AuthUser>>().getDealers;
  return Center(
    child: MaxWidthBox(
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Divider(),
              //getContactInfo(context, constraints),

              Flex(
                direction: isMobile(context) ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: isMobile(context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Copyright (c) 2023 SaffouryPaper. All rights Reserved",
                      style: TextStyle(
                        color: kCaptionColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.goNamed(indexReturnPrivecyPolicy);
                        },
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            "Return Policy",
                            style: TextStyle(
                              color: kCaptionColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          "|",
                          style: TextStyle(
                            color: kCaptionColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.goNamed(indexWebTermsAndConditions);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            AppLocalizations.of(context)!
                                .agree_terms_and_condition,
                            style: const TextStyle(
                              color: kCaptionColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          );
        },
      ),
    ),
  );
}

Padding getContactInfo(BuildContext context, BoxConstraints constraints) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Wrap(
      spacing: 20.0,
      runSpacing: 20.0,
      children: footerItems
          .map(
            (footerItem) => SizedBox(
              height: 120.0,
              width: isMobile(context)
                  ? constraints.maxWidth / 2.0 - 20.0
                  : constraints.maxWidth / 4.0 - 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      footerItem.icon,
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        footerItem.title,
                        style: GoogleFonts.roboto(
                          // fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${footerItem.text1}\n",
                          style: const TextStyle(
                            color: kCaptionColor,
                            height: 1.8,
                          ),
                        ),
                        TextSpan(
                          text: "${footerItem.text2}\n",
                          style: const TextStyle(
                            color: kCaptionColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}
