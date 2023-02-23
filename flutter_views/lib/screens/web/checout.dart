import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/web_checkout_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            direction:
                constraints.maxWidth >= 750 ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                  flex: constraints.maxWidth >= 750 ? 1 : 0,
                  child: Container(
                    color: Colors.green,
                  )),
              Expanded(
                  flex: constraints.maxWidth >= 750 ? 1 : 0,
                  child: WebCheckoutList()),
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
