import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/screens/web/components/contact_info_item.dart';
import 'package:flutter_view_controller/screens/web/components/education_section.dart';
import 'package:flutter_view_controller/screens/web/components/portfolio_stats.dart';
import 'package:flutter_view_controller/screens/web/components/title_responsive.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:latlong2/latlong.dart';
import 'package:mailto/mailto.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'components/header_text.dart';
import 'components/title_and_image.dart';
import 'dart:html' as html;

import 'parallex/parallexes.dart';

class AboutUsWebPage extends BaseWebPage {
  AboutUsWebPage({Key? key}) : super(key: key);

  @override
  Widget? getContentWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocationListItem(
          usePadding: false,
          useClipRect: false,
          useResponsiveLayout: false,
          country: "",
          name: "",
          imageUrl:
              "https://saffoury.com/wp-content/uploads/2022/05/center_15.jpg",
        ),
        const SizedBox(
          height: 75,
        ),
        TitleAndDescriptopnAndImage(
          customWidget: Image.network(
              "https://saffoury.com/wp-content/uploads/2022/05/m_w_bdscf0003.jpg"),
          primaryTitle: AppLocalizations.of(context)!.about,
          title: "SAFFOURY CO.",
          description:
              "Saffoury Co. stablished in 1990, as a producer of jumbo tissue paper rolls, All high quality tissue grades are produced from the highest virgin pulp grade sourced from all over the world. Since its inception located in Hosh Sahia, Damascus, Syria\n\nSaffoury is a professional manufacture of different kinds of paper with more than 30 years manufacturing experience, advanced technology has been gradually brought in from Taiwan, Italy with our strong R&D team, OEM service and design service are available.",
          customIconData: Icons.abc_outlined,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: PortfolioStats(),
        ),
        const SizedBox(
          height: 40,
        ),
        TitleAndDescriptopnResponsive(
          addonWidget: Column(
            children: [
              getWebText(title: "OUR HISTORY"),
              const SizedBox(
                height: 40,
              ),
              FixedTimeline.tileBuilder(
                theme: TimelineTheme.of(context).copyWith(
                  connectorTheme:
                      const ConnectorThemeData(color: kPrimaryColor),
                  color: kPrimaryColor,
                ),
                builder: TimelineTileBuilder.connectedFromStyle(
                  contentsAlign: ContentsAlign.alternating,
                  oppositeContentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(historyList[index].period),
                  ),
                  contentsBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(historyList[index].description),
                    ),
                  ),
                  connectorStyleBuilder: (context, index) =>
                      ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                  itemCount: historyList.length,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
          description:
              "Saffoury Co covers an area of 60000 square meters now, employing about 400 people,with the monthly output of 2000 ton,about 2.5million per month.Saffoury Co is dedicated to customer and social service, constantly in producing high grade products, cooperation and innovation to promote the development of the company,has passed the CE&ISO approved.\n\nOur tissue made from bamboo pulp. It is eco friendly,bacteriostatic, non-toxic compared to wood pulp and cleaner than recycle pulp.\n\nBased on health, environmental protection and sustainable development, Saffoury Co develops unbleached BAMBOO PULP PAPER, which enable to reduce the deforestation and protect Ecological environment.\n\nBamboo paper replacement can help reduce deforestation about 660000 cubic meters(450000 trees), and absorb extra 105000 tons carbon dioxide per year, Our company adopt advanced technology which reduces the industrial water and COD, reached GWPB.\n\nSaffoury Co won FDA and FSC, ISO, Certifications.got BSCI audited, We have cooperated with more than 20 countries around the world and enjou good reputation both home and abroad Main products: toilet paper, facial tissue in box and soft pack, toilet paper, napkins, paper towel in roll and multi- fold,kitchen paper towel in roll and multi-fold,mini jumbo roll, toilet seat cover,wet wipes, etc.\n\nSincerely welcome you to have a visit and contribute valuable suggestion to us.",
        ),
      ],
    );
  }

  Padding getSocialButtons(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: widgets,
      ),
    );
  }

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['info@saffoury.com'],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: 'Hello There Saffoury Co.',
      // body: 'mailto example body',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
  }

  launchMailtoSaffouryPaper() async {
    final mailtoLink = Mailto(
      to: ['paper@saffoury.com'],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: 'Hello There SaffouryPaper',
      // body: 'mailto example body',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
  }
}
