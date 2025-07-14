import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/cv_section.dart';
import 'package:flutter_view_controller/screens/web/components/education_section.dart';
import 'package:flutter_view_controller/screens/web/components/portfolio_stats.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image_left.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'components/grid_view_api_category.dart';
import 'parallex/parallexes.dart';

const kHeroImage =
    'http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg';

class HomeWebPage extends BaseWebPageSlivers {
  double offset = 0;
  late ViewAbstract products;
  late ViewAbstract categories;
  HomeWebPage({super.key});

  get kPrimaryColor => null;
  bool updateOffsetAccordingToScroll(ScrollNotification scrollNotification) {
    // setState(() => offset = scrollNotification.metrics.pixels);
    return true;
  }

  @override
  Widget? getCustomAppBar(BuildContext context, BoxConstraints? constraints) {
    return null;
  }
  @override
  void init(BuildContext context) {
    products = context.read<AuthProvider<AuthUser>>().getWebCategories()[0];
    categories = context.read<AuthProvider<AuthUser>>().getWebCategories()[1];
    super.init(context);
  }


  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      getHomeHeader(context),
      getSliverSizedBox(),
      getHomeWelcomMessage(),
      getProfiloStates(),
      getProfiloProductProfits(),
      getSliverSizedBox(),
      getTitle(
        context,
        constraints,
        "LATEST PRODUCTS",
      ),
      getLastProducts(context),

      getProductDescrtionsSections(context),
      getSliverSizedBox(),
      getTitle(context, constraints, "CATEGORY"),
      getCategory(),

      getGooglePlay(context),
      // getSliverSizedBox(),
      getSliverSizedBox(),
      getHistorySection(),

      getContactUs(context),
      getSliverSizedBox()

      // SliverToBoxAdapter(
      //   child: TestimonialWidget(),
      // ),
      // SliverToBoxAdapter(
      //   child: Sponsors(),
      // ),

      // SliverToBoxAdapter(
      //   child: SkillSection(),
      // ),
      // SliverToBoxAdapter(
      //   child: WebsiteAd(),
      // )
    ];
  }

  SliverToBoxAdapter getContactUs(BuildContext context) {
    return SliverToBoxAdapter(
      child: LocationListItem(
        usePadding: false,
        useResponsiveLayout: false,
        useClipRect: false,
        country: "",
        name: "",
        soildColor: context.getDarkingColorForFroeground,
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
                  child: const LottieColorFilter(
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
    );
  }

  SliverToBoxAdapter getProductDescrtionsSections(BuildContext context) {
    return SliverToBoxAdapter(
      child: LocationListItem(
        useClipRect: false,
        soildColor: context.getDarkingColorForFroeground,
        usePadding: false,
        useResponsiveLayout: false,
        country: "",
        name: "",
        customCenterWidget: Container(),
        imageUrl:
            "https://saffoury.com/wp-content/uploads/2022/05/center_15.jpg",
      ),
    );
  }

  Widget getGooglePlay(BuildContext context) {
    return SliverToBoxAdapter(
      child: LocationListItem(
        usePadding: false,
        useResponsiveLayout: false,
        useClipRect: false,
        country: "",
        name: "",
        soildColor: context.getDarkingColorForFroeground,
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
                  child: const LottieColorFilter(
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
    );
  }

  SliverToBoxAdapter getHistorySection() =>
      const SliverToBoxAdapter(child: HistorySection());
  Widget getCategory() {
    return SliverToBoxAdapter(
      child: GridViewApi(viewAbstract: categories),
    );
  }

  Widget getLastProducts(BuildContext context) {
    return SliverToBoxAdapter(
      child: GridViewApi(viewAbstract: products),
    );
  }

  Widget getProfiloStates() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 28.0),
      sliver: SliverToBoxAdapter(
        child: PortfolioStats(),
      ),
    );
  }

  Widget getProfiloProductProfits() {
    return const SliverToBoxAdapter(child: ProductQualityWebSection());
  }

  SliverToBoxAdapter getHomeWelcomMessage() {
    return SliverToBoxAdapter(
      child: TitleAndDescriptopnAndImage(
        title: "SAFFOURY CO.\nfor tissue\nmanufacturing".toUpperCase(),
        customIconData: Icons.adobe_outlined,
        customWidget: CompanyLogo(size: 100),
        description:
            "SaffouryPaper is a professional manufacture of different kinds of paper with more than 30 years manufacturing experience, advanced technology has been gradually brought in from Taiwan, Italy With our strong R&D team.",
        // backgroundImage:
        //     "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
      ),
    );
  }

  Widget getHomeHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: LocationListItem(
        usePadding: false,
        useResponsiveLayout: false,
        useClipRect: false,
        soildColor: context.isDarkMode
            ? Colors.black38
            : context.getDarkingColorForFroeground,
        customCenterWidget: TitleAndDescriptopnAndImage(
          // primaryTitle: "Hello, There",
          title: "Find the perfect saffoury products\nfor your business"
              .toUpperCase(),
          customWidget: const SizedBox(),
          // customIconData: Icons.adobe_outlined,
          customDescription: Card(
            child: SearchWidgetComponentEditable(
              trailingIsCart: false,
              notiferSearchVoid: (value) => context
                  .goNamed(indexWebOurProducts, queryParameters: {"search": value}),
            ),
          ),
          // backgroundImage:
          //     "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
        ),
        // useResponsiveLayout: true,
        country: "Saffoury",
        name: "SaffouryPaper",
        imageUrl:
            "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
      ),
    );
  }
}
