import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image.dart';
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
    return TitleAndDescriptopnAndImage(
      customWidget: useForReturnPolicy
          ? const Icon(
              Icons.shopping_bag_rounded,
              size: 100,
            )
          : CompanyLogo(
              size: 200,
            ),
      primaryTitle: useForReturnPolicy
          ? "Return Policy".toUpperCase()
          : AppLocalizations.of(context)!.termsAndConitions.toUpperCase(),
      title: getTitle,
      description: getDescription,
    );
  }
 //TODO Translate
  String get getDescription => useForReturnPolicy
      ? "Welcome to Saffoury Co. The following are the return policy for your use of and access to the pages of the “Al-Saffoury.com” saffoury.com website and all pages, links, tools and features derived from it. By using the Saffoury application, you agree to accept the terms and conditions and return policy of this Agreement, which includes all the details below, and is a confirmation of your commitment to comply with the content of this Agreement of Saffoury “saffoury.com”, hereinafter referred to as “we” and also referred to as “Al-Saffoury.com”. , in connection with your use of the Application, referred to herein as the “Usage Agreement” and this Agreement shall be in effect if you accept the option to consent"
      : "Welcome to Saffoury Co. The following are the privecy policy & terms and conditions for your use of and access to the pages of the “Al-Saffoury.com” saffoury.com website and all pages, links, tools and features derived from it. By using the Saffoury application, you agree to accept the terms and conditions of this Agreement, which includes all the details below, and is a confirmation of your commitment to comply with the content of this Agreement of Saffoury “saffoury.com”, hereinafter referred to as “we” and also referred to as “Al-Saffoury.com”. , in connection with your use of the Application, referred to herein as the “Usage Agreement” and this Agreement shall be in effect if you accept the option to consent";

  String get getTitle => useForReturnPolicy ? "Saffoury Co." : "WHO WE\nARE";
}
