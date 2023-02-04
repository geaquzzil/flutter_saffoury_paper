import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/carousel.dart';
import 'package:flutter_view_controller/screens/web/components/cv_section.dart';
import 'package:flutter_view_controller/screens/web/components/education_section.dart';
import 'package:flutter_view_controller/screens/web/components/ios_app_ad.dart';
import 'package:flutter_view_controller/screens/web/components/portfolio_stats.dart';
import 'package:flutter_view_controller/screens/web/components/skill_section.dart';
import 'package:flutter_view_controller/screens/web/components/sponsors.dart';
import 'package:flutter_view_controller/screens/web/components/testimonial_widget.dart';
import 'package:flutter_view_controller/screens/web/components/website_ad.dart';

class TermsWebPage extends BaseWebPage {
  const TermsWebPage({Key? key}) : super(key: key);

  @override
  Widget? getContentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WebsiteAd(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: PortfolioStats(),
          ),
          const SizedBox(
            height: 50.0,
          ),
          EducationSection(),
          const SizedBox(
            height: 50.0,
          ),
          SkillSection(),
          const SizedBox(
            height: 50.0,
          ),
          Sponsors(),
          const SizedBox(
            height: 50.0,
          ),
          TestimonialWidget()
        ],
      ),
    );
  }
}
