import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image.dart';

import 'components/terms/terms_who_we_are.dart';

class TermsWebPage extends BaseWebPageSlivers {
  TermsWebPage({super.key});

  @override
  Widget? getCustomAppBar(BuildContext context, BoxConstraints? constraints) {
    return null;
  }

  @override
  List<Widget> getContentWidget(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return [
      const SliverToBoxAdapter(child: WelcomMessageTermsWhoWeAre()),
      getTermsAndConditionSection(),
      getSliverSizedBox(height: 50),
      getPrivacySection(),
      SliverToBoxAdapter(
        child: HeaderText(
          fontSize: 20,
          text: "Protect your privacy".toUpperCase(),
          description: Html(
            data:
                "You feel comfortable and secure when using our website/application and sharing your information with us, thus we are very proud of our commitment to protecting your privacy. Please continue to read the following policy to understand how your personal information is handled",
          ),
        ),
      ),
      getSliverSizedBox(),
      SliverToBoxAdapter(
        child: HeaderText(
          fontSize: 20,
          text: "Privacy Guarantee".toUpperCase(),
          description: Html(
            data:
                "Al-Saffoury promises not to sell, rent or share your personal information to any third party (except as provided in this Privacy Policy) without your consent.",
          ),
        ),
      ),
      getSliverSizedBox(height: 50),
      SliverToBoxAdapter(
        child: TitleAndDescriptopnAndImage(
          title: "Information\nthat may be collected from you".toUpperCase(),
          description:
              "The “electronic application” collects the information provided through you when registering in the “electronic application” and submitting requests in a record with the information we have known about you through your use of our site, including the collection of information about the operations you perform on the “electronic application”. We may also collect additional information in connection with your participation in any of our offers. We also monitor customer traffic patterns and application usage, which enables us to improve our service.",
          customIconData: Icons.question_answer,
        ),
      ),
      SliverToBoxAdapter(
        child: HeaderText(
          fontSize: 20,
          text: "".toUpperCase(),
          description: Html(
            data:
                "If you do not agree to this privacy policy, please do not accept the privacy policy during registration, as your personal identity remains anonymous while browsing the site without logging in to the “application” using a username and password. However, “Al-Saffoury’s website” collects and saves the following information, even if you are not logged into the “Site”:<br><br><ul><li>Name</li><li>Email</li><li>Mobile Number</li><li>Device Type</li><li>IP Address</li><li>Country from wich the application is used</li><li>Operating System</li></ul><br>You may terminate your account at any time, however your information may remain archived on the servers of the Website even after the deletion or termination of your account.",
          ),
        ),
      ),
      getSliverSizedBox(),
      SliverToBoxAdapter(
        child: HeaderText(
          fontSize: 20,
          text: "Disclosures of your information".toUpperCase(),
          description: Html(
            data:
                "We will not use your personal information for any purpose other than to complete a transaction with you. We do not rent, sell or share your personal information, and we will not disclose any personal information to any third party except in the following circumstances:<br><br><ul><li>Have your permission</li><li>To provide the products and services you requested</li><li>To assist in the investigation or prevention of conduct related to illegal and illegal activities, suspected fraud, or posing a threat to the safety or security of any person or in cases of violation of the User Agreement or to defend against legal claims. Special circumstances such as compliance with subpoenas, court orders, request/order from a statutory authority.</li></ul>",
          ),
        ),
      ),
      getSliverSizedBox(),
      getSliverPadding(
        context,
        constraints,
        SliverToBoxAdapter(
          child: Cards(
            type: CardType.outline,
            // margin: const EdgeInsets.all(kDefaultPadding),
            child: (v) => Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: HeaderText(
                useRespnosiveLayout: false,
                fontSize: 20,
                text: "Our Responsibility".toUpperCase(),
                description: Html(
                  data:
                      "Although we will work to maintain the confidentiality of your personal information, transmissions via the Internet cannot be completely secure. By using this Website, you agree that we have no responsibility for disclosing your information due to any party's transmission errors or unauthorized acts of third parties.We reserve the right to change or update our policy at any time, and we will notify you of changes if this occurs. Such changes are effective immediately upon being placed on the Site.<br><br><strong>Copyright</strong><br>The content, organization, graphics, design, compilation, electronic translation, digitization, and other matters relating to the “Site” are the property of “Saffoury” and are all protected by copyright and trade name laws, and other rights including It has intellectual property rights. It is absolutely prohibited to copy, redistribute, use or print any of these materials or any part of them from the “Site” or from any other sites, except to the extent permitted by the laws in force in the Syrian Arab Republic in this regard.<br><br><strong>Brand</strong><br>All words and logos on the “Website or Application” are the property of “Al-Saffoury” whether they are registered trademarks, designs, phrases, logos and/or unregistered words and are protected by intellectual property laws. All other trademarks not owned by “Al-Saffoury” that appear on the Site are the property of their respective owners, who may or may not be affiliated with or associated with “Al-Saffoury”.<br><br>Questions? We are always happy to help with questions you may have! Check our FAQ or contact us sections for any questions.",
                ),
              ),
            ),
          ),
        ),
      ),
    ];
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomMessageTermsWhoWeAre(),
          HeaderText(
            text: "TERMS AND\nCONDITIONS",
            description: getHtmlWidget(),
          ),
          const SizedBox(height: 50.0),
          const TitleAndDescriptopnAndImage(
            title: "PRIVACY",
            description:
                "This privacy policy provides the method for collecting your data in the manner used by “Al-Saffoury Application” and we recommend that you read the privacy policy carefully. “You” consent to the collection and use of your data by the “Online Application” and some third party service providers in the manner set forth in this Privacy Policy.",
            customIconData: Icons.privacy_tip,
          ),
          HeaderText(
            fontSize: 20,
            text: "Protect your privacy".toUpperCase(),
            description: Html(
              data:
                  "You feel comfortable and secure when using our website/application and sharing your information with us, thus we are very proud of our commitment to protecting your privacy. Please continue to read the following policy to understand how your personal information is handled",
            ),
          ),
          HeaderText(
            fontSize: 20,
            text: "Privacy Guarantee".toUpperCase(),
            description: Html(
              data:
                  "Al-Saffoury promises not to sell, rent or share your personal information to any third party (except as provided in this Privacy Policy) without your consent.",
            ),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }

