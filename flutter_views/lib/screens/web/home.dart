import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
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
import 'package:flutter_view_controller/screens/web/components/title_and_image_left.dart';
import 'package:flutter_view_controller/screens/web/components/website_ad.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'components/grid_view_api_category.dart';
import 'parallex/parallexes.dart';

const kHeroImage =
    'http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg';

class NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class HomeWebPageStatefull extends StatefulWidget {
  const HomeWebPageStatefull({super.key});

  @override
  State<HomeWebPageStatefull> createState() => _HomeWebPageStatefullState();
}

class _HomeWebPageStatefullState
    extends BaseWebPageState<HomeWebPageStatefull> {
  double offset = 0;
  bool updateOffsetAccordingToScroll(ScrollNotification scrollNotification) {
    setState(() => offset = scrollNotification.metrics.pixels);
    debugPrint("updateOffsetAccordingToScroll $offset");
    return true;
  }

  @override
  Widget? getContentWidget(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final nameStyle = Theme.of(context).textTheme.headline2;
    final descriptionStyle = Theme.of(context).textTheme.headline4;
    return NotificationListener<ScrollNotification>(
      // When user scrolls, this will trigger onNotification.
      // updateOffsetAccordingToScroll updates the offset
      onNotification: updateOffsetAccordingToScroll,
      // ScrollConfiguration sets the scroll glow behaviour
      child: ScrollConfiguration(
        behavior: NoScrollGlow(),
        child: Stack(
          children: <Widget>[
            Positioned(
              // The hero image will be pushed up once user scrolls up
              // That is why it is multiplied negatively.
              top: -.25 * offset,
              child: const Icon(Icons.query_builder),

              // FadeInImage.memoryNetwork(
              //   // From the transparent_image package
              //   placeholder: kTransparentImage,
              //   image: kHeroImage,
              //   height: height,
              //   width: width,
              //   fit: BoxFit.fitWidth,
              // ),
            ),
            Positioned(
              top: -.25 * offset,
              child: SizedBox(
                height: height,
                width: width,
                child: Align(
                    alignment: const Alignment(0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Happy Haris',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Proving learning coding, is easy',
                        ),
                      ],
                    )),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height),
                  Container(
                    height: height,
                    width: width,
                    color: Colors.blueAccent,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomeWebPage extends BaseWebPage {
  double offset = 0;
  HomeWebPage({Key? key}) : super(key: key);

  get kPrimaryColor => null;
  bool updateOffsetAccordingToScroll(ScrollNotification scrollNotification) {
    // setState(() => offset = scrollNotification.metrics.pixels);
    return true;
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carousel(),

        LocationListItem(
          useResponsiveLayout: true,
          country: "Saffoury",
          name: "SaffouryPaper",
          imageUrl:
              "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
        ),

        const SizedBox(
          height: 20.0,
        ),
        TitleAndDescriptopnAndImage(
          primaryTitle: "Hello, There",
          title: "SAFFOURY CO.\nfor tissue\nmanufacturing".toUpperCase(),
          customIconData: Icons.adobe_outlined,
          description:
              "SaffouryPaper is a professional manufacture of different kinds of paper with more than 30 years manufacturing experience, advanced technology has been gradually brought in from Taiwan, Italy With our strong R&D team.",
          // backgroundImage:
          //     "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: PortfolioStats(),
        ),

        const ProductQualityWebSection(),
        GridViewApi(
            title: "LATEST PRODUCTS".toUpperCase(),
            description: "browser category by paper and board",
            viewAbstract: context.read<AuthProvider>().getWebCategories()[0]),
        LocationListItem(
          soildColor: Theme.of(context)
              .scaffoldBackgroundColor
              .lighten()
              .withOpacity(.8),
          usePadding: false,
          useResponsiveLayout: false,
          country: "",
          name: "",
          customCenterWidget: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: const ProductQualityWebSection()),
          imageUrl:
              "https://saffoury.com/wp-content/uploads/2022/05/center_15.jpg",
        ),
        const SizedBox(
          height: 70.0,
        ),

        HistorySection(),
        // TitleAndDescriptopnAndImageLeft(
        //   actions: [
        //     MouseRegion(
        //       cursor: SystemMouseCursors.click,
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: kPrimaryColor,
        //           borderRadius: BorderRadius.circular(8.0),
        //         ),
        //         height: 48.0,
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 28.0,
        //         ),
        //         child: TextButton(
        //           onPressed: () {},
        //           child: Center(
        //               child: Lottie.network(
        //                   "https://assets5.lottiefiles.com/packages/lf20_cbdikfm6.json")),
        //         ),
        //       ),
        //     ),
        //   ],
        //   title: "OUR\nMISSION",
        //   description:
        //       "From the beginning,our mission has been to orginize the world's ",
        //   customIconData: Icons.play_arrow,
        // ),

        const SizedBox(
          height: 70.0,
        ),
        // const ProductQualityWebSection(),
        // TitleAndDescriptopnAndImageLeft(
        //   primaryTitle: "IOS APP",
        //   title: "UNIVERSAL\nSMART HOME APP",
        //   description:
        //       "This is a random text about the project, I should have used the regular lorem ipsum text, but I am too lazy to search for that. This should be long enough",
        //   customIconData: Icons.play_arrow,
        // ),
        LocationListItem(
          usePadding: false,
          useResponsiveLayout: false,
          useClipRect: false,
          country: "",
          name: "",
          soildColor: Theme.of(context)
              .scaffoldBackgroundColor
              .lighten()
              .withOpacity(.8),
          customCenterWidget: TitleAndDescriptopnAndImageLeft(
            title: "WE\nLAUNCHED\nOUR APP".toUpperCase(),
            descriptionIsWhite: true,
            description:
                "Ordering solution perfect for presses owners.\nStart ordering online, along with website, apps, products,\nmenus & much,much more\nDevelopment by Qussai Al-Saffoury",
            customWidget: Container(),
            actions: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 48.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      launchUrlString(
                          "https://play.google.com/store/apps/details?id=com.saffoury.saffourypaper&hl=en&gl=US");
                    },
                    child: LottieColorFilter(
                      // color: Colors.black.withOpacity(.4),
                      lottiUrl:
                          "https://assets7.lottiefiles.com/packages/lf20_bsPjV4.json",
                    ),
                  ),
                ),
              ),
            ],
          ),
          imageUrl:
              "https://saffoury.com/wp-content/uploads/lo1-Recovered-1-scaled.jpg",
        ),

        const SizedBox(
          height: 70.0,
        ),
        GridViewApi(
            title: "Category".toUpperCase(),
            description: "browser category by paper and board",
            viewAbstract: context.read<AuthProvider>().getWebCategories()[1]),
        const SizedBox(
          height: 70.0,
        ),
        LocationListItem(
          usePadding: false,
          useResponsiveLayout: false,
          useClipRect: false,
          country: "",
          name: "",
          soildColor: Theme.of(context)
              .scaffoldBackgroundColor
              .lighten()
              .withOpacity(.7),
          customCenterWidget: TitleAndDescriptopnAndImageLeft(
            title: "Contact us".toUpperCase(),
            descriptionIsWhite: true,
            description:
                "Have questions before making a purchase?\nWe are very keen on trust and credibility in dealing with our customers, where we must adhere to all the requirements of our customers and provide them with services as fully as possible",
            customWidget: Lottie.network(
                "https://assets2.lottiefiles.com/packages/lf20_abqysclq.json",
                height: 300),
            actions: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 48.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.goNamed(indexWebContactUs);
                    },
                    child: LottieColorFilter(
                      // color: Colors.black.withOpacity(.4),
                      lottiUrl:
                          "https://assets10.lottiefiles.com/packages/lf20_RBUCBDMwqd.json",
                    ),
                  ),
                ),
              ),
            ],
          ),
          imageUrl:
              "https://www.europharmconsulting.com/wp-content/uploads/2019/05/536-2000x1000.jpg",
        ),
        const SizedBox(
          height: 70.0,
        ),
        // TitleAndDescriptopnAndImageLeft(
        //   title: "Contact us".toUpperCase(),
        //   description: "Have questions before making a purchase?",
        //   customWidget: Lottie.network(
        //       "https://assets5.lottiefiles.com/packages/lf20_u25cckyh.json"),
        //   actions: [
        //     MouseRegion(
        //       cursor: SystemMouseCursors.click,
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: kPrimaryColor,
        //           borderRadius: BorderRadius.circular(8.0),
        //         ),
        //         height: 48.0,
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 28.0,
        //         ),
        //         child: TextButton(
        //           onPressed: () {
        //             context.goNamed(indexWebAboutUs);
        //           },
        //           child: Center(
        //               child: Lottie.network(
        //                   "https://assets5.lottiefiles.com/packages/lf20_cbdikfm6.json")),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 70.0,
        // ),
        // WebsiteAd(),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 28.0),
        //   child: PortfolioStats(),
        // ),
        // const SizedBox(
        //   height: 50.0,
        // ),

        // const SizedBox(
        //   height: 50.0,
        // ),
        // SkillSection(),
        // const SizedBox(
        //   height: 50.0,
        // ),
        // Sponsors(),
        // const SizedBox(
        //   height: 50.0,
        // ),
        // TestimonialWidget()
      ],
    );
  }
}
