import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/permissions/customer_billing.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_descriptopn_header.dart';
import 'package:flutter_view_controller/screens/web/base.dart';

import 'components/web_button.dart';
import 'web_checkout_list.dart';

class RegisterWebPage extends BaseWebPageSlivers {
  BillingCustomer c = BillingCustomer();
  ValueNotifier<bool> hasAggreeTerms = ValueNotifier<bool>(false);
  ValueNotifier<bool> showButton = ValueNotifier<bool>(false);
  ValueNotifier<ViewAbstract?> billingCustomerNotifier =
      ValueNotifier<ViewAbstract?>(null);
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
                    onValidate: (viewAbstract) {
                      billingCustomerNotifier.value = viewAbstract;
                    },
                    isTheFirst: true,
                  ),
                  AgreeToTerms(hasAgreeToTerms: hasAggreeTerms),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: hasAggreeTerms,
                      builder: (context, hasAgree, child) =>
                          ValueListenableBuilder<ViewAbstract?>(
                        valueListenable: billingCustomerNotifier,
                        builder: (context, validated, child) {
                          showButton.value = validated != null && hasAgree;

                          return WebButtonAnimated(
                            isChanged: showButton,
                            from: Colors.grey,
                            to: kPrimaryColor,
                            child: (color) {
                              debugPrint("colorTween $color");
                              return WebButton(
                                title: "SIGN UP",
                                color: color,
                                onPressed: hasAgree && validated != null
                                    ? () {}
                                    : null,
                              );
                            },
                          );
                          return AnimatedScale(
                            duration: const Duration(milliseconds: 275),
                            scale: validated != null && hasAgree ? 1 : 0,
                            child: WebButton(
                              width: double.infinity,
                              title: "SIGN UP",
                              onPressed: hasAgree ? () {} : null,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          padd: 1.2),
    ];
  }
}
