import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/customer_billing.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_descriptopn_header.dart';
import 'package:flutter_view_controller/screens/web/base.dart';

import 'components/web_button.dart';
import 'web_checkout_list.dart';

class RegisterWebPage extends BaseWebPageSlivers {
  BillingCustomer c = BillingCustomer();
  ValueNotifier<bool> hasAggreeTerms = ValueNotifier<bool>(false);
  RegisterWebPage({super.key});

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      getSliverPadding(
          context,
          constraints,
          SliverToBoxAdapter(
            child: CardBackgroundWithTitle(
              centerTitle: true,
              title: "Register",
              child: Column(
                children: [
                  BaseEditWidget(
                    viewAbstract: c,
                    onValidate: (viewAbstract) {},
                    isTheFirst: true,
                  ),
                  AgreeToTerms(hasAgreeToTerms: hasAggreeTerms),
                  ValueListenableBuilder<bool>(
                    valueListenable: hasAggreeTerms,
                    builder: (context, hasAgree, child) => WebButton(
                      width: double.infinity,
                      title: "SIGN UP",
                      onPressed: hasAgree ? () {} : null,
                    ),
                  )
                ],
              ),
            ),
          ),
          padd: 1.5),
    ];
  }
}
