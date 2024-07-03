// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';
import 'package:flutter_view_controller/screens/web/components/terms/terms_who_we_are.dart';

class ReturnPrivecyPolicyWebPage extends BaseWebPageSlivers {
  ReturnPrivecyPolicyWebPage({super.key});

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      const SliverToBoxAdapter(
        child: WelcomMessageTermsWhoWeAre(useForReturnPolicy: true),
      ),
      getSliverPadding(
          context,
          constraints,
          SliverToBoxAdapter(
            child: HeaderText(
              useRespnosiveLayout: false,
              text: "Return Policy",
              description: Html(
                  data:
                      "Thank you for shopping at Saffoury !<br><br>Please note that at this time, refunds are not possible. Only replacements with items of the same or higher value are accepted. The following terms are applicable for any products that You purchased with Us"),
            ),
          )),
      getSliverPadding(
          context,
          constraints,
          SliverToBoxAdapter(
            child: HeaderText(
              useRespnosiveLayout: false,
              text: "Your Order Cancellation Rights",
              description: Html(
                  data:
                      "<h2><strong>Cancelling before your order has shipped</strong></h2>You are entitled to cancel Your Order before it was shipped, without incurring any extra fees.<br><br><h2><strong>Cancelling <u>after</u> your order has shipped</strong></h2>In the case where you cancel after your order has been sent for delivery, the delivery fee is incurred on you, because we are charged for the delivery fee of your order once we send it, and it is not re-imbursable.<br><br><h2><strong>Conditions for Returns</strong></h2>In order for the Goods to be eligible for a return, please make sure that:<ul><li>The Goods were purchased in the last 2 days</li><li>The Goods are in the original packaging and never opened.</li></ul><br>We reserve the right to refuse returns of any merchandise that does not meet the above return conditions in our sole discretion.<h2><strong>Returning Goods</strong></h2>You are responsible for the cost and risk of returning the Goods to Us."),
            ),
          )),
    ];
  }
}
