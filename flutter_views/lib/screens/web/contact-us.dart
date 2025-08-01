// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/packages/material_dialogs/material_dialogs.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/screens/web/components/contact_info_item.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:latlong2/latlong.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'components/title_and_image.dart';

var contactInfo = [
  const ContactItem(
      category: "INNOVATION",
      name: "Qussai Al-Saffoury",
      email: "qussai@saffoury.com",
      hasWhatsapp: true,
      phone: "+963 989-944-380"),
  const ContactItem(
      category: "GENERAL MANAGER",
      name: "Yazan Al-Saffoury",
      hasWhatsapp: true,
      email: "yazan@saffoury.com",
      phone: "+963 989-944-377"),
  const ContactItem(
      category: "TECHNICAL CUSTOMER\nSERVICE",
      name: "Noor Al-Dinn Qusini",
      hasWhatsapp: true,
      phone: "+963 989-944-384"),
  ContactItem(
      category: "OFFICE".toUpperCase(),
      name: "Tokka Al",
      email: "paper@saffoury.com",
      hasWhatsapp: true,
      phone: "+963 989-944-381")
];

class ContactUsWebPage extends BaseWebPageSlivers {
  ContactUsWebPage({super.key});

  @override
  Widget? getCustomAppBar(BuildContext context, BoxConstraints? constraints) {
    return null;
  }

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      SliverToBoxAdapter(
          child: TitleAndDescriptopnAndImage(
        primaryTitle: AppLocalizations.of(context)!.contactUs,
        title: AppLocalizations.of(context)!.submitARequest.toUpperCase(),
        description: AppLocalizations.of(context)!.submitRequestDes,
        customIconData: Icons.contact_support_rounded,
      )),

