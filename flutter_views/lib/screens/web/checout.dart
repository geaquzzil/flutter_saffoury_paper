import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/permissions/customer_billing.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/web_checkout_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'ext.dart';

class CheckoutWeb extends BaseWebPageSlivers {
  CheckoutWeb({super.key});

  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      SliverToBoxAdapter(
        child: ResponsiveWebBuilderSliver(
          builder: (context, width) => Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            direction:
                constraints.maxWidth >= 850 ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                  flex: constraints.maxWidth >= 850 ? 1 : 0,
                  child: WebCheckoutLoginCheck()),
              Expanded(
                flex: constraints.maxWidth >= 850 ? 1 : 0,
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: WebCheckoutList(),
                )),
              ),
              // const SizedBox(
              //   height: 20,
              // )
            ],
          ),
        ),
      )
    ];
  }
}

class WebCheckoutLoginCheck extends StatelessWidget {
  const WebCheckoutLoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // BaseEditWidget(
    //                 viewAbstract: BillingCustomer(),
    //                 onValidate: (viewAbstract) {},
    //                 isTheFirst: true,
    //               )
    return SignInPageWithoutHeaders(
      onPressRegister: () => context.goNamed(IndexWebRegister),
    );
  }
}
