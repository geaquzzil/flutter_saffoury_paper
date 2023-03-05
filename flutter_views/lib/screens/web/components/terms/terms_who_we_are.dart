import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class WelcomMessageTermsWhoWeAre extends StatelessWidget {
  final bool useForReturnPolicy;
  final bool useResponsiveLayout;
  const WelcomMessageTermsWhoWeAre(
      {super.key,
      this.useForReturnPolicy = false,
      this.useResponsiveLayout = true});

  // We can use same idea as ios_app_ad.dart and swap children order, let's copy code
  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      desktop: _buildUi(kDesktopMaxWidth),
      tablet: _buildUi(kTabletMaxWidth),
      mobile: _buildUi(getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWrapper(
            maxWidth: width,
            minWidth: width,
            defaultScale: false,
            child: Flex(
              direction:
                  constraints.maxWidth > 720 ? Axis.horizontal : Axis.vertical,
              children: [
                // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        useForReturnPolicy
                            ? "Return Policy"
                            : AppLocalizations.of(context)!.termsAndConitions,
                        style: GoogleFonts.roboto(
                          color: kAccentColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        getTitle,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          fontSize: 35.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        getDescription,
                        style: const TextStyle(
                          color: kCaptionColor,
                          height: 1.5,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Expanded(
                    flex: constraints.maxWidth > 720.0 ? 1 : 0,
                    child: useForReturnPolicy
                        ? Icon(
                            Icons.shopping_bag_rounded,
                            size: constraints.maxWidth > 720.0 ? 100 : 350.0,
                          )
                        : CompanyLogo(
                            size: constraints.maxWidth > 720.0 ? 100 : 350.0,
                          )),
              ],
            ),
          );
        },
      ),
    );
  }

  String get getDescription => useForReturnPolicy
      ? "Welcome to Saffoury Co. The following are the return policy for your use of and access to the pages of the “Al-Saffoury.com” saffoury.com website and all pages, links, tools and features derived from it. By using the Saffoury application, you agree to accept the terms and conditions and return policy of this Agreement, which includes all the details below, and is a confirmation of your commitment to comply with the content of this Agreement of Saffoury “saffoury.com”, hereinafter referred to as “we” and also referred to as “Al-Saffoury.com”. , in connection with your use of the Application, referred to herein as the “Usage Agreement” and this Agreement shall be in effect if you accept the option to consent"
      : "Welcome to Saffoury Co. The following are the privecy policy & terms and conditions for your use of and access to the pages of the “Al-Saffoury.com” saffoury.com website and all pages, links, tools and features derived from it. By using the Saffoury application, you agree to accept the terms and conditions of this Agreement, which includes all the details below, and is a confirmation of your commitment to comply with the content of this Agreement of Saffoury “saffoury.com”, hereinafter referred to as “we” and also referred to as “Al-Saffoury.com”. , in connection with your use of the Application, referred to herein as the “Usage Agreement” and this Agreement shall be in effect if you accept the option to consent";

  String get getTitle => useForReturnPolicy ? "Saffoury Co." : "WHO WE\nARE";
}