      SliverToBoxAdapter(child: getHeadQuarters(context)),
      SliverToBoxAdapter(child: getSubheadQuarters(context)),
      // Divider(),
      SliverToBoxAdapter(child: getAgencies(context))
    ];
  }

  TitleAndDescriptopnAndImage getAgencies(BuildContext context) {
    return TitleAndDescriptopnAndImage(
      primaryTitle: AppLocalizations.of(context)!.contactInfo,
      title: "AGENCIES".toUpperCase(),
      customDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Html(
            data:
                r"<strong>UNITED FOR BUSINESS.</strong> QVMH+VGV Chabraqiyet Tabet, Taanayel, Lebanon",
          ),
          const ContactInfoItemWidget(
              contactInfo: ContactItem(
                  category: "OFFICE",
                  name: "Muhammed Al-Khammes Al-Saffoury",
                  phone: "+961 712-02602"))
        ],
      ),
      // description:
      //     "Saffoury Co. C947+C89, Unnamed Road, Kherbet Al-Ward, Damascus, Syria\nGeneral Manager:Muhammed Al-Khammes +963-933-211-012",
      customWidget: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: map.FlutterMap(
              options: const map.MapOptions(
                initialCenter: LatLng(33.783583, 35.877710),
                // enableScrollWheel: false,
                initialZoom: 15,
              ),
              // nonRotatedChildren: [
              //   AttributionWidget.defaultWidget(
              //     source: 'OpenStreetMap contributors',
              //     onSourceTapped: null,
              //   ),
              // ],
              children: [
                map.MarkerLayer(
                  markers: [
                    map.Marker(
                      child: Lottie.network(
                          "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                          width: 40,
                          height: 40),
                      point: const LatLng(33.783583, 35.877710),
                      width: 80,
                      height: 80,
                      // builder: (context) => Lottie.network(
                      //     "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                      //     width: 40,
                      //     height: 40),
                    ),
                  ],
                ),
                map.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
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
    );
  }

  TitleAndDescriptopnAndImage getSubheadQuarters(BuildContext context) {
    return TitleAndDescriptopnAndImage(
      primaryTitle: AppLocalizations.of(context)!.contactInfo,
      title: "subsidiary headquarters".toUpperCase(),
      customDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Html(
            data:
                r"<strong>SaffouryPaper.</strong> F8PC+7GG, Ibn Battuta St, Damascus, Syria",
          ),
          getSocialButtons([
            IconButton(
                onPressed: () {
                  launchUrlString("https://facebook.com/SaffouryPaper");
                },
                icon: const Icon(Icons.facebook)),
            IconButton(
                onPressed: () {
                  launchUrlString("ttps://goo.gl/maps/iVLB4dSWpzeyASbp8");
                },
                icon: const Icon(Icons.location_on)),
            IconButton(
                onPressed: () {
                  launchMailtoSaffouryPaperCustom(
                      "paper@saffoury.com", "SaffouryPaper");
                  // launchMailto();
                },
                icon: const Icon(Icons.email)),
          ]),
          ...contactInfo.map((c) => ContactInfoItemWidget(contactInfo: c)),
        ],
      ),
      // description:
      //     "Saffoury Co. C947+C89, Unnamed Road, Kherbet Al-Ward, Damascus, Syria\nGeneral Manager:Muhammed Al-Khammes +963-933-211-012",
      customWidget: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: map.FlutterMap(
              options: const map.MapOptions(
                initialCenter: LatLng(33.485683, 36.3191252),

                // enableScrollWheel: false,
                initialZoom: 12,
              ),
              // nonRotatedChildren: [
              //   AttributionWidget.defaultWidget(
              //     source: 'OpenStreetMap contributors',
              //     onSourceTapped: null,
              //   ),
              // ],
              children: [
                map.MarkerLayer(
                  markers: [
                    map.Marker(
                      child: Lottie.network(
                          "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                          width: 40,
                          height: 40),
                      point: const LatLng(33.485683, 36.3191252),
                      width: 80,
                      height: 80,
                      // builder: (context) => Lottie.network(
                      //     "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                      //     width: 40,
                      //     height: 40),
                    ),
                  ],
                ),
                map.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
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
    );
  }

  TitleAndDescriptopnAndImage getHeadQuarters(BuildContext context) {
    return TitleAndDescriptopnAndImage(
      primaryTitle: AppLocalizations.of(context)!.contactInfo,
      title: "HEADQUARTERS".toUpperCase(),
      customDescription: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Html(
            data:
                r"<strong>Saffoury Co.</strong> C947+C89, Kherbet Al-Ward, Damascus, Syria<br>C.R: 1405 - I.R: 3<br><br><strong>Mobile: </strong>+963 933-211-012</strong><br><strong>Tel: </strong>+963 11 545-5704<strong><br>Tel: </strong>+963 11 545-5705<br><br><strong>E-Mail: </bold>info@saffoury.com",
          ),
          getSocialButtons([
            IconButton(
                onPressed: () {
                  launch("https://wa.me/+963933211012/?text=Hello There,");
                },
                icon: const Icon(
                  FlutterIcons.whatsapp_faw,
                )),
            IconButton(
                onPressed: () {
                  launchUrlString("https://facebook.com/dima9359");
                },
                icon: const Icon(Icons.facebook)),
            IconButton(
                onPressed: () {
                  launchUrlString("https://goo.gl/maps/GTBfhWsNdrghA4Bk9");
                },
                icon: const Icon(Icons.location_on)),
            IconButton(
                onPressed: () {
                  launchMailto();
                },
                icon: const Icon(Icons.email)),
          ]),
        ],
      ),
      // description:
      //     "Saffoury Co. C947+C89, Unnamed Road, Kherbet Al-Ward, Damascus, Syria\nGeneral Manager:Muhammed Al-Khammes +963-933-211-012",
      customWidget: SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: map.FlutterMap(
              options: const map.MapOptions(
                initialCenter: LatLng(33.4060428, 36.3611587),
                // enableScrollWheel: false,
                initialZoom: 15,
              ),
              // nonRotatedChildren: [
              //   AttributionWidget.defaultWidget(
              //     source: 'OpenStreetMap contributors',
              //     onSourceTapped: null,
              //   ),
              // ],
              children: [
                map.MarkerLayer(
                  markers: [
                    map.Marker(
                      child: Lottie.network(
                          "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                          width: 40,
                          height: 40),
                      point: const LatLng(33.4060428, 36.3611587),
                      width: 80,
                      height: 80,
                      // builder: (context) => Lottie.network(
                      //     "https://assets2.lottiefiles.com/packages/lf20_hfc3kiim.json",
                      //     width: 40,
                      //     height: 40),
                    ),
                  ],
                ),
                map.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
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

class ContactItem {
  final String category;
  final String name;
  final String? email;
  final String phone;
  final bool? hasWhatsapp;

  const ContactItem(
      {required this.category,
      required this.name,
      this.email,
      this.hasWhatsapp,
      required this.phone});

  Widget getLeading() {
    return getWebText(title: category, fontSize: 18, color: kPrimaryColor);
  }

  Widget getContactWidget(BuildContext context) {
    return ListTile(
      leading: getLeading(),
      title: getTitle(),
      trailing: getTrailing(),
    );
  }

  Wrap getTrailing() {
    return Wrap(
      children: [
        if (email != null)
          IconButton(
              onPressed: () {
                launchMailtoSaffouryPaperCustom(email!, name);
              },
              icon: const Icon(Icons.email)),
        IconButton(
            onPressed: () {
              launchUrlString("tel://$phone");
            },
            icon: const Icon(Icons.phone)),
        if (hasWhatsapp ?? false)
          IconButton(
              onPressed: () {
                launchUrlString(
                    "https://wa.me/${phone.replaceAll(" ", "").replaceAll("-", "")}/?text=Hello There,");
              },
              icon: const Icon(
                FlutterIcons.whatsapp_faw,
              )),
      ],
    );
  }

  Widget getTitleColumn() {
    return Column(
      children: [getTitle()],
    );
  }

  Html getTitle() {
    String person = "<strong>Contact person: </strong>$name";
    String? emailContent =
        email == null ? null : "<strong>E-Mail: </strong>$email";

    String phoneContent = "<strong>Phone: </strong>$phone";
    List<String> content = [
      person,
      if (emailContent != null) emailContent,
      phoneContent
    ];

    String all = content.join("<br>");
    return Html(data: "<small>$all</small>");
  }
}
