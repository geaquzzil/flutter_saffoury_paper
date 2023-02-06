import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/screens/web/components/portfolio_stats.dart';
import 'package:latlong2/latlong.dart';
import 'components/header_text.dart';
import 'components/title_and_image.dart';

class AboutUsWebPage extends BaseWebPage {
  const AboutUsWebPage({Key? key}) : super(key: key);

  @override
  Widget? getContentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndDescriptopnAndImage(
            primaryTitle: AppLocalizations.of(context)!.about,
            title: "SAFFOURY CO.",
            description:
                "Saffoury Co. stablished in 1990, as a producer of Jumbo Tissue paper rolls. The mill covers a total area of 60,000sqm.All high quality tissue grades are produced from the highest virgin pulp grade sourced from all over the world. Since its inception located in Hosh Sahia, Damascus, Syria\nSaffoury is a professional manufacture of different kinds of paper with more than 30 years manufacturing experience, advanced technology has been gradually brought in from Taiwan, Italy With our strong R&D team, OEM service and design service are available.Our products has passed the CE&ISO Approved. With the high quality products. We have cooperated with more than 20 countries around the world and enjoy good reputation both home and abroad. For us, Customer First, High Quality is Our Obligation, Great Service is Our Mission!",
            customIconData: Icons.abc_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0),
            child: PortfolioStats(),
          ),
          TitleAndDescriptopnAndImage(
            // primaryTitle: AppLocalizations.of(context)!.about,
            title: "Address".toUpperCase(),
            description:
                "C947+C89, Unnamed Road, Kherbet Al-Ward, Damascus, Syria\nPHONE:",
            customWidget: SizedBox(
                height: 500,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(33.4060428, 36.3611587),
                    zoom: 10,
                  ),
                  // nonRotatedChildren: [
                  //   AttributionWidget.defaultWidget(
                  //     source: 'OpenStreetMap contributors',
                  //     onSourceTapped: null,
                  //   ),
                  // ],
                  children: [
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(33.4060428, 36.3611587),
                          width: 80,
                          height: 80,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 48.0,
                          ),
                        ),
                      ],
                    ),
                    // TileLayer(
                    //   urlTemplate:
                    //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    //   userAgentPackageName: 'com.example.app',
                    // ),
                  ],
                )),

            // layers: [
            //   TileLayerOptions(
            //       urlTemplate: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png"),
            //   MarkerLayerOptions(markers: [
            //     Marker(
            //         point: LatLng(40.441753, -80.011476),
            //         builder: (ctx) => const Icon(
            //               Icons.location_on,
            //               color: Colors.blue,
            //               size: 48.0,
            //             ),
            //         height: 60),
            //   ]),
            // ],
          )
          // HeaderText(
          //   text: "TERMS AND\nCONDITIONS",
          //   description: getHtmlWidget(),
          // ),
          // const SizedBox(
          //   height: 50.0,
          // ),
          // const TitleAndDescriptopnAndImage(
          //   title: "PRIVACY",
          //   description:
          //       "This privacy policy provides the method for collecting your data in the manner used by “Al-Saffoury Application” and we recommend that you read the privacy policy carefully. “You” consent to the collection and use of your data by the “Online Application” and some third party service providers in the manner set forth in this Privacy Policy.",
          //   iconData: Icons.privacy_tip,
          // ),
          // HeaderText(
          //   fontSize: 20,
          //   text: "Protect your privacy".toUpperCase(),
          //   description: Html(
          //       data:
          //           "You feel comfortable and secure when using our website/application and sharing your information with us, thus we are very proud of our commitment to protecting your privacy. Please continue to read the following policy to understand how your personal information is handled"),
          // ),
          // HeaderText(
          //   fontSize: 20,
          //   text: "Privacy Guarantee".toUpperCase(),
          //   description: Html(
          //       data:
          //           "Al-Saffoury promises not to sell, rent or share your personal information to any third party (except as provided in this Privacy Policy) without your consent."),
          // ),
          // const SizedBox(
          //   height: 50.0,
          // ),
          // TitleAndDescriptopnAndImage(
          //   title: "Information\nthat may be collected from you".toUpperCase(),
          //   description:
          //       "The “electronic application” collects the information provided through you when registering in the “electronic application” and submitting requests in a record with the information we have known about you through your use of our site, including the collection of information about the operations you perform on the “electronic application”. We may also collect additional information in connection with your participation in any of our offers. We also monitor customer traffic patterns and application usage, which enables us to improve our service.",
          //   iconData: Icons.question_answer,
          // ),
          // HeaderText(
          //   fontSize: 20,
          //   text: "".toUpperCase(),
          //   description: Html(
          //       data:
          //           "If you do not agree to this privacy policy, please do not accept the privacy policy during registration, as your personal identity remains anonymous while browsing the site without logging in to the “application” using a username and password. However, “Al-Saffoury’s website” collects and saves the following information, even if you are not logged into the “Site”:<br><br><ul><li>Name</li><li>Email</li><li>Mobile Number</li><li>Device Type</li><li>IP Address</li><li>Country from wich the application is used</li><li>Operating System</li></ul><br>You may terminate your account at any time, however your information may remain archived on the servers of the Website even after the deletion or termination of your account."),
          // ),
          // HeaderText(
          //   fontSize: 20,
          //   text: "Disclosures of your information".toUpperCase(),
          //   description: Html(
          //       data:
          //           "We will not use your personal information for any purpose other than to complete a transaction with you. We do not rent, sell or share your personal information, and we will not disclose any personal information to any third party except in the following circumstances:<br><br><ul><li>Have your permission</li><li>To provide the products and services you requested</li><li>To assist in the investigation or prevention of conduct related to illegal and illegal activities, suspected fraud, or posing a threat to the safety or security of any person or in cases of violation of the User Agreement or to defend against legal claims. Special circumstances such as compliance with subpoenas, court orders, request/order from a statutory authority.</li></ul>"),
          // ),
          // HeaderText(
          //   fontSize: 20,
          //   text: "Our Responsibility".toUpperCase(),
          //   description: Html(
          //       data:
          //           "Although we will work to maintain the confidentiality of your personal information, transmissions via the Internet cannot be completely secure. By using this Website, you agree that we have no responsibility for disclosing your information due to any party's transmission errors or unauthorized acts of third parties.We reserve the right to change or update our policy at any time, and we will notify you of changes if this occurs. Such changes are effective immediately upon being placed on the Site.<br><br><strong>Copyright</strong><br>The content, organization, graphics, design, compilation, electronic translation, digitization, and other matters relating to the “Site” are the property of “Saffoury” and are all protected by copyright and trade name laws, and other rights including It has intellectual property rights. It is absolutely prohibited to copy, redistribute, use or print any of these materials or any part of them from the “Site” or from any other sites, except to the extent permitted by the laws in force in the Syrian Arab Republic in this regard.<br><br><strong>Brand</strong><br>All words and logos on the “Website or Application” are the property of “Al-Saffoury” whether they are registered trademarks, designs, phrases, logos and/or unregistered words and are protected by intellectual property laws. All other trademarks not owned by “Al-Saffoury” that appear on the Site are the property of their respective owners, who may or may not be affiliated with or associated with “Al-Saffoury”.<br><br>Questions? We are always happy to help with questions you may have! Check our FAQ or contact us sections for any questions."),
          // ),
        ],
      ),
    );
  }
}
