import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/carousel.dart';
import 'package:flutter_view_controller/screens/web/components/cv_section.dart';
import 'package:flutter_view_controller/screens/web/components/education_section.dart';
import 'package:flutter_view_controller/screens/web/components/ios_app_ad.dart';
import 'package:flutter_view_controller/screens/web/components/portfolio_stats.dart';
import 'package:flutter_view_controller/screens/web/components/skill_section.dart';
import 'package:flutter_view_controller/screens/web/components/sponsors.dart';
import 'package:flutter_view_controller/screens/web/components/testimonial_widget.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image.dart';
import 'package:flutter_view_controller/screens/web/components/website_ad.dart';

class HomeWebPage extends BaseWebPage {
  const HomeWebPage({Key? key}) : super(key: key);

  @override
  Widget getContentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel(),
          const SizedBox(
            height: 20.0,
          ),
          TitleAndDescriptopnAndImage(
            primaryTitle: "Hello, There",
            title: "SAFFOURY CO.\nfor tissue\nmanufacturing".toUpperCase(),
            customWidget: CompanyLogo(),
            description:
                "SaffouryPaper is a professional manufacture of different kinds of paper with more than 30 years manufacturing experience, advanced technology has been gradually brought in from Taiwan, Italy With our strong R&D team.",
            // backgroundImage:
            //     "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: PortfolioStats(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const ProductQualityWebSection(),
          IosAppAd(),
          const SizedBox(
            height: 70.0,
          ),
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