  SliverToBoxAdapter getTermsAndConditionSection() {
    return SliverToBoxAdapter(
      child: HeaderText(
        text: "TERMS AND\nCONDITIONS",
        description: getHtmlWidget(),
      ),
    );
  }

  Widget getPrivacySection() {
    return const SliverToBoxAdapter(
      child: TitleAndDescriptopnAndImage(
        title: "PRIVACY",
        description:
            "This privacy policy provides the method for collecting your data in the manner used by “Al-Saffoury Application” and we recommend that you read the privacy policy carefully. “You” consent to the collection and use of your data by the “Online Application” and some third party service providers in the manner set forth in this Privacy Policy.",
        customIconData: Icons.privacy_tip,
      ),
    );
  }

  Html getHtmlWidget() {
    return Html(
      data:
          "<ul><li>You must be at least 18 years old.</li><li>Have full legal capacity to contract and deal.</li><li>Anyone under the age of 18 using the <strong>Saffoury</strong> website and app needs to obtain the consent of their parent or guardian to do so.</li><li>You represent and warrant that you have the right and legal capacity to use the <strong>Saffoury</strong> website and application as provided in these Terms and Conditions.</li><li>You acknowledge that any use you make of the <strong>Saffoury</strong> application will be as stipulated in the following terms:</li><li>You will abide by the specific rules that apply to any promotion you participate in in any way through the <strong>Saffoury</strong> website and app.</li><li>You will not do anything that would affect the operation or security of the <strong>Saffoury</strong> website or app or cause undue annoyance, abuse or disruption to any other users or our employees.</li><li>You must not be a user of the <strong>Saffoury</strong> services and have been banned or banned from using the application or application.</li><li>The user and the service provider are subject to all applicable laws and regulations within the country in which the service is provided.</li><li>You must provide true and accurate information to <strong>Al-Saffoury</strong> and you must comply with any notices you make by <strong>Al-Saffoury</strong> in connection with the services provided by <strong>Al-Saffoury</strong> to ensure that they are not obstructed Any operations you perform <strong>Saffoury</strong>.</li><li>Your use of <strong>Saffoury</strong> services must not cause any harm, inconvenience, or inconvenience to anyone.</li><li>Maintain all contents and passwords to enter your account securely.</li><li>You must provide us with all the papers required of you to prove your identity or the identity of your vehicle, as determined by <strong>Al-Saffoury.</strong></li><li><strong>Saffoury</strong> has the right to refuse any service or use of the application without giving you reasons.</li><li>In order to access the <strong>Saffoury</strong> website and app, you will need Internet access. You are responsible for any connection, service or charges associated with access to the Internet and for providing all equipment necessary to enable you to connect to the Internet (including a computer, modem and other devices necessary for access) due to the limited capacity of all servers and their use by many people at a time The same, you agree not to use the <strong>Saffoury</strong> site and application in any way that would damage or exceed the endurance of our servers or any network connected to any of our servers. You must also refrain from using the <strong>Saffoury</strong> site and application in any way that leads, or may reasonably result in, to interfere with any other party's use of the <strong>Saffoury</strong> site and application in a way that contravenes, or is likely to To violate, any applicable laws, or the legal rights or entitlements of any third party in accordance with all applicable laws.</li><li>You agree to refrain from the following (whether you do them personally or through a third party):</li><li>Using an automated process to process, monitor, copy, extract any pages on the <strong>Saffoury</strong> site, or any information, content or data contained in or accessed by the <strong>Saffoury</strong> site and application., without our prior written consent.</li><li>Using an automated process to aggregate or combine information, content or data contained in or accessible via the <strong>Saffoury</strong> website and application with information, materials or data accessed by, or that is Sourced from a third party.</li><li>Using any automated process to interfere with or attempt to interfere with the proper functioning of the <strong>Saffoury</strong> website and application.</li><li>Take any action that imposes an unreasonably high or disproportionately large load on the available infrastructure or bandwidth of the <strong>spherical</strong> site and application.</li><li>Reverse engineering, reverse compiling, disassembling, or any other act of discovering source code or other algorithms or manipulations with respect to the computer software used in the infrastructure and operations of the <strong><strong>Saffoury</strong></strong> site and application.</li><li>Copy, reproduce, alter, modify, derive works from, or publicly display, any part of the <strong>Saffoury</strong> content without our prior written consent.</li></ul>",
    );
  }
}
